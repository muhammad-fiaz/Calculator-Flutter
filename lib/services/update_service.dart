import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_update/in_app_update.dart';
import '../config/app_config.dart';

class UpdateService {
  // No GitHub API URL needed - Play Store only

  /// Check for app updates on startup - FORCE UPDATE
  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      // Use Play Store in-app update for Android only
      if (Platform.isAndroid) {
        await _checkAndroidInAppUpdate(context);
      } else {
        // For non-Android platforms, show version info and redirect to Play Store
        if (context.mounted) {
          _showVersionAndUpdateDialog(context);
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
      // Silently fail - don't show error to user on startup
    }
  }

  /// Check for Android in-app updates using the official API
  static Future<void> _checkAndroidInAppUpdate(BuildContext context) async {
    try {
      // Check if update is available
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      debugPrint(
        'In-app update check: Update available: ${info.updateAvailability}',
      );
      debugPrint(
        'In-app update check: Immediate allowed: ${info.immediateUpdateAllowed}',
      );
      debugPrint(
        'In-app update check: Flexible allowed: ${info.flexibleUpdateAllowed}',
      );

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (context.mounted) {
          // FORCE IMMEDIATE UPDATE - No user choice
          if (info.immediateUpdateAllowed) {
            _performImmediateUpdate(context);
          } else if (info.flexibleUpdateAllowed) {
            // If immediate not allowed, force flexible update
            _performFlexibleUpdate(context);
          } else {
            // If neither allowed, show dialog with version info
            _showVersionAndUpdateDialog(context);
          }
        }
      } else {
        debugPrint('In-app update check: No update available');
      }
    } catch (e) {
      debugPrint('In-app update check failed: $e');
      // Don't fallback to GitHub - Play Store only
    }
  }

  /// Get current app version
  static Future<String> _getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Manual update check (called from settings) - Android only
  static Future<void> manualUpdateCheck(BuildContext context) async {
    if (!Platform.isAndroid) {
      // For non-Android platforms, show message to check Play Store manually
      if (context.mounted) {
        _showPlayStoreOnlyDialog(context);
      }
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Check Play Store for updates
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          // FORCE UPDATE - No user choice in manual check either
          if (info.immediateUpdateAllowed) {
            _performImmediateUpdate(context);
          } else if (info.flexibleUpdateAllowed) {
            _performFlexibleUpdate(context);
          } else {
            _showVersionAndUpdateDialog(context);
          }
        } else {
          // Get current version before showing dialog to avoid async gap
          final currentVersion = await _getCurrentVersion();
          if (context.mounted) {
            _showUpToDateDialog(context, currentVersion);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorDialog(
          context,
          'Failed to check for updates: ${e.toString()}',
        );
      }
    }
  }

  /// Perform immediate update
  static void _performImmediateUpdate(BuildContext context) async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('Immediate update failed: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Update failed. Please try again later.');
      }
    }
  }

  /// Perform flexible update
  static void _performFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();

      // Show snackbar to inform user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update downloading in background...'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Monitor update status
      InAppUpdate.completeFlexibleUpdate().then((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Update ready! Tap to restart.'),
              action: SnackBarAction(
                label: 'Restart',
                onPressed: () => InAppUpdate.completeFlexibleUpdate(),
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Flexible update failed: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Update failed. Please try again later.');
      }
    }
  }

  /// Show up-to-date dialog
  static void _showUpToDateDialog(BuildContext context, String currentVersion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Up to Date'),
          ],
        ),
        content: Text('You\'re running the latest version (v$currentVersion).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text('Update Check Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show Play Store only dialog for non-Android platforms
  static void _showPlayStoreOnlyDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // FORCE USER TO TAKE ACTION
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Update Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Version: ${packageInfo.version}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'You\'re not using Android. Please update from Google Play Store on an Android device.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'The app requires the latest version for optimal performance and security.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Anyway'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _openPlayStore();
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Play Store'),
          ),
        ],
      ),
    );
  }

  /// Open Play Store
  static void _openPlayStore() async {
    final uri = Uri.parse(AppConfig.playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Show version info and force update dialog
  static void _showVersionAndUpdateDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // FORCE USER TO UPDATE
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Update Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Version: ${packageInfo.version}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'A new version is available and required to continue using the app.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please update from Google Play Store to access the latest features and security improvements.',
            ),
          ],
        ),
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _openPlayStore();
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}
