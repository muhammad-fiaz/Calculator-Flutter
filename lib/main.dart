import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';
import 'providers/theme_provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'screens/main_screen.dart';
import 'play_integrity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase Analytics
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      // Analytics is not critical, continue without it
      debugPrint('Failed to initialize Firebase Analytics: $e');
    }

    // Initialize Firebase Performance Monitoring
    try {
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    } catch (e) {
      // Performance monitoring is not critical, continue without it
      debugPrint('Failed to initialize Firebase Performance: $e');
    }

    // Initialize Firebase App Check
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
    } catch (e) {
      // App Check is not critical for basic functionality
      debugPrint('Failed to initialize Firebase App Check: $e');
    }

    // Set up error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log to Crashlytics if available
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      } catch (e) {
        debugPrint('Failed to log error to Crashlytics: $e');
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (e) {
        debugPrint('Failed to log async error to Crashlytics: $e');
      }
      return true;
    };

    // Log app open event
    try {
      await AnalyticsService.logAppOpen();
    } catch (e) {
      debugPrint('Failed to log app open event: $e');
    }

    // Perform integrity check (for demonstration)
    try {
      final isTrustworthy = await PlayIntegrityService.isDeviceTrustworthy();
      try {
        await AnalyticsService.logCustomEvent('device_integrity_check', {
          'is_trustworthy': isTrustworthy,
        });
        await FirebaseCrashlytics.instance.log(
          'Device integrity check: ${isTrustworthy ? 'Trustworthy' : 'Not trustworthy'}',
        );
      } catch (e) {
        debugPrint('Failed to log integrity result: $e');
      }
    } catch (e) {
      // Log error to Crashlytics if available
      try {
        await FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'Failed to check device integrity',
        );
      } catch (crashlyticsError) {
        debugPrint('Failed to log integrity check error: $crashlyticsError');
      }
    }
  } catch (e) {
    // Firebase initialization failed - log to console and continue
    debugPrint('Firebase initialization failed: $e');
    // App can still function without Firebase
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Calculator Flutter',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
