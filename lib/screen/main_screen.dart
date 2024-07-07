import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../controller/calculate_controller.dart';
import '../controller/theme_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';
import '../screen/history_screen.dart';
import '../screen/about_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SharedPreferences _prefs;
  bool _showBetaNotice = true;

  // Define buttons list here
  final List<String> buttons = [
    "C", "DEL", "%", "/", "7", "8", "9", "x", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "^", "=",
    "√", "(", ")", "log", "ln", "sin", "cos", "tan", "π", "e", "10^", "!", "deg", "inv"
  ];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _showBetaNotice = _prefs.getBool('showBetaNotice') ?? true;

    // Show beta notice dialog if it hasn't been shown before
    if (_showBetaNotice) {
      showBetaNotice();
    }
  }

  void showBetaNotice() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var themeController = Get.find<ThemeController>(); // Assuming you have access to theme controller

        return AlertDialog(
          backgroundColor: themeController.isDark ? DarkColors.sheetBgColor : LightColors.sheetBgColor,
          title: Text(
            "Notice",
            style: TextStyle(
              color: themeController.isDark ? Colors.white : Colors.black, // Title text color based on theme
            ),
          ),
          content: Text(
            "This app is in beta and may have bugs. You can report issues on GitHub.",
            style: TextStyle(
              color: themeController.isDark ? Colors.white : Colors.black, // Content text color based on theme
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Store in SharedPreferences that notice has been displayed
                _prefs.setBool('showBetaNotice', false);
                setState(() {
                  _showBetaNotice = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (themeContext) {
      return Scaffold(
        backgroundColor: themeController.isDark
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        body: Column(
          children: [
            GetBuilder<CalculateController>(builder: (calcContext) {
              return outPutSection(themeController, controller);
            }),
            GetBuilder<CalculateController>(builder: (calcContext) {
              return inPutSection(themeController, controller);
            }),
          ],
        ),
      );
    });
  }

  Widget inPutSection(ThemeController themeController, CalculateController controller) {
    List<String> visibleButtons = controller.isScientificMode
        ? [
      "C", "DEL", "%", "/", "^",
      "7", "8", "9", "*", "√",
      "4", "5", "6", "-", "*",
      "1", "2", "3", "+", "10^",
      "0", ".", "=", "(", ")",
      "log", "ln", getTrigButton(controller, "sin"),
      getTrigButton(controller, "cos"),
      getTrigButton(controller, "tan"),
      "π", "e", "!", "deg", "inv"
    ]
        : buttons.sublist(0, 20);

    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: themeController.isDark
              ? DarkColors.sheetBgColor
              : LightColors.sheetBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GridView.builder(
          itemCount: visibleButtons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: controller.isScientificMode ? 5 : 4,
          ),
          itemBuilder: (context, index) {
            return CustomAppButton(
              buttonTapped: () {
                try {
                  if (visibleButtons[index] == "=") {
                    controller.equalPressed();
                  } else if (visibleButtons[index] == "C") {
                    controller.clearInputAndOutput();
                  } else if (visibleButtons[index] == "DEL") {
                    controller.deleteBtnAction();
                  } else if (visibleButtons[index] == "inv") {
                    controller.toggleInvertedMode();
                  } else {
                    controller.onBtnTapped(visibleButtons[index]);
                  }
                } catch (e, stackTrace) {
                  FirebaseCrashlytics.instance.recordError(e, stackTrace);
                }
              },
              color: isOperator(visibleButtons[index])
                  ? LightColors.operatorColor
                  : themeController.isDark
                  ? DarkColors.btnBgColor
                  : LightColors.btnBgColor,
              textColor: isOperator(visibleButtons[index])
                  ? Colors.white
                  : themeController.isDark
                  ? Colors.white
                  : Colors.black,
              text: visibleButtons[index],
              isScientificMode: controller.isScientificMode,
            );
          },
        ),
      ),
    );
  }

  Widget outPutSection(ThemeController themeController, CalculateController controller) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    try {
                      if (value == 'Scientific Mode') {
                        controller.toggleScientificMode();
                      } else if (value == 'About') {
                        Navigator.push(
                          Get.context!,
                          MaterialPageRoute(builder: (context) => const AboutPage()),
                        );
                      } else if (value == 'Help') {
                        try {
                          launch('https://github.com/muhammad-fiaz/Calculator-Flutter');
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Could not launch URL',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          FirebaseCrashlytics.instance.recordError(e, null);
                        }
                      }
                    } catch (e, stackTrace) {
                      FirebaseCrashlytics.instance.recordError(e, stackTrace);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'About',
                      child: Text(
                        'About',
                        style: TextStyle(
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Help',
                      child: Text(
                        'Help',
                        style: TextStyle(
                          color: themeController.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    size: 25,
                    color: themeController.isDark ? Colors.white : Colors.black,
                  ),
                  color: themeController.isDark
                      ? DarkColors.sheetBgColor
                      : LightColors.sheetBgColor,
                  offset: const Offset(0, 40), // Adjusts the position of the menu
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        size: 25,
                        color: themeController.isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        try {
                          Get.to(() => const HistoryScreen());
                        } catch (e, stackTrace) {
                          FirebaseCrashlytics.instance.recordError(e, stackTrace);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        themeController.isDark
                            ? Icons.nightlight_round_outlined
                            : Icons.wb_sunny_outlined,
                        size: 25,
                        color: themeController.isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        try {
                          themeController.toggleTheme();
                        } catch (e, stackTrace) {
                          FirebaseCrashlytics.instance.recordError(e, stackTrace);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 20),
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.userInput,
                      style: GoogleFonts.ubuntu(
                        color: themeController.isDark ? Colors.white : Colors.black,
                        fontSize: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.userOutput,
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.bold,
                        color: themeController.isDark ? Colors.white : Colors.black,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    return [
      "/", "x", "-", "+", "=", "^", "√", "%", "(", ")", "*", "log", "ln", "sin", "cos", "tan", "π", "e", "10^", "!", "deg", "inv", "sin^-1", "cos^-1", "tan^-1"
    ].contains(x);
  }

  String getTrigButton(CalculateController controller, String trigFunc) {
    if (controller.isInvertedMode) {
      return "$trigFunc^-1"; // Replace with sin^-1, cos^-1, tan^-1, etc.
    } else {
      return trigFunc; // Standard sin, cos, tan
    }
  }
}
