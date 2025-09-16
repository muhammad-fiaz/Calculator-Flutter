# Contributing to Calculator Flutter

Thank you for your interest in contributing to Calculator Flutter! 🎉 We welcome contributions from developers of all skill levels. This document provides guidelines and information to help you contribute effectively to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
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
- **🔒 Security**: Security enhancements and vulnerability fixes

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
- **Java JDK 17+** (for Android development)
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

### Android Signing Setup (for Release Builds)

The project includes pre-configured Android signing. For development:

1. **Check existing keystore**:
   ```bash
   ls android/app/upload-keystore.jks
   ```

2. **If keystore doesn't exist**, generate one:
   ```bash
   cd android/app
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

3. **Create signing.properties** (if missing):
   ```bash
   # In android/app/signing.properties
   storeFile=upload-keystore.jks
   storePassword=android
   keyAlias=upload
   keyPassword=android
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
├── main.dart                 # App entry point with Firebase initialization
├── firebase_options.dart     # Firebase configuration (generated)
├── providers/               # State management using Provider pattern
│   ├── calculator_provider.dart    # Calculator logic and expression evaluation
│   ├── history_provider.dart       # Calculation history and database operations
│   └── theme_provider.dart         # Theme management (light/dark/system)
├── screens/                 # UI screens
│   ├── main_screen.dart            # Main app screen with navigation
│   ├── calculator_screen.dart      # Calculator interface
│   ├── history_screen.dart         # Calculation history view
│   └── settings_screen.dart        # App settings
├── widgets/                 # Reusable UI components
│   ├── calculator_button.dart      # Calculator button component
│   └── calculator_display.dart     # Expression/result display
├── services/                # Business logic services
│   ├── analytics_service.dart      # Firebase Analytics integration
│   └── play_integrity_service.dart # Google Play Integrity API
├── utils/                   # Utility functions
│   └── error_handler.dart          # Centralized error handling
├── models/                  # Data models
│   └── calculation_entry.dart      # Calculation history model
└── config/                  # Configuration files

assets/
├── images/                  # App icons and images
│   ├── logo.png             # Main app logo
│   ├── logo-web.png         # Web-specific logo
│   └── logo.ico             # Windows icon
└── fonts/                   # Custom fonts (if any)

test/                        # Unit and widget tests
├── calculator_provider_test.dart
├── history_provider_test.dart
└── widget_test.dart

android/                     # Android-specific configuration
├── app/
│   ├── build.gradle.kts     # Android build configuration
│   ├── proguard-rules.pro   # Code obfuscation rules
│   ├── signing.properties   # Signing configuration (gitignored)
│   └── upload-keystore.jks  # Release keystore
└── ...

ios/                         # iOS-specific configuration
web/                         # Web-specific configuration
windows/                     # Windows-specific configuration
macos/                       # macOS-specific configuration
linux/                       # Linux-specific configuration
```

## 🛠️ Tech Stack

### Core Framework
- **Flutter** (>=3.9.2) - Cross-platform UI framework
- **Dart** - Programming language

### State Management
- **Provider** - Dependency injection and state management
- **ChangeNotifier** - Reactive state updates

### Database & Storage
- **SQLite** (sqflite) - Local database for calculation history
- **SharedPreferences** - Local key-value storage for settings

### Firebase Services
- **Firebase Core** - Firebase initialization
- **Firebase Analytics** - User behavior tracking
- **Firebase Crashlytics** - Crash reporting and analysis
- **Firebase Performance** - App performance monitoring
- **Firebase App Check** - App integrity verification

### Security & Integrity
- **Google Play Integrity API** - Device integrity verification
- **Android Signing** - Code signing for release builds
- **ProGuard** - Code obfuscation for Android releases

### UI & Design
- **Material Design 3** - Modern design system
- **Adaptive Themes** - Light/dark mode support
- **Responsive Layout** - Multi-device compatibility

### Development Tools
- **Flutter Intl** - Internationalization support
- **Flutter Launcher Icons** - Automated icon generation
- **Build Runner** - Code generation
- **Dart Code Metrics** - Code quality analysis

### Testing
- **Flutter Test** - Unit and widget testing
- **Integration Test** - End-to-end testing
- **Mockito** - Mocking framework for tests

### Platform Support
- **Android** (API 21+) - Native Android apps
- **iOS** (iOS 12+) - Native iOS apps
- **Web** - Progressive Web App (PWA)
- **Windows** (10+) - Desktop Windows app
- **macOS** (10.14+) - Desktop macOS app
- **Linux** (Ubuntu 18.04+) - Desktop Linux app

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

# Run tests in watch mode (re-runs on file changes)
flutter test --watch

# Run integration tests
flutter test integration_test/

# Run tests for specific platform
flutter test --platform chrome  # Web tests
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check coverage threshold
flutter test --coverage --coverage-path=lcov.info
# Target: >80% coverage
```

### Code Quality Checks

```bash
# Analyze code for issues
flutter analyze

# Format code automatically
dart format .

# Check for unused files
flutter pub run dart_code_metrics:metrics check-unused-files lib

# Run all quality checks
flutter analyze && flutter test

# Check for security issues
flutter pub run dart_code_metrics:metrics check-security lib
```

### Writing Tests

#### Unit Tests
- Test business logic in providers
- Test utility functions
- Test error handling scenarios
- Aim for high coverage of critical paths

#### Widget Tests
- Test UI components behavior
- Test user interactions
- Test state changes and UI updates
- Test error states and loading states

#### Integration Tests
- Test complete user flows
- Test database operations
- Test Firebase integration
- Test platform-specific features

### Test Examples

#### Calculator Provider Test
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

    test('should handle division by zero', () {
      provider.calculate('5 ÷ 0');
      expect(provider.result.isNaN, true);
      // Verify error toast was shown
    });

    test('should handle invalid expressions', () {
      provider.calculate('invalid expression');
      expect(provider.result.isNaN, true);
    });

    test('should handle scientific functions', () {
      provider.calculate('sin(30°)');
      expect(provider.result, closeTo(0.5, 0.001));
    });
  });
}
```

#### History Provider Test
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/providers/history_provider.dart';

void main() {
  group('HistoryProvider', () {
    late HistoryProvider provider;

    setUp(() async {
      provider = HistoryProvider();
      await provider.initDatabase();
    });

    tearDown(() async {
      await provider.dispose();
    });

    test('should add calculation to history', () async {
      await provider.addCalculation('2 + 3', '5');
      expect(provider.history.length, 1);
      expect(provider.history.first.expression, '2 + 3');
    });

    test('should handle database errors gracefully', () async {
      // Simulate database error
      await provider.clearHistory();
      // Verify app doesn't crash and shows error toast
    });
  });
}
```

#### Widget Test
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/screens/calculator_screen.dart';
import 'package:calculator/providers/calculator_provider.dart';

void main() {
  testWidgets('Calculator screen shows result', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => CalculatorProvider(),
          child: const CalculatorScreen(),
        ),
      ),
    );

    // Test button interactions
    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));

    // Verify result is displayed
    expect(find.text('5'), findsOneWidget);
  });
}
```

### Error Handling Testing

The app includes comprehensive error handling. When contributing:

1. **Test Error Scenarios**: Always test error cases
2. **Verify Error Messages**: Ensure user-friendly error messages
3. **Check Error Logging**: Verify errors are logged to Firebase Crashlytics
4. **Test Recovery**: Ensure app continues working after errors

#### Error Handling Test Example
```dart
test('should handle calculation errors gracefully', () {
  // Test division by zero
  provider.calculate('10 ÷ 0');
  
  // Verify result is NaN (not a number)
  expect(provider.result.isNaN, true);
  
  // Verify error was logged (in debug mode)
  // Verify UI shows error message to user
});
```

### Performance Testing

```bash
# Profile app performance
flutter run --profile

# Use DevTools for performance analysis
flutter pub global run devtools
```

### Accessibility Testing

- Test with screen readers
- Verify color contrast ratios
- Test keyboard navigation
- Check touch target sizes

### Security Considerations

When contributing to this project:

1. **Never commit sensitive data**:
   - Firebase config files are gitignored
   - Signing keys are gitignored
   - API keys should use environment variables

2. **Follow secure coding practices**:
   - Validate user input
   - Use parameterized queries for database operations
   - Handle errors gracefully without exposing sensitive information

3. **Android Signing Security**:
   - Keep keystore files secure
   - Use strong passwords for keystores
   - Never share signing configurations

4. **Firebase Security**:
   - Enable App Check for production
   - Use Firebase Security Rules
   - Monitor for unusual activity

### Error Handling System

The app includes a comprehensive error handling system:

#### Error Handler Utility (`lib/utils/error_handler.dart`)
- **Centralized error management**
- **Multiple toast types**: Success, Error, Warning
- **Firebase Crashlytics integration**
- **User-friendly error messages**

#### Usage in Code
```dart
import '../utils/error_handler.dart';

// Show success message
ErrorHandler.showSuccessToast(context, 'Calculation saved!');

// Show error message
ErrorHandler.showErrorToast(context, 'Failed to save calculation');

// Handle exceptions
try {
  // Risky operation
} catch (e) {
  ErrorHandler.showErrorToast(context, 'Operation failed');
  ErrorHandler.handleException(e, 'Operation context');
}
```

#### Error Handling Guidelines
1. **Always catch exceptions** in user-facing operations
2. **Show user-friendly messages** instead of technical errors
3. **Log errors** to Firebase Crashlytics for debugging
4. **Continue app functionality** even when operations fail
5. **Test error scenarios** thoroughly

#### Common Error Patterns
```dart
// Database operations
try {
  await databaseOperation();
} on DatabaseException catch (e) {
  ErrorHandler.showErrorToast(context, 'Database error occurred');
} catch (e) {
  ErrorHandler.showErrorToast(context, 'Unexpected error occurred');
}

// Network operations
try {
  await networkCall();
} on FirebaseException catch (e) {
  ErrorHandler.showErrorToast(context, 'Connection error');
} catch (e) {
  ErrorHandler.showErrorToast(context, 'Network error');
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
