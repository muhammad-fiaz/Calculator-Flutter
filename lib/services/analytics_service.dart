import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Screen tracking
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Calculator operations tracking
  static Future<void> logCalculatorOperation(
    String operation,
    String expression,
    String result,
  ) async {
    await _analytics.logEvent(
      name: 'calculator_operation',
      parameters: {
        'operation_type': operation,
        'expression': expression,
        'result': result,
      },
    );
  }

  // Button press tracking
  static Future<void> logButtonPress(String buttonName) async {
    await _analytics.logEvent(
      name: 'button_press',
      parameters: {'button_name': buttonName},
    );
  }

  // Theme change tracking
  static Future<void> logThemeChange(String themeMode) async {
    await _analytics.logEvent(
      name: 'theme_change',
      parameters: {'theme_mode': themeMode},
    );
  }

  // App lifecycle events
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  // Custom events
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, Object> parameters,
  ) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }

  // User engagement tracking
  static Future<void> logUserEngagement(String feature) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'feature': feature,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Error tracking (complement to Crashlytics)
  static Future<void> logError(String errorType, String errorMessage) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
