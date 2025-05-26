import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../config/flavor_config.dart';
import 'error_tracker.dart';

/// User-friendly error dialog components
///
/// Provides consistent error presentation to users while
/// integrating with the error tracking and logging systems.
class ErrorDialog {
  /// Show a generic error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    String? userId,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    bool canRetry = false,
    bool showDetails = false,
  }) async {
    // Track the error
    await ErrorTracker.instance.trackUIError(
      widget: 'ErrorDialog',
      error: error ?? Exception(message),
      stackTrace: stackTrace,
      screen: _getCurrentRoute(context),
      userId: userId,
      widgetProperties: {
        'title': title,
        'canRetry': canRetry,
        'showDetails': showDetails,
      },
    );

    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _ErrorDialogWidget(
          title: title,
          message: message,
          error: error,
          stackTrace: stackTrace,
          onRetry: onRetry,
          onDismiss: onDismiss,
          canRetry: canRetry,
          showDetails: showDetails,
        );
      },
    );
  }

  /// Show a network error dialog
  static Future<void> showNetworkError({
    required BuildContext context,
    String? customMessage,
    VoidCallback? onRetry,
    String? userId,
  }) async {
    return showError(
      context: context,
      title: 'Connection Error',
      message: customMessage ??
          'Please check your internet connection and try again.',
      error: Exception('Network error'),
      userId: userId,
      onRetry: onRetry,
      canRetry: true,
    );
  }

  /// Show a server error dialog
  static Future<void> showServerError({
    required BuildContext context,
    int? statusCode,
    String? customMessage,
    VoidCallback? onRetry,
    String? userId,
  }) async {
    final message = customMessage ??
        'The server is currently unavailable. Please try again later.';

    return showError(
      context: context,
      title: 'Server Error',
      message: message,
      error: Exception('Server error: ${statusCode ?? 'Unknown'}'),
      userId: userId,
      onRetry: onRetry,
      canRetry: true,
    );
  }

  /// Show a validation error dialog
  static Future<void> showValidationError({
    required BuildContext context,
    required String message,
    String? field,
    String? userId,
  }) async {
    return showError(
      context: context,
      title: 'Invalid Input',
      message: message,
      error: Exception('Validation error: $field'),
      userId: userId,
      canRetry: false,
    );
  }

  /// Show an authentication error dialog
  static Future<void> showAuthError({
    required BuildContext context,
    String? customMessage,
    VoidCallback? onSignIn,
    String? userId,
  }) async {
    return showError(
      context: context,
      title: 'Authentication Required',
      message: customMessage ?? 'Please sign in to continue.',
      error: Exception('Authentication error'),
      userId: userId,
      onRetry: onSignIn,
      canRetry: onSignIn != null,
    );
  }

  /// Show a permission error dialog
  static Future<void> showPermissionError({
    required BuildContext context,
    required String permission,
    String? customMessage,
    VoidCallback? onOpenSettings,
    String? userId,
  }) async {
    final message = customMessage ??
        'This feature requires $permission permission. Please grant permission in settings.';

    return showError(
      context: context,
      title: 'Permission Required',
      message: message,
      error: Exception('Permission error: $permission'),
      userId: userId,
      onRetry: onOpenSettings,
      canRetry: onOpenSettings != null,
    );
  }

  /// Show a critical error dialog
  static Future<void> showCriticalError({
    required BuildContext context,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    String? userId,
    VoidCallback? onRestart,
  }) async {
    return showError(
      context: context,
      title: 'Critical Error',
      message: message,
      error: error,
      stackTrace: stackTrace,
      userId: userId,
      onRetry: onRestart,
      canRetry: onRestart != null,
      showDetails: FlavorConfig.instance.isDev,
    );
  }

  /// Show a bottom sheet error
  static Future<void> showErrorBottomSheet({
    required BuildContext context,
    required String title,
    required String message,
    dynamic error,
    String? userId,
    List<ErrorAction>? actions,
  }) async {
    // Track the error
    await ErrorTracker.instance.trackUIError(
      widget: 'ErrorBottomSheet',
      error: error ?? Exception(message),
      screen: _getCurrentRoute(context),
      userId: userId,
      widgetProperties: {
        'title': title,
        'actionsCount': actions?.length ?? 0,
      },
    );

    if (!context.mounted) return;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return _ErrorBottomSheetWidget(
          title: title,
          message: message,
          error: error,
          actions: actions ?? [],
        );
      },
    );
  }

  /// Show a snackbar error
  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    dynamic error,
    String? userId,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    // Track the error
    ErrorTracker.instance.trackUIError(
      widget: 'ErrorSnackBar',
      error: error ?? Exception(message),
      screen: _getCurrentRoute(context),
      userId: userId,
      widgetProperties: {
        'duration': duration.inSeconds,
        'hasAction': action != null,
      },
    );

    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      action: action,
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Get current route name
  static String? _getCurrentRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }
}

/// Error action for bottom sheet
class ErrorAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  ErrorAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// Error dialog widget
class _ErrorDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool canRetry;
  final bool showDetails;

  const _ErrorDialogWidget({
    required this.title,
    required this.message,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.onDismiss,
    required this.canRetry,
    required this.showDetails,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (showDetails && error != null) ...[
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Error Details'),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error: ${error.toString()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (stackTrace != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Stack Trace:',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stackTrace.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => _copyToClipboard(context),
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        if (canRetry && onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: const Text('Retry'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final errorText = '''
Error: ${error.toString()}
${stackTrace != null ? 'Stack Trace:\n${stackTrace.toString()}' : ''}
App Version: ${AppConfig.instance.appVersion}
Flavor: ${FlavorConfig.instance.name}
Timestamp: ${DateTime.now().toIso8601String()}
''';

    Clipboard.setData(ClipboardData(text: errorText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error details copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Error bottom sheet widget
class _ErrorBottomSheetWidget extends StatelessWidget {
  final String title;
  final String message;
  final dynamic error;
  final List<ErrorAction> actions;

  const _ErrorBottomSheetWidget({
    required this.title,
    required this.message,
    this.error,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Error icon and title
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Message
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Actions
          if (actions.isNotEmpty) ...[
            ...actions.map((action) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: action.isPrimary
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            action.onPressed();
                          },
                          child: Text(action.label),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            action.onPressed();
                          },
                          child: Text(action.label),
                        ),
                )),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ),
          ],

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
