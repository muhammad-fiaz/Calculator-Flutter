import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calculator/bindings/my_bindings.dart';
import 'package:calculator/screen/main_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('Firebase initialized');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }

  // Initialize Crashlytics
  initCrashlytics();

  // Run the app
  runApp(const MyApp());
}

void initCrashlytics() {
  // Enable Crashlytics collection
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Handle Flutter errors with Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set up Firebase Performance Monitoring
    FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: "Calculator",
      home: MainScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}
