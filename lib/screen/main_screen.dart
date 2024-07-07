import 'package:calculator/screen/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:calculator/controller/calculate_controller.dart';
import 'package:calculator/controller/theme_controller.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/widget/button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculator/screen/about_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final List<String> buttons = [
    "C", "DEL", "%", "/", "7", "8", "9", "x", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "^", "=",
    "√", "(", ")", "log", "ln", "sin", "cos", "tan", "π", "e", "10^", "!", "deg", "inv"
  ];

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

  Widget inPutSection(
      ThemeController themeController, CalculateController controller) {
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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleButtons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: controller.isScientificMode ? 5 : 4,
          ),
          itemBuilder: (context, index) {
            return CustomAppButton(
              buttonTapped: () {
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

  Widget outPutSection(
      ThemeController themeController, CalculateController controller) {
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
                    if (value == 'Scientific Mode') {
                      controller.toggleScientificMode();
                    } else if (value == 'About') {
                      Navigator.push(
                        Get.context!,
                        MaterialPageRoute(builder: (context) => const AboutPage()),
                      );
                    } else if (value == 'Help') {
                      try {
                        launch(
                            'https://github.com/muhammad-fiaz/Calculator-Flutter');
                      }
                      catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not launch URL',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                    // Add other options here
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Scientific Mode',
                      child: Row(
                        children: [
                          Text('Scientific Mode',
                              style: TextStyle(
                                  color: themeController.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          const Spacer(),
                          Icon(
                            controller.isScientificMode
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: themeController.isDark
                                ? Colors.white
                                : Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'About',
                      child: Text('About',
                          style: TextStyle(
                              color: themeController.isDark
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                    PopupMenuItem<String>(
                      value: 'Help',
                      child: Text('Help',
                          style: TextStyle(
                              color: themeController.isDark
                                  ? Colors.white
                                  : Colors.black)),
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
                        Get.to(() => HistoryScreen());
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
                        themeController.toggleTheme();
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
