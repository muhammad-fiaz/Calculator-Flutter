import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Screen tracking
  static Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log screen view: $e');
      }
    }
  }

  // Calculator operations tracking
  static Future<void> logCalculatorOperation(
    String operation,
    String expression,
    String result,
  ) async {
    try {
      await _analytics.logEvent(
        name: 'calculator_operation',
        parameters: {
          'operation_type': operation,
          'expression': expression,
          'result': result,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log calculator operation: $e');
      }
    }
  }

  // Button press tracking
  static Future<void> logButtonPress(String buttonName) async {
    try {
      await _analytics.logEvent(
        name: 'button_press',
        parameters: {'button_name': buttonName},
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log button press: $e');
      }
    }
  }

  // Theme change tracking
  static Future<void> logThemeChange(String themeMode) async {
    try {
      await _analytics.logEvent(
        name: 'theme_change',
        parameters: {'theme_mode': themeMode},
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log theme change: $e');
      }
    }
  }

  // App lifecycle events
  static Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log app open: $e');
      }
    }
  }

  // Custom events
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, Object> parameters,
  ) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log custom event: $e');
      }
    }
  }

  // User engagement tracking
  static Future<void> logUserEngagement(String feature) async {
    try {
      await _analytics.logEvent(
        name: 'user_engagement',
        parameters: {
          'feature': feature,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log user engagement: $e');
      }
    }
  }

  // Error tracking (complement to Crashlytics)
  static Future<void> logError(String errorType, String errorMessage) async {
    try {
      await _analytics.logEvent(
        name: 'app_error',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log error event: $e');
      }
    }
  }
}
