import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import '../error/app_error.dart';

/// File caching and management system
class CacheManager {
  static const String _cacheDir = 'app_cache';
  static const String _imagesCacheDir = 'images';
  static const String _dataCacheDir = 'data';
  static const String _tempCacheDir = 'temp';
  static const int _defaultMaxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int _defaultMaxCacheAge =
      7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds

  static Directory? _cacheDirectory;
  static Directory? _imagesDirectory;
  static Directory? _dataDirectory;
  static Directory? _tempDirectory;

  /// Initialize cache directories
  static Future<void> init() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${appDir.path}/$_cacheDir');
      _imagesDirectory = Directory('${_cacheDirectory!.path}/$_imagesCacheDir');
      _dataDirectory = Directory('${_cacheDirectory!.path}/$_dataCacheDir');
      _tempDirectory = Directory('${_cacheDirectory!.path}/$_tempCacheDir');

      // Create directories if they don't exist
      await _cacheDirectory!.create(recursive: true);
      await _imagesDirectory!.create(recursive: true);
      await _dataDirectory!.create(recursive: true);
      await _tempDirectory!.create(recursive: true);
    } catch (e) {
      throw StorageError(message: 'Failed to initialize cache directories: $e');
    }
  }

  /// Generate cache key from URL or identifier
  static String _generateCacheKey(String identifier) {
    final bytes = utf8.encode(identifier);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Get cache file path
  static String _getCacheFilePath(String key, String subDir) {
    final directory = subDir == _imagesCacheDir
        ? _imagesDirectory
        : subDir == _dataCacheDir
            ? _dataDirectory
            : _tempDirectory;
    return '${directory!.path}/$key';
  }

  /// Check if cache directory is initialized
  static void _ensureInitialized() {
    if (_cacheDirectory == null) {
      throw StorageError(
          message:
              'CacheManager not initialized. Call CacheManager.init() first.');
    }
  }

  // Image caching methods
  /// Cache image data
  static Future<void> cacheImage(String url, Uint8List imageData) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(url);
      final filePath = _getCacheFilePath(key, _imagesCacheDir);
      final file = File(filePath);
      await file.writeAsBytes(imageData);

      // Store metadata
      await _storeCacheMetadata(key, _imagesCacheDir, {
        'url': url,
        'size': imageData.length,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
        'type': 'image',
      });
    } catch (e) {
      throw StorageError(message: 'Failed to cache image: $e');
    }
  }

  /// Get cached image data
  static Future<Uint8List?> getCachedImage(String url) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(url);
      final filePath = _getCacheFilePath(key, _imagesCacheDir);
      final file = File(filePath);

      if (!await file.exists()) return null;

      // Check if cache is still valid
      final metadata = await _getCacheMetadata(key, _imagesCacheDir);
      if (metadata != null && _isCacheExpired(metadata)) {
        await _deleteCacheFile(key, _imagesCacheDir);
        return null;
      }

      return await file.readAsBytes();
    } catch (e) {
      throw StorageError(message: 'Failed to get cached image: $e');
    }
  }

  /// Check if image is cached
  static Future<bool> isImageCached(String url) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(url);
      final filePath = _getCacheFilePath(key, _imagesCacheDir);
      final file = File(filePath);

      if (!await file.exists()) return false;

      // Check if cache is still valid
      final metadata = await _getCacheMetadata(key, _imagesCacheDir);
      if (metadata != null && _isCacheExpired(metadata)) {
        await _deleteCacheFile(key, _imagesCacheDir);
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Data caching methods
  /// Cache JSON data
  static Future<void> cacheData(
      String identifier, Map<String, dynamic> data) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(identifier);
      final filePath = _getCacheFilePath(key, _dataCacheDir);
      final file = File(filePath);
      final jsonString = jsonEncode(data);
      await file.writeAsString(jsonString);

      // Store metadata
      await _storeCacheMetadata(key, _dataCacheDir, {
        'identifier': identifier,
        'size': jsonString.length,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
        'type': 'data',
      });
    } catch (e) {
      throw StorageError(message: 'Failed to cache data: $e');
    }
  }

  /// Get cached JSON data
  static Future<Map<String, dynamic>?> getCachedData(String identifier) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(identifier);
      final filePath = _getCacheFilePath(key, _dataCacheDir);
      final file = File(filePath);

      if (!await file.exists()) return null;

      // Check if cache is still valid
      final metadata = await _getCacheMetadata(key, _dataCacheDir);
      if (metadata != null && _isCacheExpired(metadata)) {
        await _deleteCacheFile(key, _dataCacheDir);
        return null;
      }

      final jsonString = await file.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw StorageError(message: 'Failed to get cached data: $e');
    }
  }

  /// Check if data is cached
  static Future<bool> isDataCached(String identifier) async {
    _ensureInitialized();
    try {
      final key = _generateCacheKey(identifier);
      final filePath = _getCacheFilePath(key, _dataCacheDir);
      final file = File(filePath);

      if (!await file.exists()) return false;

      // Check if cache is still valid
      final metadata = await _getCacheMetadata(key, _dataCacheDir);
      if (metadata != null && _isCacheExpired(metadata)) {
        await _deleteCacheFile(key, _dataCacheDir);
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Temporary file methods
  /// Create temporary file
  static Future<File> createTempFile(String fileName) async {
    _ensureInitialized();
    try {
      final filePath = '${_tempDirectory!.path}/$fileName';
      final file = File(filePath);
      await file.create();
      return file;
    } catch (e) {
      throw StorageError(message: 'Failed to create temporary file: $e');
    }
  }

  /// Get temporary file
  static File getTempFile(String fileName) {
    _ensureInitialized();
    return File('${_tempDirectory!.path}/$fileName');
  }

  // Cache management methods
  /// Store cache metadata
  static Future<void> _storeCacheMetadata(
      String key, String subDir, Map<String, dynamic> metadata) async {
    try {
      final metadataPath = '${_getCacheFilePath(key, subDir)}.meta';
      final metadataFile = File(metadataPath);
      await metadataFile.writeAsString(jsonEncode(metadata));
    } catch (e) {
      // Metadata storage failure shouldn't break caching
    }
  }

  /// Get cache metadata
  static Future<Map<String, dynamic>?> _getCacheMetadata(
      String key, String subDir) async {
    try {
      final metadataPath = '${_getCacheFilePath(key, subDir)}.meta';
      final metadataFile = File(metadataPath);

      if (!await metadataFile.exists()) return null;

      final jsonString = await metadataFile.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if cache is expired
  static bool _isCacheExpired(Map<String, dynamic> metadata, [int? maxAge]) {
    final cachedAt = metadata['cached_at'] as int?;
    if (cachedAt == null) return true;

    final age = DateTime.now().millisecondsSinceEpoch - cachedAt;
    final maxCacheAge = maxAge ?? _defaultMaxCacheAge;
    return age > maxCacheAge;
  }

  /// Delete cache file and its metadata
  static Future<void> _deleteCacheFile(String key, String subDir) async {
    try {
      final filePath = _getCacheFilePath(key, subDir);
      final file = File(filePath);
      final metadataFile = File('$filePath.meta');

      if (await file.exists()) await file.delete();
      if (await metadataFile.exists()) await metadataFile.delete();
    } catch (e) {
      // Deletion failure shouldn't break the app
    }
  }

  /// Get cache size in bytes
  static Future<int> getCacheSize() async {
    _ensureInitialized();
    try {
      int totalSize = 0;

      final directories = [_imagesDirectory!, _dataDirectory!, _tempDirectory!];

      for (final directory in directories) {
        if (await directory.exists()) {
          await for (final entity in directory.list(recursive: true)) {
            if (entity is File) {
              final stat = await entity.stat();
              totalSize += stat.size;
            }
          }
        }
      }

      return totalSize;
    } catch (e) {
      throw StorageError(message: 'Failed to calculate cache size: $e');
    }
  }

  /// Clear expired cache files
  static Future<void> clearExpiredCache() async {
    _ensureInitialized();
    try {
      final directories = [
        (_imagesDirectory!, _imagesCacheDir),
        (_dataDirectory!, _dataCacheDir),
        (_tempDirectory!, _tempCacheDir),
      ];

      for (final (directory, subDir) in directories) {
        if (await directory.exists()) {
          await for (final entity in directory.list()) {
            if (entity is File && !entity.path.endsWith('.meta')) {
              final fileName = entity.path.split('/').last;
              final metadata = await _getCacheMetadata(fileName, subDir);

              if (metadata != null && _isCacheExpired(metadata)) {
                await _deleteCacheFile(fileName, subDir);
              }
            }
          }
        }
      }
    } catch (e) {
      throw StorageError(message: 'Failed to clear expired cache: $e');
    }
  }

  /// Clear all cache
  static Future<void> clearAllCache() async {
    _ensureInitialized();
    try {
      if (await _cacheDirectory!.exists()) {
        await _cacheDirectory!.delete(recursive: true);
        await init(); // Recreate directories
      }
    } catch (e) {
      throw StorageError(message: 'Failed to clear all cache: $e');
    }
  }

  /// Clear cache by type
  static Future<void> clearCacheByType(String type) async {
    _ensureInitialized();
    try {
      Directory? targetDirectory;
      String subDir;

      switch (type) {
        case 'images':
          targetDirectory = _imagesDirectory;
          subDir = _imagesCacheDir;
          break;
        case 'data':
          targetDirectory = _dataDirectory;
          subDir = _dataCacheDir;
          break;
        case 'temp':
          targetDirectory = _tempDirectory;
          subDir = _tempCacheDir;
          break;
        default:
          throw StorageError(message: 'Invalid cache type: $type');
      }

      if (await targetDirectory!.exists()) {
        await targetDirectory.delete(recursive: true);
        await targetDirectory.create(recursive: true);
      }
    } catch (e) {
      throw StorageError(message: 'Failed to clear cache by type: $e');
    }
  }

  /// Cleanup cache if it exceeds size limit
  static Future<void> cleanupCacheIfNeeded([int? maxSize]) async {
    _ensureInitialized();
    try {
      final currentSize = await getCacheSize();
      final maxCacheSize = maxSize ?? _defaultMaxCacheSize;

      if (currentSize > maxCacheSize) {
        // First, clear expired cache
        await clearExpiredCache();

        // If still over limit, clear oldest files
        final newSize = await getCacheSize();
        if (newSize > maxCacheSize) {
          await _clearOldestFiles(newSize - maxCacheSize);
        }
      }
    } catch (e) {
      throw StorageError(message: 'Failed to cleanup cache: $e');
    }
  }

  /// Clear oldest files to free up space
  static Future<void> _clearOldestFiles(int bytesToFree) async {
    try {
      final files = <FileSystemEntity>[];
      final directories = [_imagesDirectory!, _dataDirectory!, _tempDirectory!];

      for (final directory in directories) {
        if (await directory.exists()) {
          await for (final entity in directory.list()) {
            if (entity is File && !entity.path.endsWith('.meta')) {
              files.add(entity);
            }
          }
        }
      }

      // Sort by last modified date (oldest first)
      files.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return aStat.modified.compareTo(bStat.modified);
      });

      int freedBytes = 0;
      for (final file in files) {
        if (freedBytes >= bytesToFree) break;

        final stat = file.statSync();
        freedBytes += stat.size;

        await file.delete();

        // Also delete metadata file if exists
        final metadataFile = File('${file.path}.meta');
        if (await metadataFile.exists()) {
          await metadataFile.delete();
        }
      }
    } catch (e) {
      // Don't throw error for cleanup operations
    }
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    _ensureInitialized();
    try {
      final stats = <String, dynamic>{};

      final directories = [
        ('images', _imagesDirectory!),
        ('data', _dataDirectory!),
        ('temp', _tempDirectory!),
      ];

      int totalFiles = 0;
      int totalSize = 0;

      for (final (type, directory) in directories) {
        int typeFiles = 0;
        int typeSize = 0;

        if (await directory.exists()) {
          await for (final entity in directory.list()) {
            if (entity is File && !entity.path.endsWith('.meta')) {
              typeFiles++;
              final stat = await entity.stat();
              typeSize += stat.size;
            }
          }
        }

        stats[type] = {
          'files': typeFiles,
          'size': typeSize,
        };

        totalFiles += typeFiles;
        totalSize += typeSize;
      }

      stats['total'] = {
        'files': totalFiles,
        'size': totalSize,
      };

      return stats;
    } catch (e) {
      throw StorageError(message: 'Failed to get cache statistics: $e');
    }
  }
}
