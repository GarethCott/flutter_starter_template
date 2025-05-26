import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state enum
enum ConnectivityStatus {
  /// Device is connected to the internet
  connected,

  /// Device is not connected to the internet
  disconnected,

  /// Connectivity status is unknown
  unknown,
}

/// Connectivity state class
class ConnectivityState {
  final ConnectivityStatus status;
  final ConnectivityResult connectivityResult;
  final DateTime lastUpdated;

  const ConnectivityState({
    required this.status,
    required this.connectivityResult,
    required this.lastUpdated,
  });

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    ConnectivityResult? connectivityResult,
    DateTime? lastUpdated,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      connectivityResult: connectivityResult ?? this.connectivityResult,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Whether the device is connected to the internet
  bool get isConnected => status == ConnectivityStatus.connected;

  /// Whether the device is disconnected from the internet
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  /// Whether the device is connected via WiFi
  bool get isWifi => connectivityResult == ConnectivityResult.wifi;

  /// Whether the device is connected via mobile data
  bool get isMobile => connectivityResult == ConnectivityResult.mobile;

  /// Whether the device is connected via ethernet
  bool get isEthernet => connectivityResult == ConnectivityResult.ethernet;

  /// Get a human-readable connection type
  String get connectionType {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  /// Get connection type icon
  String get connectionIcon {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return '📶';
      case ConnectivityResult.mobile:
        return '📱';
      case ConnectivityResult.ethernet:
        return '🔌';
      case ConnectivityResult.bluetooth:
        return '🔵';
      case ConnectivityResult.vpn:
        return '🔒';
      case ConnectivityResult.other:
        return '🌐';
      case ConnectivityResult.none:
        return '❌';
      default:
        return '❓';
    }
  }

  /// Check if connection is suitable for heavy operations
  bool get isSuitableForHeavyOperations {
    return isWifi || isEthernet;
  }

  /// Check if connection is metered (mobile data)
  bool get isMetered {
    return isMobile || connectivityResult == ConnectivityResult.bluetooth;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectivityState &&
        other.status == status &&
        other.connectivityResult == connectivityResult;
  }

  @override
  int get hashCode => Object.hash(status, connectivityResult);

  @override
  String toString() {
    return 'ConnectivityState(status: $status, type: $connectionType)';
  }
}

/// Connectivity notifier that manages network connectivity state
class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  ConnectivityNotifier()
      : super(
          ConnectivityState(
            status: ConnectivityStatus.unknown,
            connectivityResult: ConnectivityResult.none,
            lastUpdated: DateTime.now(),
          ),
        ) {
    _initialize();
  }

  late final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Future<void> _initialize() async {
    _connectivity = Connectivity();

    // Get initial connectivity status
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) {
        // Handle connectivity stream errors
        state = state.copyWith(
          status: ConnectivityStatus.unknown,
          lastUpdated: DateTime.now(),
        );
      },
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _onConnectivityChanged(result);
    } catch (e) {
      state = state.copyWith(
        status: ConnectivityStatus.unknown,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    final status = _determineConnectivityStatus(result);

    state = state.copyWith(
      status: status,
      connectivityResult: result,
      lastUpdated: DateTime.now(),
    );
  }

  ConnectivityStatus _determineConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      return ConnectivityStatus.disconnected;
    }

    // Check for actual connectivity types
    final hasConnection = result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet;

    return hasConnection
        ? ConnectivityStatus.connected
        : ConnectivityStatus.disconnected;
  }

  /// Manually refresh connectivity status
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

/// Provider for connectivity state
final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>((ref) {
  return ConnectivityNotifier();
});

/// Convenience provider for connectivity status
final connectivityStatusProvider = Provider<ConnectivityStatus>((ref) {
  return ref.watch(connectivityProvider).status;
});

/// Convenience provider for checking if connected
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).isConnected;
});

/// Convenience provider for connection type
final connectionTypeProvider = Provider<String>((ref) {
  return ref.watch(connectivityProvider).connectionType;
});

/// Provider for connectivity actions
final connectivityActionsProvider = Provider<ConnectivityActions>((ref) {
  return ConnectivityActions(ref);
});

/// Actions class for connectivity operations
class ConnectivityActions {
  final Ref _ref;

  ConnectivityActions(this._ref);

  /// Refresh connectivity status
  Future<void> refresh() async {
    await _ref.read(connectivityProvider.notifier).refresh();
  }

  /// Check if connected and show message if not
  bool checkConnectionWithMessage(void Function(String message) showMessage) {
    final isConnected = _ref.read(isConnectedProvider);
    if (!isConnected) {
      showMessage(
          'No internet connection. Please check your network settings.');
    }
    return isConnected;
  }

  /// Check if connection is suitable for heavy operations
  bool checkConnectionForHeavyOperations(
      void Function(String message) showMessage) {
    final connectivityState = _ref.read(connectivityProvider);

    if (!connectivityState.isConnected) {
      showMessage('No internet connection available.');
      return false;
    }

    if (!connectivityState.isSuitableForHeavyOperations) {
      showMessage('This operation requires a WiFi or Ethernet connection. '
          'You are currently connected via ${connectivityState.connectionType}.');
      return false;
    }

    return true;
  }

  /// Check if connection is metered and warn user
  bool checkMeteredConnection(void Function(String message) showWarning) {
    final connectivityState = _ref.read(connectivityProvider);

    if (connectivityState.isMetered) {
      showWarning('You are using ${connectivityState.connectionType}. '
          'Data charges may apply for this operation.');
      return true;
    }

    return false;
  }

  /// Get connection quality description
  String getConnectionQualityDescription() {
    final connectivityState = _ref.read(connectivityProvider);

    if (!connectivityState.isConnected) {
      return 'No connection';
    }

    switch (connectivityState.connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return 'Excellent connection';
      case ConnectivityResult.mobile:
        return 'Good connection';
      case ConnectivityResult.vpn:
        return 'Secure connection';
      case ConnectivityResult.bluetooth:
        return 'Limited connection';
      default:
        return 'Basic connection';
    }
  }

  /// Retry operation with connectivity check
  Future<T?> retryWithConnectivity<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    void Function(String message)? onError,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      // Check connectivity before each attempt
      if (!_ref.read(isConnectedProvider)) {
        await refresh();

        if (!_ref.read(isConnectedProvider)) {
          onError?.call(
              'No internet connection. Attempt ${attempt + 1} of $maxRetries');

          if (attempt < maxRetries - 1) {
            await Future.delayed(delay * (attempt + 1));
            continue;
          } else {
            onError?.call(
                'Operation failed: No internet connection after $maxRetries attempts');
            return null;
          }
        }
      }

      try {
        return await operation();
      } catch (e) {
        onError?.call('Attempt ${attempt + 1} failed: $e');

        if (attempt < maxRetries - 1) {
          await Future.delayed(delay * (attempt + 1));
        } else {
          onError?.call('Operation failed after $maxRetries attempts');
          rethrow;
        }
      }
    }

    return null;
  }

  /// Wait for connection to be restored
  Future<bool> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
    void Function(String message)? onStatusUpdate,
  }) async {
    if (_ref.read(isConnectedProvider)) {
      return true;
    }

    onStatusUpdate?.call('Waiting for internet connection...');

    final completer = Completer<bool>();
    late final StreamSubscription subscription;

    // Set up timeout
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.complete(false);
        onStatusUpdate?.call('Connection timeout');
      }
    });

    // Listen for connectivity changes
    subscription =
        _ref.read(connectivityProvider.notifier).stream.listen((state) {
      if (state.isConnected && !completer.isCompleted) {
        timer.cancel();
        subscription.cancel();
        completer.complete(true);
        onStatusUpdate?.call('Connection restored');
      }
    });

    // Check current state one more time
    await refresh();
    if (_ref.read(isConnectedProvider) && !completer.isCompleted) {
      timer.cancel();
      subscription.cancel();
      completer.complete(true);
      onStatusUpdate?.call('Connection available');
    }

    return completer.future;
  }

  /// Get detailed connection information
  Map<String, dynamic> getConnectionInfo() {
    final connectivityState = _ref.read(connectivityProvider);

    return {
      'isConnected': connectivityState.isConnected,
      'connectionType': connectivityState.connectionType,
      'connectionIcon': connectivityState.connectionIcon,
      'isWifi': connectivityState.isWifi,
      'isMobile': connectivityState.isMobile,
      'isEthernet': connectivityState.isEthernet,
      'isMetered': connectivityState.isMetered,
      'isSuitableForHeavyOperations':
          connectivityState.isSuitableForHeavyOperations,
      'qualityDescription': getConnectionQualityDescription(),
      'lastUpdated': connectivityState.lastUpdated.toIso8601String(),
    };
  }
}
