import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/connectivity_provider.dart';

/// Connection quality enumeration
enum ConnectionQuality {
  poor,
  fair,
  good,
  excellent,
}

/// Connection quality indicator widget
class ConnectionQualityIndicator extends ConsumerWidget {
  const ConnectionQualityIndicator({
    super.key,
    this.showLabel = true,
  });

  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    if (!connectivityState.isConnected) {
      return const SizedBox.shrink();
    }

    final quality = _getConnectionQuality(connectivityState.connectivityResult);
    final color = _getQualityColor(quality, theme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSignalBars(quality, color),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            _getQualityLabel(quality),
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  ConnectionQuality _getConnectionQuality(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionQuality.excellent;
      case ConnectivityResult.ethernet:
        return ConnectionQuality.excellent;
      case ConnectivityResult.mobile:
        return ConnectionQuality
            .good; // Could be enhanced with actual signal strength
      case ConnectivityResult.bluetooth:
        return ConnectionQuality.fair;
      case ConnectivityResult.vpn:
        return ConnectionQuality.good;
      default:
        return ConnectionQuality.poor;
    }
  }

  Color _getQualityColor(ConnectionQuality quality, ThemeData theme) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return Colors.green;
      case ConnectionQuality.good:
        return Colors.lightGreen;
      case ConnectionQuality.fair:
        return Colors.orange;
      case ConnectionQuality.poor:
        return theme.colorScheme.error;
    }
  }

  String _getQualityLabel(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.fair:
        return 'Fair';
      case ConnectionQuality.poor:
        return 'Poor';
    }
  }

  Widget _buildSignalBars(ConnectionQuality quality, Color color) {
    final barCount = quality.index + 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isActive = index < barCount;
        return Container(
          width: 3,
          height: 8 + (index * 2),
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
