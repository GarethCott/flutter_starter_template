import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/connectivity_provider.dart';

/// Network retry button widget
class NetworkRetryButton extends ConsumerStatefulWidget {
  const NetworkRetryButton({
    super.key,
    required this.onRetry,
    this.text = 'Retry',
    this.icon = Icons.refresh,
    this.style,
  });

  final Future<void> Function() onRetry;
  final String text;
  final IconData icon;
  final ButtonStyle? style;

  @override
  ConsumerState<NetworkRetryButton> createState() => _NetworkRetryButtonState();
}

class _NetworkRetryButtonState extends ConsumerState<NetworkRetryButton> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final connectivityState = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed:
          _isRetrying || connectivityState.isConnected ? null : _handleRetry,
      style: widget.style,
      icon: _isRetrying
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Icon(widget.icon),
      label: Text(_isRetrying ? 'Retrying...' : widget.text),
    );
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }
}
