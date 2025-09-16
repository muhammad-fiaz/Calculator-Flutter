import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import '../services/analytics_service.dart';

class CalculatorProvider with ChangeNotifier {
  String _expression = '';
  String _preview = '';
  String _result = '';
  bool _hasError = false;
  bool _isScientificMode = false;
  int _cursorPosition = 0; // Position of cursor in expression

  String get expression => _expression;
  String get preview => _preview;
  String get result => _result;
  bool get hasError => _hasError;
  bool get isScientificMode => _isScientificMode;
  int get cursorPosition => _cursorPosition;

  // Get the last calculation for history (expression = result format)
  String? _lastCalculation;
  String? get lastCalculation => _lastCalculation;

  void addInput(String input) {
    _hasError = false;

    // Track button press analytics
    AnalyticsService.logButtonPress(input);

    // Handle special cases
    if (input == 'C') {
      clear();
      return;
    }

    if (input == '⌫') {
      backspace();
      return;
    }

    if (input == '=') {
      calculate();
      return;
    }

    // Handle scientific functions - add proper format
    String processedInput = input;
    if (input == 'sin' ||
        input == 'cos' ||
        input == 'tan' ||
        input == 'ln' ||
        input == 'log' ||
        input == '√') {
      processedInput = '$input(';
    }

    // Insert the input at cursor position
    _expression =
        _expression.substring(0, _cursorPosition) +
        processedInput +
        _expression.substring(_cursorPosition);
    _cursorPosition += processedInput.length;
    _updatePreview();
    notifyListeners();
  }

  void setCursorPosition(int position) {
    _cursorPosition = position.clamp(0, _expression.length);
    notifyListeners();
  }

  void moveCursorLeft() {
    if (_cursorPosition > 0) {
      _cursorPosition--;
      notifyListeners();
    }
  }

  void moveCursorRight() {
    if (_cursorPosition < _expression.length) {
      _cursorPosition++;
      notifyListeners();
    }
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _preview = '';
      return;
    }

    try {
      String processedExpression = _preprocessExpression(_expression);
      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(processedExpression);
      ContextModel cm = ContextModel();

      // Add mathematical constants
      cm.bindVariable(Variable('π'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      if (evalResult.isInfinite || evalResult.isNaN) {
        _preview = 'Error';
      } else {
        _preview = _formatNumber(evalResult);
      }
    } catch (e) {
      // Instead of showing blank, show a helpful preview
      String expr = _expression.toLowerCase();

      // Check for common incomplete expressions
      if (expr.endsWith('sin(') ||
          expr.endsWith('cos(') ||
          expr.endsWith('tan(')) {
        _preview = 'Enter angle in degrees';
      } else if (expr.endsWith('ln(') || expr.endsWith('log(')) {
        _preview = 'Enter positive number';
      } else if (expr.endsWith('√(')) {
        _preview = 'Enter non-negative number';
      } else if (expr.contains('(') && !expr.contains(')')) {
        _preview = 'Incomplete expression';
      } else if (expr.endsWith('+') ||
          expr.endsWith('-') ||
          expr.endsWith('×') ||
          expr.endsWith('÷') ||
          expr.endsWith('*') ||
          expr.endsWith('/')) {
        _preview = 'Enter next number';
      } else {
        // For other syntax errors, try to show partial evaluation if possible
        _preview = _tryPartialEvaluation(_expression);
      }
    }
  }

  /// Try to evaluate parts of the expression that are valid
  String _tryPartialEvaluation(String expr) {
    // Try to evaluate sub-expressions that might be complete
    try {
      // Look for complete numbers or simple operations
      String simplified = expr.replaceAll(RegExp(r'[+\-*/÷×()^]'), ' ');
      List<String> parts = simplified
          .split(' ')
          .where((s) => s.isNotEmpty)
          .toList();

      if (parts.isNotEmpty) {
        String lastPart = parts.last;
        if (double.tryParse(lastPart) != null) {
          return lastPart; // Show the last valid number
        }
      }

      return 'Check syntax';
    } catch (e) {
      return 'Check syntax';
    }
  }

  void calculate() {
    if (_expression.isEmpty) return;

    try {
      String originalExpression = _expression; // Store original for history
      String processedExpression = _preprocessExpression(_expression);

      // Validate expression before parsing
      if (processedExpression.isEmpty) {
        _result = 'Error';
        _hasError = true;
        _preview = '';
        return;
      }

      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(processedExpression);
      ContextModel cm = ContextModel();

      // Add mathematical constants
      cm.bindVariable(Variable('π'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      // Check for invalid results
      if (evalResult.isInfinite) {
        _result = 'Infinity';
        _hasError = true;
        _preview = '';
        AnalyticsService.logCalculatorOperation(
          'error',
          originalExpression,
          'Infinity',
        );
      } else if (evalResult.isNaN) {
        _result = 'Invalid';
        _hasError = true;
        _preview = '';
        AnalyticsService.logCalculatorOperation(
          'error',
          originalExpression,
          'NaN',
        );
      } else {
        String formattedResult = _formatNumber(evalResult);
        _result = formattedResult;
        _preview = ''; // Clear preview after calculation
        _hasError = false;

        // Store in history with format: expression = result
        String calculation = '$originalExpression = $formattedResult';
        _addToHistory(calculation);

        // Track successful calculation
        AnalyticsService.logCalculatorOperation(
          'success',
          originalExpression,
          formattedResult,
        );

        // Keep the original expression visible - don't replace with result
        // The user can see both the expression and result
        // If user wants to continue with result, they can manually clear and use result
      }
    } on FormatException catch (e) {
      _result = 'Format Error';
      _hasError = true;
      _preview = '';
      if (kDebugMode) {
        print('Format error in calculation: $e');
      }
      AnalyticsService.logCalculatorOperation(
        'error',
        _expression,
        'Format Error',
      );
    } on ArgumentError catch (e) {
      _result = 'Invalid Input';
      _hasError = true;
      _preview = '';
      if (kDebugMode) {
        print('Argument error in calculation: $e');
      }
      AnalyticsService.logCalculatorOperation(
        'error',
        _expression,
        'Invalid Input',
      );
    } on Exception catch (e) {
      String errorMessage = 'Syntax Error';
      String errorString = e.toString().toLowerCase();

      if (errorString.contains('division by zero') ||
          errorString.contains('divide by zero')) {
        errorMessage = 'Cannot divide by zero';
      } else if (errorString.contains('overflow')) {
        errorMessage = 'Number too large';
      } else if (errorString.contains('underflow')) {
        errorMessage = 'Number too small';
      } else if (errorString.contains('invalid') ||
          errorString.contains('illegal')) {
        errorMessage = 'Invalid expression';
      }

      _result = errorMessage;
      _hasError = true;
      _preview = '';
      if (kDebugMode) {
        print('Exception in calculation: $e');
      }
      AnalyticsService.logCalculatorOperation(
        'error',
        _expression,
        errorMessage,
      );
    } catch (e) {
      _result = 'Error';
      _hasError = true;
      _preview = '';
      if (kDebugMode) {
        print('Unexpected error in calculation: $e');
      }
      AnalyticsService.logCalculatorOperation(
        'error',
        _expression,
        'Unknown Error',
      );
    }

    notifyListeners();
  }

  void _addToHistory(String calculation) {
    _lastCalculation = calculation;
    // This will be called by the UI to add to history provider
    // The UI will handle the actual history storage
  }

  String _preprocessExpression(String expression) {
    if (expression.isEmpty) return '';

    String processed = expression;

    // Replace display symbols with math expression symbols
    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');

    // Handle scientific functions with proper parsing and error checking
    // Match function names followed by parentheses and content
    processed = processed.replaceAllMapped(RegExp(r'sin\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty sin parameter');
        double value = _evaluateSimpleExpression(content);
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid sin input');
        }
        return math
            .sin(value * math.pi / 180)
            .toString(); // Convert degrees to radians
      } catch (e) {
        return 'sin(${match.group(1)!})'; // Keep original if parsing fails
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'cos\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty cos parameter');
        double value = _evaluateSimpleExpression(content);
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid cos input');
        }
        return math.cos(value * math.pi / 180).toString();
      } catch (e) {
        return 'cos(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'tan\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty tan parameter');
        double value = _evaluateSimpleExpression(content);
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid tan input');
        }

        // Check for tan(90°) and tan(270°) which are undefined
        double normalizedValue = value % 360;
        if ((normalizedValue - 90).abs() < 0.000001 ||
            (normalizedValue - 270).abs() < 0.000001) {
          throw Exception('tan(90°) is undefined');
        }

        return math.tan(value * math.pi / 180).toString();
      } catch (e) {
        return 'tan(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'ln\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty ln parameter');
        double value = _evaluateSimpleExpression(content);
        if (value <= 0) throw Exception('ln requires positive number');
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid ln input');
        }
        return math.log(value).toString();
      } catch (e) {
        return 'ln(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'log\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty log parameter');
        double value = _evaluateSimpleExpression(content);
        if (value <= 0) throw Exception('log requires positive number');
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid log input');
        }
        return (math.log(value) / math.log(10)).toString();
      } catch (e) {
        return 'log(${match.group(1)!})';
      }
    });

    // Handle square root
    processed = processed.replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty sqrt parameter');
        double value = _evaluateSimpleExpression(content);
        if (value < 0) throw Exception('sqrt requires non-negative number');
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid sqrt input');
        }
        return math.sqrt(value).toString();
      } catch (e) {
        return 'sqrt(${match.group(1)!})';
      }
    });

    // Handle factorial with better validation
    processed = processed.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
      try {
        int value = int.parse(match.group(1)!);
        if (value < 0) {
          throw Exception('Factorial of negative number undefined');
        }
        if (value > 170) {
          throw Exception(
            'Factorial too large',
          ); // 170! is close to double limit
        }
        return _factorial(value).toString();
      } catch (e) {
        return '${match.group(1)!}!'; // Keep original on error
      }
    });

    // Now replace constants after function processing
    processed = processed.replaceAll('π', '3.141592653589793');
    processed = processed.replaceAll('e', '2.718281828459045');

    // Validate parentheses balance
    int openCount = processed.split('(').length - 1;
    int closeCount = processed.split(')').length - 1;
    if (openCount != closeCount) {
      throw Exception('Unbalanced parentheses');
    }

    // Check for invalid patterns like double operators
    if (RegExp(r'[\+\-\*/]{2,}').hasMatch(processed)) {
      throw Exception('Invalid operator sequence');
    }

    // Check for division by zero patterns
    if (RegExp(r'/\s*0(?!\d)').hasMatch(processed)) {
      throw Exception('Division by zero');
    }

    return processed;
  }

  // Helper method to evaluate simple expressions within function parameters
  double _evaluateSimpleExpression(String expr) {
    String processed = expr.trim();

    // Replace constants first
    processed = processed.replaceAll('π', '3.141592653589793');
    processed = processed.replaceAll('e', '2.718281828459045');
    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');

    // Try to parse as a simple number first
    try {
      return double.parse(processed);
    } catch (e) {
      // If not a simple number, try to evaluate as expression
      try {
        GrammarParser parser = GrammarParser();
        Expression exp = parser.parse(processed);
        return exp.evaluate(EvaluationType.REAL, ContextModel());
      } catch (e) {
        throw Exception('Cannot evaluate expression: $expr');
      }
    }
  }

  double _factorial(int n) {
    if (n < 0) throw Exception('Factorial of negative number is undefined');
    if (n > 170) throw Exception('Factorial too large to compute');
    if (n <= 1) return 1;

    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
      if (result.isInfinite) throw Exception('Factorial result too large');
    }
    return result;
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      String formatted = number.toStringAsFixed(10);
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      return formatted;
    }
  }

  void clear() {
    _expression = '';
    _preview = '';
    _result = '';
    _hasError = false;
    _cursorPosition = 0;
    AnalyticsService.logButtonPress('clear');
    notifyListeners();
  }

  void backspace() {
    if (_expression.isNotEmpty && _cursorPosition > 0) {
      _expression =
          _expression.substring(0, _cursorPosition - 1) +
          _expression.substring(_cursorPosition);
      _cursorPosition--;
      _updatePreview();
      AnalyticsService.logButtonPress('backspace');
      notifyListeners();
    }
  }

  void toggleScientificMode() {
    _isScientificMode = !_isScientificMode;
    AnalyticsService.logUserEngagement('scientific_mode_toggle');
    notifyListeners();
  }

  void insertFromHistory(String calculation) {
    try {
      // Extract the expression part before '=' from history
      if (!calculation.contains('=')) {
        // If no '=', treat the whole string as expression
        _expression = calculation.trim();
      } else {
        String expression = calculation.split('=')[0].trim();
        _expression = expression;
      }
      _cursorPosition = _expression.length;
      _updatePreview();
      AnalyticsService.logUserEngagement('history_insert');
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting from history: $e');
      }
      // Clear expression on error
      _expression = '';
      _cursorPosition = 0;
      _updatePreview();
      AnalyticsService.logError('history_insert_error', e.toString());
      notifyListeners();
    }
  }
}
