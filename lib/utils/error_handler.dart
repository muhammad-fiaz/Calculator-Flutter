import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// A centralized error handler that provides user-friendly error messaging
/// while ensuring errors are properly logged to Firebase Crashlytics
class ErrorHandler {
  static const Duration _toastDuration = Duration(seconds: 3);
  static const Duration _snackBarDuration = Duration(seconds: 4);

  /// Show a toast message for minor errors
  static void showToast(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? backgroundColor,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: _toastDuration,
        backgroundColor: backgroundColor ?? Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show an error toast with red background
  static void showErrorToast(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: _snackBarDuration,
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Show a success toast with green background
  static void showSuccessToast(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: _toastDuration,
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show a warning toast with orange background
  static void showWarningToast(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: _toastDuration,
        backgroundColor: Colors.orange[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show an error dialog for critical errors
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 32,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            if (onCancel != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel();
                },
                child: const Text('Cancel'),
              ),
            if (onRetry != null)
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: const Text('Retry'),
              )
            else
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
          ],
        );
      },
    );
  }

  /// Handle and log exceptions with user-friendly messages
  static Future<void> handleException(
    dynamic exception,
    StackTrace? stackTrace, {
    BuildContext? context,
    String? userMessage,
    String? operation,
    Map<String, dynamic>? additionalData,
    bool showToUser = true,
    bool logToCrashlytics = true,
  }) async {
    // Log to console in debug mode
    if (kDebugMode) {
      print('Error in $operation: $exception');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }

    // Log to Firebase Crashlytics
    if (logToCrashlytics) {
      try {
        await FirebaseCrashlytics.instance.recordError(
          exception,
          stackTrace ?? StackTrace.current,
          reason: operation ?? 'Unhandled exception',
          information:
              additionalData?.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .toList() ??
              [],
        );
      } catch (e) {
        // If Crashlytics fails, at least log to console
        if (kDebugMode) {
          print('Failed to log to Crashlytics: $e');
        }
      }
    }

    // Show user-friendly message
    if (showToUser && context != null && context.mounted) {
      final message = userMessage ?? _getErrorMessage(exception);
      showErrorToast(context, message);
    }
  }

  /// Get a user-friendly error message based on the exception type
  static String _getErrorMessage(dynamic exception) {
    if (exception == null) return 'An unexpected error occurred';

    final errorString = exception.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('internet')) {
      return 'Network error. Please check your connection.';
    }
    if (errorString.contains('timeout')) {
      return 'Operation timed out. Please try again.';
    }
    if (errorString.contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    }
    if (errorString.contains('firebase')) {
      return 'Service temporarily unavailable. Please try again.';
    }
    if (errorString.contains('database') || errorString.contains('sql')) {
      return 'Database error. Please restart the app.';
    }
    if (errorString.contains('format') || errorString.contains('parse')) {
      return 'Invalid data format. Please try again.';
    }
    if (errorString.contains('not found') || errorString.contains('404')) {
      return 'Resource not found. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }

  /// Handle Firebase-specific errors
  static Future<void> handleFirebaseError(
    dynamic exception,
    StackTrace? stackTrace, {
    BuildContext? context,
    String? operation,
    bool showToUser = true,
  }) async {
    String userMessage;

    final errorString = exception.toString().toLowerCase();

    if (errorString.contains('permission-denied')) {
      userMessage = 'Access denied. Please check your permissions.';
    } else if (errorString.contains('network')) {
      userMessage =
          'Network error. Please check your connection and try again.';
    } else if (errorString.contains('quota-exceeded')) {
      userMessage = 'Service temporarily unavailable due to high usage.';
    } else if (errorString.contains('unauthenticated')) {
      userMessage = 'Authentication required. Please sign in.';
    } else {
      userMessage = 'Service temporarily unavailable. Please try again later.';
    }

    await handleException(
      exception,
      stackTrace,
      context: context,
      userMessage: userMessage,
      operation: operation ?? 'Firebase operation',
      showToUser: showToUser,
      logToCrashlytics: true,
    );
  }

  /// Handle mathematical calculation errors
  static void handleCalculationError(
    BuildContext context,
    dynamic exception, {
    String? expression,
  }) {
    String userMessage;
    final errorString = exception.toString().toLowerCase();

    if (errorString.contains('infinity') || errorString.contains('nan')) {
      userMessage = 'Result is too large or undefined';
    } else if (errorString.contains('division by zero') ||
        errorString.contains('divide by zero')) {
      userMessage = 'Cannot divide by zero';
    } else if (errorString.contains('format') ||
        errorString.contains('invalid')) {
      userMessage = 'Invalid expression. Please check your input.';
    } else if (errorString.contains('overflow')) {
      userMessage = 'Number too large to calculate';
    } else {
      userMessage = 'Invalid calculation. Please try again.';
    }

    handleException(
      exception,
      StackTrace.current,
      context: context,
      userMessage: userMessage,
      operation: 'Calculation',
      additionalData: expression != null ? {'expression': expression} : null,
    );
  }

  /// Wrap async operations with error handling
  static Future<T?> safeAsyncOperation<T>(
    Future<T> Function() operation, {
    BuildContext? context,
    String? operationName,
    String? userErrorMessage,
    bool showErrorToUser = true,
    bool logToCrashlytics = true,
  }) async {
    try {
      return await operation();
    } catch (exception, stackTrace) {
      await handleException(
        exception,
        stackTrace,
        context: context,
        userMessage: userErrorMessage,
        operation: operationName,
        showToUser: showErrorToUser,
        logToCrashlytics: logToCrashlytics,
      );
      return null;
    }
  }
}
