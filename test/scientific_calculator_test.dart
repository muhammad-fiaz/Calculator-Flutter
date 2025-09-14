import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/providers/calculator_provider.dart';

void main() {
  group('Scientific Calculator Tests', () {
    late CalculatorProvider calculator;

    setUp(() {
      calculator = CalculatorProvider();
    });

    test('sin function should work correctly', () {
      // Test sin(30) = 0.5
      calculator.addInput('sin');
      calculator.addInput('3');
      calculator.addInput('0');
      calculator.addInput(')');
      calculator.calculate();

      // sin(30°) ≈ 0.5
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(0.5, 0.01));
    });

    test('cos function should work correctly', () {
      calculator.clear();
      // Test cos(60) = 0.5
      calculator.addInput('cos');
      calculator.addInput('6');
      calculator.addInput('0');
      calculator.addInput(')');
      calculator.calculate();

      // cos(60°) ≈ 0.5
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(0.5, 0.01));
    });

    test('tan function should work correctly', () {
      calculator.clear();
      // Test tan(45) = 1
      calculator.addInput('tan');
      calculator.addInput('4');
      calculator.addInput('5');
      calculator.addInput(')');
      calculator.calculate();

      // tan(45°) ≈ 1
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(1.0, 0.01));
    });

    test('ln function should work correctly', () {
      calculator.clear();
      // Test ln(e) = 1
      calculator.addInput('ln');
      calculator.addInput('e');
      calculator.addInput(')');
      calculator.calculate();

      // ln(e) = 1
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(1.0, 0.01));
    });

    test('log function should work correctly', () {
      calculator.clear();
      // Test log(100) = 2
      calculator.addInput('log');
      calculator.addInput('1');
      calculator.addInput('0');
      calculator.addInput('0');
      calculator.addInput(')');
      calculator.calculate();

      // log(100) = 2
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(2.0, 0.01));
    });

    test('sqrt function should work correctly', () {
      calculator.clear();
      // Test √(16) = 4
      calculator.addInput('√');
      calculator.addInput('1');
      calculator.addInput('6');
      calculator.addInput(')');
      calculator.calculate();

      // √(16) = 4
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(4.0, 0.01));
    });

    test('should handle complex expressions with scientific functions', () {
      calculator.clear();
      // Test sin(30) + cos(60) = 0.5 + 0.5 = 1
      calculator.addInput('sin');
      calculator.addInput('3');
      calculator.addInput('0');
      calculator.addInput(')');
      calculator.addInput('+');
      calculator.addInput('cos');
      calculator.addInput('6');
      calculator.addInput('0');
      calculator.addInput(')');
      calculator.calculate();

      // sin(30°) + cos(60°) ≈ 1
      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(1.0, 0.01));
    });

    test('should handle constants π and e', () {
      calculator.clear();
      // Test π ≈ 3.14159
      calculator.addInput('π');
      calculator.calculate();

      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(3.14159, 0.01));
    });

    test('should handle power operations', () {
      calculator.clear();
      // Test 2^3 = 8
      calculator.addInput('2');
      calculator.addInput('^');
      calculator.addInput('3');
      calculator.calculate();

      expect(calculator.hasError, false);
      expect(double.parse(calculator.result), closeTo(8.0, 0.01));
    });
  });
}
