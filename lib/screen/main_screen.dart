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
    "C",
    "DEL",
    "%",
    "/",
    "9",
    "8",
    "7",
    "x",
    "6",
    "5",
    "4",
    "-",
    "3",
    "2",
    "1",
    "+",
    "0",
    ".",
    "ANS",
    "=",
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
            inPutSection(themeController, controller),
          ],
        ),
      );
    });
  }

  /// In put Section - Enter Numbers
  Widget inPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                switch (index) {
                /// CLEAR BTN
                  case 0:
                    return CustomAppButton(
                      buttonTapped: () {
                        controller.clearInputAndOutput();
                      },
                      color: themeController.isDark
                          ? DarkColors.leftOperatorColor
                          : LightColors.leftOperatorColor,
                      textColor: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      text: buttons[index],
                    );

                /// DELETE BTN
                  case 1:
                    return CustomAppButton(
                        buttonTapped: () {
                          controller.deleteBtnAction();
                        },
                        color: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        textColor: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        text: buttons[index]);

                /// EQUAL BTN
                  case 19:
                    return CustomAppButton(
                        buttonTapped: () {
                          controller.equalPressed();
                        },
                        color: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        textColor: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        text: buttons[index]);

                  default:
                    return CustomAppButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: isOperator(buttons[index])
                          ? LightColors.operatorColor
                          : themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : themeController.isDark
                          ? Colors.white
                          : Colors.black,
                      text: buttons[index],
                    );
                }
              }),
        ));
  }

  /// Out put Section - Show Result
  Widget outPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Row for icons: Theme switcher and History

          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10),
            child: Row(
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

  /// is Operator Check
  bool isOperator(String y) {
    if (y == "%" ||
        y == "/" ||
        y == "x" ||
        y == "-" ||
        y == "+" ||
        y == "=") {
      return true;
    }
    return false;
  }
}
