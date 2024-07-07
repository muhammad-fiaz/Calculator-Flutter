import 'package:calculator/controller/database_helper.dart';
import 'package:calculator/models/history_model.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class CalculateController extends GetxController {
  var userInput = "";
  var userOutput = "";
  var isScientificMode = false;
  var isInvertedMode = false; // Added for inverted trig functions
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> equalPressed() async {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    userInputFC = userInputFC.replaceAll("√", "sqrt");
    userInputFC = userInputFC.replaceAll("^", "pow");
    userInputFC = userInputFC.replaceAll("π", pi.toString());
    userInputFC = userInputFC.replaceAll("|", "abs");
    userInputFC = userInputFC.replaceAll("!", "factorial");
    userInputFC = userInputFC.replaceAll("sin", "sin");
    userInputFC = userInputFC.replaceAll("cos", "cos");
    userInputFC = userInputFC.replaceAll("tan", "tan");
    userInputFC = userInputFC.replaceAll("log", "log");
    userInputFC = userInputFC.replaceAll("ln", "ln");

    // Handle factorial, degrees, and trigonometric functions here
    // This is a simplified example and might need adjustments for complex expressions
    Parser p = Parser();
    ContextModel cm = ContextModel();

    // Define custom functions if necessary
    cm.bindVariable(Variable('pi'), Number(pi));
    cm.bindVariable(Variable('e'), Number(e));

    try {
      Expression exp = p.parse(userInputFC);
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      userOutput = eval.toString();
    } catch (e) {
      userOutput = "Syntax Error";
    }
// Save to history
    HistoryModel history = HistoryModel(
      expression: userInput,
      result: userOutput,
    );
    await databaseHelper.insertHistory(history);

    update();
  }
  Future<List<HistoryModel>> fetchHistory() async {
    return await databaseHelper.fetchAllHistory();
  }


  void clearInputAndOutput() {
    userInput = "";
    userOutput = "";
    update();
  }

  void deleteBtnAction() {
    if (userInput.isNotEmpty) {
      userInput = userInput.substring(0, userInput.length - 1);
    }
    update();
  }

  void onBtnTapped(String button) {
    userInput += button;
    update();
  }

  void toggleScientificMode() {
    isScientificMode = !isScientificMode;
    update();
  }

  void toggleInvertedMode() {
    isInvertedMode = !isInvertedMode;
    update();
  }

  void setInputFromHistory(String input, String output) {
    userInput = input;
    userOutput = output;
    update(); // Notify listeners of the change

  }
}