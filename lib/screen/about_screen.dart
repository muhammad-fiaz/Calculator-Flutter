import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:calculator/controller/theme_controller.dart';
import 'package:calculator/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:calculator/screen/license_screen.dart' as license;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: themeController.isDark
          ? DarkColors.scaffoldBgColor
          : LightColors.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'About',
          style: GoogleFonts.ubuntu(
            color: themeController.isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: themeController.isDark
            ? DarkColors.sheetBgColor
            : LightColors.sheetBgColor,
        iconTheme: IconThemeData(
          color: themeController.isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Calculator',
              style: GoogleFonts.ubuntu(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeController.isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    const url = 'https://github.com/muhammad-fiaz/Calculator-Flutter/releases';
                    try {
                      await launch(url);
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Could not launch URL',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        '(',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Version 1.0.0',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        ') ',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const license.LicensePage()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        '(',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'License',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        ') ',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                const url = 'https://github.com/muhammad-fiaz/Calculator-Flutter/issues';
                try {
                  await launch(url);
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Could not launch URL',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
                }
              },
              child: Text(
                'Report an Issue (GitHub)',
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This calculator app provides both basic and advanced scientific functionalities to help with all your calculation needs. Switch between normal and scientific modes as required.',
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                color: themeController.isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'For more information, visit our GitHub repository or report an issue if you encounter any problems. You can also check the license information for this app.',
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                color: themeController.isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
