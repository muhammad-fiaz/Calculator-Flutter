import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ThemeController extends GetxController {
  bool isDark = true;
  final switcherController = ValueNotifier<bool>(false);

  void lightTheme() {
    try {
      isDark = false;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      update();
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  void darkTheme() {
    try {
      isDark = true;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      update();
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  @override
  void onInit() {
    switcherController.addListener(() {
      if (switcherController.value) {
        lightTheme();
      } else {
        darkTheme();
      }
    });
    super.onInit();
  }

  void toggleTheme() {
    try {
      isDark = !isDark; // Toggle the boolean value
      update();
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }
}
