import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calculator/controller/calculate_controller.dart';
import 'package:calculator/models/history_model.dart';
import 'package:calculator/controller/theme_controller.dart';
import 'package:calculator/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'History',
              style: GoogleFonts.ubuntu(
                color: themeController.isDark ? Colors.white : Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: themeController.isDark ? Colors.white : Colors.black,
            ),
            backgroundColor: themeController.isDark
                ? DarkColors.scaffoldBgColor
                : LightColors.scaffoldBgColor,
          ),
          backgroundColor: themeController.isDark
              ? DarkColors.sheetBgColor
              : LightColors.sheetBgColor,
          body: FutureBuilder<List<HistoryModel>>(
            future: controller.fetchHistory(),
            builder: (context, AsyncSnapshot<List<HistoryModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No History Available'),
                );
              } else if (snapshot.hasError) {
                // Handle error using Firebase Crashlytics
                FirebaseCrashlytics.instance.recordError(snapshot.error!, StackTrace.current);
                return const Center(
                  child: Text('Error fetching history. Please try again later.'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var history = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: themeController.isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                history.expression,
                                style: TextStyle(
                                  color: themeController.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                history.result,
                                style: TextStyle(
                                  color: themeController.isDark
                                      ? Colors.white.withOpacity(0.6)
                                      : Colors.black.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                // Update input field in CalculateController
                                controller.setInputFromHistory(
                                  history.expression,
                                  history.result,
                                );
                                // Navigate back or handle UI as needed
                                Navigator.pop(context); // Go back after selection
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
