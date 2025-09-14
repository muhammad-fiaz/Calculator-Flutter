import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/providers/calculator_provider.dart';

void main() {
  group('Calculator Behavior Tests', () {
    late CalculatorProvider calculator;

    setUp(() {
      calculator = CalculatorProvider();
    });

    test('expression should NOT be replaced with result after calculation', () {
      // Test that original expression remains visible after = is clicked
      calculator.addInput('2');
      calculator.addInput('+');
      calculator.addInput('3');

      String originalExpression = calculator.expression;
      expect(originalExpression, '2+3');

      calculator.addInput('=');

      // Expression should remain the same, not be replaced with result
      expect(calculator.expression, '2+3');
      expect(calculator.result, '5');
    });

    test('preview should show helpful messages for incomplete expressions', () {
      calculator.clear();

      // Test incomplete sin function
      calculator.addInput('sin');
      expect(calculator.preview, 'Enter angle in degrees');

      calculator.clear();

      // Test incomplete cos function
      calculator.addInput('cos');
      expect(calculator.preview, 'Enter angle in degrees');

      calculator.clear();

      // Test incomplete ln function
      calculator.addInput('ln');
      expect(calculator.preview, 'Enter positive number');

      calculator.clear();

      // Test incomplete sqrt function
      calculator.addInput('√');
      expect(calculator.preview, 'Enter non-negative number');
    });

    test('preview should show helpful messages for incomplete operations', () {
      calculator.clear();

      // Test incomplete addition
      calculator.addInput('5');
      calculator.addInput('+');
      expect(calculator.preview, 'Enter next number');

      calculator.clear();

      // Test incomplete multiplication
      calculator.addInput('3');
      calculator.addInput('×');
      expect(calculator.preview, 'Enter next number');

      calculator.clear();

      // Test incomplete parentheses
      calculator.addInput('(');
      calculator.addInput('2');
      calculator.addInput('+');
      calculator.addInput('3');
      expect(calculator.preview, 'Incomplete expression');
    });

    test('preview should show partial evaluation when possible', () {
      calculator.clear();

      // Test valid number entry
      calculator.addInput('1');
      calculator.addInput('2');
      calculator.addInput('3');
      expect(calculator.preview, '123');

      calculator.clear();

      // Test decimal number
      calculator.addInput('3');
      calculator.addInput('.');
      calculator.addInput('1');
      calculator.addInput('4');
      expect(calculator.preview, '3.14');
    });

    test(
      'calculator should handle multiple calculations without clearing input',
      () {
        // First calculation
        calculator.addInput('2');
        calculator.addInput('+');
        calculator.addInput('3');
        calculator.addInput('=');

        expect(calculator.expression, '2+3');
        expect(calculator.result, '5');

        // User can continue by adding to the expression
        calculator.addInput('+');
        calculator.addInput('4');

        expect(calculator.expression, '2+3+4');
        expect(calculator.preview, '9');

        calculator.addInput('=');
        expect(calculator.expression, '2+3+4');
        expect(calculator.result, '9');
      },
    );

    test('clear should reset everything', () {
      calculator.addInput('5');
      calculator.addInput('+');
      calculator.addInput('3');
      calculator.addInput('=');

      expect(calculator.expression, '5+3');
      expect(calculator.result, '8');

      calculator.clear();

      expect(calculator.expression, '');
      expect(calculator.result, '');
      expect(calculator.preview, '');
      expect(calculator.hasError, false);
    });

    test('scientific functions should work with improved preview', () {
      calculator.clear();

      // Test sin with preview
      calculator.addInput('sin');
      expect(calculator.preview, 'Enter angle in degrees');

      calculator.addInput('3');
      calculator.addInput('0');
      calculator.addInput(')');

      // Should now show calculated preview
      expect(calculator.hasError, false);
      expect(double.parse(calculator.preview), closeTo(0.5, 0.01));

      calculator.addInput('=');
      expect(calculator.expression, 'sin(30)');
      expect(double.parse(calculator.result), closeTo(0.5, 0.01));
    });
  });
}
