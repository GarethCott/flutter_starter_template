import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/connectivity_provider.dart';

/// Enhanced offline mode widget with comprehensive user feedback
class OfflineModeWidget extends ConsumerStatefulWidget {
  const OfflineModeWidget({
    super.key,
    this.child,
    this.showOfflineMessage = true,
    this.enableOfflineMode = true,
    this.onRetry,
  });

  final Widget? child;
  final bool showOfflineMessage;
  final bool enableOfflineMode;
  final VoidCallback? onRetry;

  @override
  ConsumerState<OfflineModeWidget> createState() => _OfflineModeWidgetState();
}

class _OfflineModeWidgetState extends ConsumerState<OfflineModeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityState = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    // Show animation when offline
    if (!connectivityState.isConnected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return Stack(
      children: [
        // Main content
        if (widget.child != null) widget.child!,

        // Offline overlay
        if (!connectivityState.isConnected && widget.showOfflineMessage)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              color: theme.colorScheme.surface.withOpacity(0.9),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You\'re Offline',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your internet connection and try again.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.enableOfflineMode) ...[
                              OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Enable offline mode
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Offline mode enabled'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.offline_bolt),
                                label: const Text('Work Offline'),
                              ),
                              const SizedBox(width: 12),
                            ],
                            ElevatedButton.icon(
                              onPressed: _isRetrying ? null : _handleRetry,
                              icon: _isRetrying
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                              label:
                                  Text(_isRetrying ? 'Retrying...' : 'Retry'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      // Refresh connectivity status
      await ref.read(connectivityActionsProvider).refresh();

      // Call custom retry callback if provided
      widget.onRetry?.call();

      // Wait a bit to show the retry animation
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }
}
