import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/calculator_display.dart';
import '../widgets/calculator_button.dart';
import '../utils/error_handler.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(flex: 2, child: const CalculatorDisplay()),

            // Button area
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Consumer<CalculatorProvider>(
                  builder: (context, calculator, child) {
                    return calculator.isScientificMode
                        ? _buildScientificKeypad(context)
                        : _buildStandardKeypad(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          Consumer<CalculatorProvider>(
            builder: (context, calculator, child) {
              return IconButton(
                icon: Icon(
                  calculator.isScientificMode
                      ? Icons.science_outlined
                      : Icons.functions,
                ),
                onPressed: () {
                  calculator.toggleScientificMode();
                },
                tooltip: calculator.isScientificMode
                    ? 'Standard Mode'
                    : 'Scientific Mode',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStandardKeypad(BuildContext context) {
    return Column(
      children: [
        // Row 1: C, ⌫, (, ), ÷
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, 'C', isFunction: true)),
              Expanded(child: _buildButton(context, '⌫', isFunction: true)),
              Expanded(child: _buildButton(context, '(', isOperator: true)),
              Expanded(child: _buildButton(context, ')', isOperator: true)),
              Expanded(child: _buildButton(context, '÷', isOperator: true)),
            ],
          ),
        ),

        // Row 2: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '7')),
              Expanded(child: _buildButton(context, '8')),
              Expanded(child: _buildButton(context, '9')),
              Expanded(child: _buildButton(context, '×', isOperator: true)),
            ],
          ),
        ),

        // Row 3: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '4')),
              Expanded(child: _buildButton(context, '5')),
              Expanded(child: _buildButton(context, '6')),
              Expanded(child: _buildButton(context, '-', isOperator: true)),
            ],
          ),
        ),

        // Row 4: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '1')),
              Expanded(child: _buildButton(context, '2')),
              Expanded(child: _buildButton(context, '3')),
              Expanded(child: _buildButton(context, '+', isOperator: true)),
            ],
          ),
        ),

        // Row 5: 0, ., =
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildButton(context, '0')),
              Expanded(child: _buildButton(context, '.')),
              Expanded(child: _buildButton(context, '=', isEquals: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScientificKeypad(BuildContext context) {
    return Column(
      children: [
        // Row 1: Functions
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, 'sin', isFunction: true)),
              Expanded(child: _buildButton(context, 'cos', isFunction: true)),
              Expanded(child: _buildButton(context, 'tan', isFunction: true)),
              Expanded(child: _buildButton(context, 'ln', isFunction: true)),
              Expanded(child: _buildButton(context, 'log', isFunction: true)),
            ],
          ),
        ),

        // Row 2: More functions
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '√', isFunction: true)),
              Expanded(child: _buildButton(context, 'x²', isFunction: true)),
              Expanded(child: _buildButton(context, 'x³', isFunction: true)),
              Expanded(child: _buildButton(context, 'π', isFunction: true)),
              Expanded(child: _buildButton(context, 'e', isFunction: true)),
            ],
          ),
        ),

        // Row 3: C, ⌫, (, ), ÷
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, 'C', isFunction: true)),
              Expanded(child: _buildButton(context, '⌫', isFunction: true)),
              Expanded(child: _buildButton(context, '(', isOperator: true)),
              Expanded(child: _buildButton(context, ')', isOperator: true)),
              Expanded(child: _buildButton(context, '÷', isOperator: true)),
            ],
          ),
        ),

        // Row 4: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '7')),
              Expanded(child: _buildButton(context, '8')),
              Expanded(child: _buildButton(context, '9')),
              Expanded(child: _buildButton(context, '×', isOperator: true)),
            ],
          ),
        ),

        // Row 5: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '4')),
              Expanded(child: _buildButton(context, '5')),
              Expanded(child: _buildButton(context, '6')),
              Expanded(child: _buildButton(context, '-', isOperator: true)),
            ],
          ),
        ),

        // Row 6: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton(context, '1')),
              Expanded(child: _buildButton(context, '2')),
              Expanded(child: _buildButton(context, '3')),
              Expanded(child: _buildButton(context, '+', isOperator: true)),
            ],
          ),
        ),

        // Row 7: 0, ., =
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildButton(context, '0')),
              Expanded(child: _buildButton(context, '.')),
              Expanded(child: _buildButton(context, '=', isEquals: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text, {
    bool isOperator = false,
    bool isFunction = false,
    bool isEquals = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: CalculatorButton(
        text: text,
        onPressed: () => _onButtonPressed(context, text),
        isOperator: isOperator,
        isFunction: isFunction,
        isEquals: isEquals,
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String buttonText) {
    final calculator = Provider.of<CalculatorProvider>(context, listen: false);
    final history = Provider.of<HistoryProvider>(context, listen: false);

    try {
      // Handle special function buttons
      if (buttonText == 'x²') {
        calculator.addInput('^2');
      } else if (buttonText == 'x³') {
        calculator.addInput('^3');
      } else {
        calculator.addInput(buttonText);
      }

      // Save to history when equals is pressed and we have a valid calculation
      if (buttonText == '=' &&
          calculator.lastCalculation != null &&
          !calculator.hasError) {
        // Extract expression and result from the lastCalculation format "expression = result"
        String calculation = calculator.lastCalculation!;
        List<String> parts = calculation.split(' = ');
        if (parts.length == 2) {
          history.addCalculation(parts[0], parts[1]);
        }
      }

      // Show specific error messages for button operations
      if (calculator.hasError && calculator.result.isNotEmpty) {
        String errorMessage = calculator.result;

        switch (errorMessage) {
          case 'Cannot divide by zero':
            ErrorHandler.showErrorToast(context, 'Cannot divide by zero');
            break;
          case 'Invalid Input':
            ErrorHandler.showErrorToast(
              context,
              'Invalid input. Please check your expression.',
            );
            break;
          case 'Format Error':
            ErrorHandler.showErrorToast(
              context,
              'Invalid format. Please correct your input.',
            );
            break;
          case 'Infinity':
            ErrorHandler.showWarningToast(
              context,
              'Result is too large to display',
            );
            break;
          case 'Invalid':
            ErrorHandler.showErrorToast(context, 'Invalid calculation');
            break;
          case 'Number too large':
            ErrorHandler.showWarningToast(
              context,
              'Number is too large to calculate',
            );
            break;
          case 'Invalid expression':
            ErrorHandler.showErrorToast(
              context,
              'Invalid expression. Please check syntax.',
            );
            break;
          case 'Syntax Error':
            ErrorHandler.showErrorToast(
              context,
              'Syntax error. Please check your input.',
            );
            break;
          default:
            if (errorMessage.contains('Error')) {
              ErrorHandler.showErrorToast(
                context,
                'Calculation error. Please try again.',
              );
            }
            break;
        }
      }
    } catch (e) {
      ErrorHandler.handleException(
        e,
        StackTrace.current,
        context: context,
        userMessage: 'Button operation failed. Please try again.',
        operation: 'Button press: $buttonText',
      );
    }
  }
}
