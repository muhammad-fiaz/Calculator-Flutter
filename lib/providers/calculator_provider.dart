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
      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(processedExpression);
      ContextModel cm = ContextModel();

      // Add mathematical constants
      cm.bindVariable(Variable('π'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      if (evalResult.isInfinite || evalResult.isNaN) {
        _result = 'Error';
        _hasError = true;
        _preview = ''; // Clear preview when showing error
        AnalyticsService.logCalculatorOperation(
          'error',
          originalExpression,
          'NaN/Infinite',
        );
      } else {
        String formattedResult = _formatNumber(evalResult);
        _result = formattedResult;
        _preview = ''; // Clear preview after calculation

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
    } catch (e) {
      _result = 'Error';
      _hasError = true;
      _preview = ''; // Clear preview when showing error
      AnalyticsService.logCalculatorOperation(
        'error',
        _expression,
        'Parse Error',
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
    String processed = expression;

    // Replace display symbols with math expression symbols
    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');

    // Handle constants - replace after function processing
    // Keep π and e as placeholders for now

    // Handle scientific functions with proper parsing
    // Match function names followed by parentheses and content
    processed = processed.replaceAllMapped(RegExp(r'sin\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        double value = _evaluateSimpleExpression(content);
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
        double value = _evaluateSimpleExpression(content);
        return math.cos(value * math.pi / 180).toString();
      } catch (e) {
        return 'cos(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'tan\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        double value = _evaluateSimpleExpression(content);
        return math.tan(value * math.pi / 180).toString();
      } catch (e) {
        return 'tan(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'ln\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        double value = _evaluateSimpleExpression(content);
        if (value <= 0) throw Exception('Invalid value for ln');
        return math.log(value).toString();
      } catch (e) {
        return 'ln(${match.group(1)!})';
      }
    });

    processed = processed.replaceAllMapped(RegExp(r'log\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        double value = _evaluateSimpleExpression(content);
        if (value <= 0) throw Exception('Invalid value for log');
        return (math.log(value) / math.log(10)).toString();
      } catch (e) {
        return 'log(${match.group(1)!})';
      }
    });

    // Handle square root
    processed = processed.replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        double value = _evaluateSimpleExpression(content);
        if (value < 0) throw Exception('Invalid value for sqrt');
        return math.sqrt(value).toString();
      } catch (e) {
        return 'sqrt(${match.group(1)!})';
      }
    });

    // Handle factorial
    processed = processed.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
      int value = int.parse(match.group(1)!);
      return _factorial(value).toString();
    });

    // Now replace constants after function processing
    processed = processed.replaceAll('π', '3.141592653589793');
    processed = processed.replaceAll('e', '2.718281828459045');

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
    if (n <= 0) return 1;
    if (n == 1) return 1;
    return n * _factorial(n - 1);
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
