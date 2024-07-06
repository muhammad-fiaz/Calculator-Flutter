import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculateController extends GetxController {
  var userInput = "";
  var userOutput = "";
  var isScientificMode = false;

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    userInputFC = userInputFC.replaceAll("√", "sqrt");
    userInputFC = userInputFC.replaceAll("^", "^");

    Parser p = Parser();

    try {
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);

      userOutput = eval.toString();
    } catch (e) {
      userOutput = "Syntax Error";
    }

    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "";
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    if (userInput.isNotEmpty) {
      userInput = userInput.substring(0, userInput.length - 1);
    }
    update();
  }

  /// on Number Button Tapped
  onBtnTapped(List<String> buttons, int index) {
    userInput += buttons[index];
    update();
  }

  /// Toggle Scientific Mode
  toggleScientificMode() {
    isScientificMode = !isScientificMode;
    update();
  }
}
