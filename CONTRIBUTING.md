# Contributing to Calculator Flutter

Thank you for your interest in contributing to Calculator Flutter! 🎉 We welcome contributions from developers of all skill levels. This document provides guidelines and information to help you contribute effectively to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)
- [License](#license)

## 🤝 Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. By participating, you agree to:

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility for mistakes
- Show empathy towards other contributors
- Help create a positive community

## 🚀 How to Contribute

### Types of Contributions

- **🐛 Bug Fixes**: Fix existing issues
- **✨ New Features**: Add new calculator functions or UI improvements
- **📚 Documentation**: Improve documentation, README, or code comments
- **🎨 UI/UX**: Enhance user interface and user experience
- **🧪 Testing**: Add or improve test coverage
- **🔧 Maintenance**: Code refactoring, performance improvements

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a feature branch** from `main`
4. **Make your changes**
5. **Test your changes**
6. **Submit a pull request**

## 🛠️ Development Setup

### Prerequisites

- **Flutter SDK** (>=3.9.2)
- **Dart SDK** (comes with Flutter)
- **Git** for version control
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase project** (for analytics features)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/muhammad-fiaz/Calculator-Flutter.git
   cd Calculator-Flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (optional, for analytics)
   - Create a Firebase project
   - Add Android and iOS apps
   - Download configuration files
   - Place them in the appropriate directories

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/               # State management
│   ├── calculator_provider.dart
│   ├── history_provider.dart
│   └── theme_provider.dart
├── screens/                 # UI screens
│   ├── main_screen.dart
│   ├── calculator_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── widgets/                 # Reusable components
│   ├── calculator_button.dart
│   └── calculator_display.dart
├── services/                # Business logic services
├── config/                  # Configuration files
└── utils/                   # Utility functions

assets/
├── images/                  # App icons and images
└── fonts/                   # Custom fonts (if any)

test/                        # Unit and widget tests
android/                     # Android-specific code
ios/                         # iOS-specific code
web/                         # Web-specific code
windows/                     # Windows-specific code
macos/                       # macOS-specific code
linux/                       # Linux-specific code
```

## 📝 Code Style Guidelines

### Dart/Flutter Conventions

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format`
- Maximum line length: 80 characters

### Naming Conventions

- **Classes**: PascalCase (e.g., `CalculatorProvider`)
- **Methods/Functions**: camelCase (e.g., `calculateResult()`)
- **Variables**: camelCase (e.g., `resultValue`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `MAX_HISTORY_SIZE`)
- **Files**: snake_case (e.g., `calculator_provider.dart`)

### Code Organization

- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use const constructors where possible
- Prefer immutable data structures

### Example Code Style

```dart
class CalculatorProvider extends ChangeNotifier {
  double _result = 0.0;

  double get result => _result;

  void calculate(String expression) {
    try {
      // Parse and evaluate the expression
      final parsedResult = _parseExpression(expression);
      _result = _evaluateExpression(parsedResult);
      notifyListeners();
    } catch (e) {
      // Handle calculation errors
      _result = double.nan;
      notifyListeners();
    }
  }

  double _parseExpression(String expression) {
    // Implementation here
    return 0.0;
  }

  double _evaluateExpression(double value) {
    // Implementation here
    return value;
  }
}
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/calculator_provider_test.dart

# Run tests in watch mode
flutter test --watch
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for high test coverage (>80%)
- Use descriptive test names
- Test both success and error scenarios

### Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/providers/calculator_provider.dart';

void main() {
  group('CalculatorProvider', () {
    late CalculatorProvider provider;

    setUp(() {
      provider = CalculatorProvider();
    });

    test('should calculate simple addition', () {
      provider.calculate('2 + 3');
      expect(provider.result, 5.0);
    });

    test('should handle invalid expressions', () {
      provider.calculate('invalid expression');
      expect(provider.result.isNaN, true);
    });
  });
}
```

## 📤 Submitting Changes

### Pull Request Process

1. **Ensure your code follows the guidelines**
   - Passes all tests
   - Follows code style
   - Includes appropriate documentation

2. **Update documentation** if needed
   - Update README.md for new features
   - Add code comments for complex logic

3. **Write a clear PR description**
   - Describe what changes you made
   - Explain why you made them
   - Reference any related issues

4. **PR Title Format**
   ```
   type: brief description

   Types: feat, fix, docs, style, refactor, test, chore
   ```

### PR Template

```markdown
## Description
Brief description of the changes made

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update
- [ ] Code style update

## How Has This Been Tested?
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing on device/emulator
- [ ] All existing tests still pass

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
```

## 🐛 Reporting Issues

### Bug Reports

When reporting bugs, please include:

- **Clear title** describing the issue
- **Steps to reproduce** the bug
- **Expected behavior** vs actual behavior
- **Screenshots** if applicable
- **Device information** (OS, Flutter version, etc.)
- **Error logs** or stack traces

### Feature Requests

For new features, please include:

- **Clear description** of the proposed feature
- **Use case** or problem it solves
- **Mockups or examples** if applicable
- **Implementation suggestions** (optional)

### Issue Template

```markdown
**Bug Report**

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
- OS: [e.g., Windows 10]
- Flutter Version: [e.g., 3.9.2]
- Device: [e.g., Android Emulator]

**Additional context**
Add any other context about the problem here.
```

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (Apache License 2.0).

## 🙏 Acknowledgments

Thank you for contributing to Calculator Flutter! Your efforts help make this calculator app better for everyone.

### Recognition

Contributors will be:
- Listed in the README.md contributors section
- Mentioned in release notes for significant contributions
- Added to the project's contributor graph

### Getting Help

If you need help with contributing:
- Check existing issues and pull requests
- Join our [Discord community](https://discord.com/invite/zvqm4VZ3Pk)
- Read the Flutter documentation
- Ask questions in GitHub discussions

---

**Happy coding! 🎉**</content>
