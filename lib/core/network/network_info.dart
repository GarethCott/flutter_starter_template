/// Network connectivity information and utilities
///
/// Provides methods to check network connectivity status and monitor
/// network changes throughout the application.
library;

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity information and utilities
abstract class NetworkInfo {
  /// Check if the device is currently connected to the internet
  Future<bool> get isConnected;

  /// Get the current connectivity status
  Future<ConnectivityResult> get connectivityStatus;

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged;

  /// Check if connected to WiFi
  Future<bool> get isConnectedToWiFi;

  /// Check if connected to mobile data
  Future<bool> get isConnectedToMobile;

  /// Perform a ping test to verify actual internet connectivity
  Future<bool> hasInternetAccess();
}

/// Implementation of NetworkInfo using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await connectivityStatus;
    return result != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityStatus async {
    return await _connectivity.checkConnectivity();
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  @override
  Future<bool> get isConnectedToWiFi async {
    final result = await connectivityStatus;
    return result == ConnectivityResult.wifi;
  }

  @override
  Future<bool> get isConnectedToMobile async {
    final result = await connectivityStatus;
    return result == ConnectivityResult.mobile;
  }

  @override
  Future<bool> hasInternetAccess() async {
    try {
      // First check basic connectivity
      if (!await isConnected) {
        return false;
      }

      // Perform actual internet connectivity test
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Network status enumeration for easier handling
enum NetworkStatus {
  /// Connected to WiFi with internet access
  connectedWiFi,

  /// Connected to mobile data with internet access
  connectedMobile,

  /// Connected but no internet access
  connectedNoInternet,

  /// No network connection
  disconnected,
}

/// Extended network info with additional utilities
class ExtendedNetworkInfo extends NetworkInfoImpl {
  ExtendedNetworkInfo({super.connectivity});

  /// Get detailed network status
  Future<NetworkStatus> getNetworkStatus() async {
    final connectivityResult = await connectivityStatus;

    switch (connectivityResult) {
      case ConnectivityResult.none:
        return NetworkStatus.disconnected;

      case ConnectivityResult.wifi:
        final hasInternet = await hasInternetAccess();
        return hasInternet
            ? NetworkStatus.connectedWiFi
            : NetworkStatus.connectedNoInternet;

      case ConnectivityResult.mobile:
        final hasInternet = await hasInternetAccess();
        return hasInternet
            ? NetworkStatus.connectedMobile
            : NetworkStatus.connectedNoInternet;

      default:
        return NetworkStatus.disconnected;
    }
  }

  /// Get network type as a human-readable string
  Future<String> getNetworkTypeString() async {
    final status = await getNetworkStatus();

    switch (status) {
      case NetworkStatus.connectedWiFi:
        return 'WiFi';
      case NetworkStatus.connectedMobile:
        return 'Mobile Data';
      case NetworkStatus.connectedNoInternet:
        return 'Connected (No Internet)';
      case NetworkStatus.disconnected:
        return 'Disconnected';
    }
  }

  /// Check if network is suitable for heavy operations (like file uploads)
  Future<bool> isSuitableForHeavyOperations() async {
    final status = await getNetworkStatus();
    // Only allow heavy operations on WiFi or if explicitly on mobile
    return status == NetworkStatus.connectedWiFi;
  }

  /// Get connection strength indicator (basic implementation)
  Future<ConnectionStrength> getConnectionStrength() async {
    final status = await getNetworkStatus();

    switch (status) {
      case NetworkStatus.connectedWiFi:
        // For WiFi, we assume good connection
        // In a real app, you might want to measure actual speed
        return ConnectionStrength.good;

      case NetworkStatus.connectedMobile:
        // For mobile, we assume fair connection
        // In a real app, you might want to check network type (3G, 4G, 5G)
        return ConnectionStrength.fair;

      case NetworkStatus.connectedNoInternet:
        return ConnectionStrength.poor;

      case NetworkStatus.disconnected:
        return ConnectionStrength.none;
    }
  }
}

/// Connection strength enumeration
enum ConnectionStrength {
  /// No connection
  none,

  /// Poor connection (connected but no internet)
  poor,

  /// Fair connection (mobile data)
  fair,

  /// Good connection (WiFi)
  good,

  /// Excellent connection (high-speed WiFi)
  excellent,
}

/// Network monitoring mixin for easy integration
mixin NetworkMonitoring {
  late final NetworkInfo _networkInfo;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// Initialize network monitoring
  void initNetworkMonitoring({NetworkInfo? networkInfo}) {
    _networkInfo = networkInfo ?? ExtendedNetworkInfo();
    _startMonitoring();
  }

  /// Dispose network monitoring
  void disposeNetworkMonitoring() {
    _connectivitySubscription?.cancel();
  }

  /// Called when network status changes
  void onNetworkStatusChanged(ConnectivityResult result) {
    // Override in implementing classes
  }

  /// Start monitoring network changes
  void _startMonitoring() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen(
      onNetworkStatusChanged,
    );
  }

  /// Get current network info instance
  NetworkInfo get networkInfo => _networkInfo;
}
