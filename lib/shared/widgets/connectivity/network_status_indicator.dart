import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/connectivity_provider.dart';

/// Network status indicator widget that shows connectivity status
class NetworkStatusIndicator extends ConsumerWidget {
  const NetworkStatusIndicator({
    super.key,
    this.showWhenConnected = false,
    this.compact = false,
    this.showConnectionType = true,
  });

  /// Whether to show the indicator when connected (default: false, only shows when disconnected)
  final bool showWhenConnected;

  /// Whether to use compact layout
  final bool compact;

  /// Whether to show connection type details
  final bool showConnectionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    // Only show when disconnected unless showWhenConnected is true
    if (!showWhenConnected && connectivityState.isConnected) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(connectivityState.status, theme),
        borderRadius: BorderRadius.circular(compact ? 4 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(
                connectivityState.status, connectivityState.connectivityResult),
            size: compact ? 16 : 20,
            color: _getIconColor(connectivityState.status, theme),
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            Text(
              _getMessage(connectivityState),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getTextColor(connectivityState.status, theme),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(ConnectivityStatus status, ThemeData theme) {
    switch (status) {
      case ConnectivityStatus.connected:
        return theme.colorScheme.primaryContainer;
      case ConnectivityStatus.disconnected:
        return theme.colorScheme.errorContainer;
      case ConnectivityStatus.unknown:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getIconColor(ConnectivityStatus status, ThemeData theme) {
    switch (status) {
      case ConnectivityStatus.connected:
        return theme.colorScheme.onPrimaryContainer;
      case ConnectivityStatus.disconnected:
        return theme.colorScheme.onErrorContainer;
      case ConnectivityStatus.unknown:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getTextColor(ConnectivityStatus status, ThemeData theme) {
    switch (status) {
      case ConnectivityStatus.connected:
        return theme.colorScheme.onPrimaryContainer;
      case ConnectivityStatus.disconnected:
        return theme.colorScheme.onErrorContainer;
      case ConnectivityStatus.unknown:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getIcon(ConnectivityStatus status, connectivityResult) {
    if (status == ConnectivityStatus.disconnected) {
      return Icons.wifi_off;
    }

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.ethernet:
        return Icons.cable;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.vpn:
        return Icons.vpn_lock;
      case ConnectivityResult.other:
        return Icons.device_hub;
      default:
        return Icons.signal_wifi_statusbar_null;
    }
  }

  String _getMessage(ConnectivityState state) {
    switch (state.status) {
      case ConnectivityStatus.connected:
        if (showConnectionType) {
          return 'Connected via ${state.connectionType}';
        }
        return 'Connected';
      case ConnectivityStatus.disconnected:
        return 'No internet connection';
      case ConnectivityStatus.unknown:
        return 'Checking connection...';
    }
  }
}

/// Compact network status indicator for use in app bars
class CompactNetworkStatusIndicator extends StatelessWidget {
  const CompactNetworkStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const NetworkStatusIndicator(
      compact: true,
      showWhenConnected: false,
    );
  }
}
