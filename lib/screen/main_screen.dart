import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:calculator/controller/calculate_controller.dart';
import 'package:calculator/controller/theme_controller.dart';
import 'package:calculator/utils/colors.dart';
import 'package:calculator/widget/button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final List<String> buttons = [
    "C", "DEL", "%", "/", "7", "8", "9", "x", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "+/-", "=",
    "^", "√", "(", ")", "log", "ln", "sin", "cos", "tan"
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (context) {
      return Scaffold(
        backgroundColor: themeController.isDark
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        body: Column(
          children: [
            GetBuilder<CalculateController>(builder: (context) {
              return outPutSection(themeController, controller);
            }),
            GetBuilder<CalculateController>(builder: (context) {
              return inPutSection(themeController, controller);
            }),
          ],
        ),
      );
    });
  }

  /// Input Section - Enter Numbers
  Widget inPutSection(
      ThemeController themeController, CalculateController controller) {
    List<String> visibleButtons = controller.isScientificMode
        ? [
      "C", "DEL", "%", "/", "^", // First row
      "7", "8", "9", "x", "√",  // Second row
      "4", "5", "6", "-", "(",  // Third row
      "1", "2", "3", "+", ")",  // Fourth row
      "0", ".", "+/-", "*", "=",     // Fifth row
      "log", "ln", "sin", "cos", "tan", // Sixth row
    ]
        : buttons.sublist(0, 20); // Show only first 20 buttons in normal mode

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
                } else {
                  controller.onBtnTapped(visibleButtons, index);
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

  /// Output Section - Show Result
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
                    }
                    // Add other options here
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
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
                      value: 'Settings',
                      child: Text('Settings',
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
                    /// History Icon Button
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        size: 25,
                        color: themeController.isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        // Add your history button functionality here
                      },
                    ),

                    /// Theme switcher button
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
          /// Main Result - user input and output
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 60),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    controller.userInput,
                    style: GoogleFonts.ubuntu(
                      color: themeController.isDark ? Colors.white : Colors.black,
                      fontSize: 38,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
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
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == "/" ||
        x == "x" ||
        x == "-" ||
        x == "+" ||
        x == "=" ||
        x == "^" ||
        x == "√" ||
        x == "%" ||
        x == "(" ||
        x == ")" ||
        x == "*" ||
        x == "log" ||
        x == "ln" ||
        x == "sin" ||
        x == "cos" ||
        x == "tan") {
      return true;
    }
    return false;
  }
}
