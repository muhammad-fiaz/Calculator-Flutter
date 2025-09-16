
<div align="center">

<img width="200" height="200" alt="Calculator Logo" src="https://github.com/user-attachments/assets/15d8dd38-b9fc-484b-9d82-df4f4844afc6" />

<h1>🧮 Calculator Flutter</h1>

[![GitHub issues](https://img.shields.io/github/issues/muhammad-fiaz/Calculator-Flutter)](https://github.com/muhammad-fiaz/Calculator-Flutter/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/muhammad-fiaz/Calculator-Flutter)](https://github.com/muhammad-fiaz/Calculator-Flutter/pulls)
[![GitHub contributors](https://img.shields.io/github/contributors/muhammad-fiaz/Calculator-Flutter)](https://github.com/muhammad-fiaz/Calculator-Flutter/graphs/contributors)
[![GitHub last commit](https://img.shields.io/github/last-commit/muhammad-fiaz/Calculator-Flutter)](https://github.com/muhammad-fiaz/Calculator-Flutter/commits/main)
[![GitHub license](https://img.shields.io/github/license/muhammad-fiaz/Calculator-Flutter)](https://github.com/muhammad-fiaz/Calculator-Flutter/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/muhammad-fiaz/Calculator-Flutter?style=social)](https://github.com/muhammad-fiaz/Calculator-Flutter/stargazers)

[![GitHub maintainer](https://img.shields.io/badge/maintainer-Muhammad%20Fiaz-blue)](https://github.com/muhammad-fiaz)
[![GitHub followers](https://img.shields.io/github/followers/muhammad-fiaz?label=Follow)](https://github.com/muhammad-fiaz?tab=followers)
[![GitHub sponsor](https://img.shields.io/badge/sponsor-Muhammad%20Fiaz-blue)](https://github.com/sponsors/muhammad-fiaz)
[![Get it on Google Play](https://img.shields.io/badge/Get%20it%20on-Google%20Play-brightgreen)](https://play.google.com/store/apps/details?id=dev.fiaz.calculator)

<div align="center">
<h3> Join our Discord Community: </h3>

[![Join Our Discord](https://img.shields.io/badge/Discord-Join_us!-blue?style=flat&logo=discord)](https://discord.com/invite/zvqm4VZ3Pk)

</div>
<br/>
</div>

Calculator is your essential tool for all your mathematical needs. With a clean and user-friendly interface, this app is designed to make both simple and complex calculations easy and efficient. Whether you're a student, professional, or just need quick calculations on the go, Calculator provides accurate results every time. Powered by Flutter, it offers a smooth and reliable experience across all your devices. Simplify your math with Calculator!

## 📱 ScreenShot

<p align="center">
  <img src="https://github.com/user-attachments/assets/40b85ea7-76ba-4ea6-86f2-4dbc08a68b47" width="200" />
  <img src="https://github.com/user-attachments/assets/e3153eae-7d8c-45af-9b1b-b2ce0de1d4cd" width="200" />
  <img src="https://github.com/user-attachments/assets/3331ccd6-f5e0-40b3-80bc-238641a232c2" width="200" />
  <img src="https://github.com/user-attachments/assets/ec7b5b82-903f-4115-8433-eb2283f22477" width="200" />
</p>


## ✨ Features

### 🔢 Calculator Modes
- **Standard Calculator**: Basic arithmetic operations with a clean, intuitive interface
- **Scientific Calculator**: Advanced mathematical functions including trigonometry, logarithms, powers, and more
- **Expression Parsing**: Supports complex expressions with proper precedence handling like `(1+1)*2/2+(8*8)`

### 📱 User Experience
- **Responsive Design**: Optimized for all screen sizes and orientations
- **Dark & Light Themes**: Beautiful themes that adapt to system preferences or manual selection
- **Calculation History**: Save, search, and replay past calculations
- **Material Design 3**: Modern UI following the latest design guidelines

### 🔧 Technical Features
- **Firebase Integration**: Performance monitoring and crash analytics
- **Google Play Integrity API**: Enhanced security and fraud prevention
- **State Management**: Efficient state management using Provider pattern
- **Local Storage**: Persistent settings and history using SharedPreferences
- **Error Handling**: Robust error handling for invalid expressions
- **Performance Optimized**: Smooth animations and fast calculations

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (>=3.9.2)
- **Dart SDK** (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Java JDK** (for Android development)
- **Firebase project** (for analytics and crash reporting)

### Quick Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/muhammad-fiaz/Calculator-Flutter.git
   cd Calculator-Flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (optional)
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your project
   - Download configuration files:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`
   - Enable services: Analytics, Crashlytics, Performance Monitoring

4. **Run the app**
   ```bash
   # Debug mode
   flutter run

   # Release mode (requires signing config)
   flutter run --release
   ```

### Platform-Specific Setup

#### Android Development
```bash
# Check Android setup
flutter doctor --android-licenses

# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS Development (macOS only)
```bash
# Install iOS dependencies
cd ios && pod install && cd ..

# Build for iOS
flutter build ios --release
```

#### Web Development
```bash
# Enable web support
flutter config --enable-web

# Run on web
flutter run -d chrome

# Build for web
flutter build web --release
```

#### Desktop Development
```bash
# Windows
flutter config --enable-windows-desktop
flutter run -d windows

# macOS
flutter config --enable-macos-desktop
flutter run -d macos

# Linux
flutter config --enable-linux-desktop
flutter run -d linux
```

## 📐 Calculator Functions

### Standard Operations
- Basic arithmetic: `+`, `-`, `×`, `÷`
- Decimal numbers with proper validation
- Percentage calculations
- Parentheses for grouping: `(`, `)`

### Scientific Functions
- **Trigonometry**: `sin`, `cos`, `tan` (supports both radians and degrees)
- **Logarithms**: `ln` (natural log), `log` (base 10)
- **Powers**: `x²`, `x³`, `xʸ`, `√x`
- **Advanced**: `x!` (factorial), `1/x` (reciprocal)
- **Constants**: `π` (pi), `e` (Euler's number)

### Expression Examples
```
(2 + 3) × 4 = 20
sin(30°) = 0.5
log(100) = 2
2³ + √16 = 12
5! = 120
```

## 🎨 Themes

### Light Theme
- Clean, bright interface
- High contrast for readability
- Material Design 3 color system

### Dark Theme
- Easy on the eyes
- Battery-friendly for OLED displays
- Consistent with system dark mode

### System Theme
- Automatically follows system settings
- Seamless transitions between modes

## 📊 History & Analytics

### Calculation History
- **Persistent Storage**: All calculations are saved locally
- **Search Functionality**: Find specific calculations quickly
- **Filter by Mode**: View standard or scientific calculations
- **Statistics**: Track usage patterns and calculation frequency
- **Export**: Export history for backup (coming soon)

### Firebase Analytics
- **Performance Monitoring**: Track app performance and optimization
- **Crash Reporting**: Automatic crash detection and reporting
- **Usage Analytics**: Understand feature usage patterns

## 🏗️ Architecture

### State Management
- **Provider Pattern**: Clean separation of business logic and UI
- **Multiple Providers**: Separate providers for calculator, history, and theme
- **Reactive UI**: Automatic UI updates when state changes

### Project Structure
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
└── widgets/                 # Reusable components
    ├── calculator_button.dart
    └── calculator_display.dart
```

## 🏗️ Build & Deployment

### Android Signing Configuration

The project includes pre-configured Android signing for release builds:

1. **Keystore Location**: `android/app/upload-keystore.jks`
2. **Signing Properties**: `android/app/signing.properties` (gitignored for security)
3. **Configuration**: Automatically loaded in `android/app/build.gradle.kts`

#### Setting up Signing for Release

The signing configuration is already set up. For custom keystores:

1. **Generate new keystore**:
   ```bash
   cd android/app
   keytool -genkey -v -keystore your-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your-alias
   ```

2. **Update signing.properties**:
   ```properties
   storeFile=your-keystore.jks
   storePassword=your-store-password
   keyAlias=your-alias
   keyPassword=your-key-password
   ```

3. **Update build.gradle.kts** if needed (already configured)

### Build Commands

```bash
# Debug builds
flutter build apk                    # Android APK (debug)
flutter build ios --debug           # iOS (debug)
flutter build web                   # Web (debug)

# Release builds
flutter build apk --release         # Android APK (signed)
flutter build appbundle --release   # Android App Bundle (recommended)
flutter build ios --release         # iOS (signed)
flutter build web --release         # Web (production)

# Platform-specific
flutter build windows --release     # Windows
flutter build macos --release       # macOS
flutter build linux --release       # Linux
```

### Deployment

#### Google Play Store
1. **Build App Bundle**:
   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Play Console**:
   - Go to [Google Play Console](https://play.google.com/console/)
   - Create new release
   - Upload `build/app/outputs/bundle/release/app-release.aab`

3. **Configure Play Integrity** (already integrated):
   - Enable API in Google Cloud Console
   - Configure integrity tokens in Play Console

#### Apple App Store
1. **Build for iOS**:
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**:
   - Open `ios/Runner.xcworkspace`
   - Product → Archive
   - Upload to App Store Connect

#### Web Deployment
1. **Build web**:
   ```bash
   flutter build web --release
   ```

2. **Deploy to hosting**:
   ```bash
   firebase deploy --only hosting
   # or upload build/web contents to your web server
   ```

#### Usage in Code
```dart
import 'package:calculator/play_integrity_service.dart';

// Check device integrity
bool isTrustworthy = await PlayIntegrityService.isDeviceTrustworthy();

// Get detailed integrity information
String details = await PlayIntegrityService.getIntegrityDetails();
```

#### Security Benefits
- **Device Integrity**: Detects rooted/jailbroken devices
- **App Recognition**: Verifies app authenticity
- **Fraud Prevention**: Protects against unauthorized modifications
- **Compliance**: Helps meet security requirements

## 🎨 App Logo & Icons

### Current Logo Configuration
The app uses `flutter_launcher_icons` to generate launcher icons for all platforms from a single source image. The current configuration in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/logo.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/images/logo-web.png"
    background_color: "#ffffff"
    theme_color: "#ffffff"
  windows:
    generate: true
    image_path: "assets/images/logo.ico"
    icon_size: 48
  macos:
    generate: true
    image_path: "assets/images/logo.png"
```

### Required Logo Files
Place the following files in the `assets/images/` directory:

- **Android & iOS**: `logo.png` (1024x1024px recommended)
- **Web**: `logo-web.png` (512x512px recommended, can be transparent)
- **Windows**: `logo.ico` (48x48px or larger, ICO format)
- **macOS**: `logo.png` (same as Android/iOS, PNG format)

### How to Update the Logo

1. **Replace the logo files** in `assets/images/` with your new logo files
2. **Update file paths** in `pubspec.yaml` if filenames change
3. **Regenerate icons** by running:
   ```bash
   dart run flutter_launcher_icons
   ```

### Platform-Specific Details

#### Android
- Generates multiple icon sizes (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- Creates `ic_launcher.png` and `launcher_icon.png` in each density folder
- Minimum SDK: API 21 (Android 5.0)

#### iOS
- Generates 20+ different icon sizes for all Apple devices
- Creates icons from 20x20px to 1024x1024px
- Updates `Contents.json` in the asset catalog

#### Web (PWA)
- Generates `Icon-192.png`, `Icon-512.png` for PWA
- Creates `Icon-maskable-192.png`, `Icon-maskable-512.png` for adaptive icons
- Updates `manifest.json` with icon references
- Sets background and theme colors

#### Windows
- Generates `app_icon.ico` in the Windows runner resources
- Icon size: 48x48px (configurable)
- Used for desktop shortcuts and taskbar

#### macOS
- Generates multiple PNG sizes from 16x16px to 1024x1024px
- Creates icons for dock, menu bar, and system preferences
- Updates `Contents.json` in the macOS asset catalog

### Tips for Best Results
- Use PNG format for transparency support
- Ensure logos have sufficient padding (at least 10% margin)
- Test on actual devices after generation
- For iOS, avoid pure white logos (use a colored background)
- For web, consider both masked and unmasked versions

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
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Code Quality

```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Check for unused files
flutter pub run dart_code_metrics:metrics check-unused-files lib

# Run all quality checks
flutter analyze && flutter test
```

## 🔧 Troubleshooting

### Common Issues

#### Build Issues

**Android Build Fails**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --debug

# Check Java version
java -version

# Accept Android licenses
flutter doctor --android-licenses
```

**iOS Build Fails**
```bash
# Clean iOS build
cd ios && rm -rf Pods/ Podfile.lock && cd ..
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios
```

**Firebase Configuration Issues**
```bash
# Check Firebase config files exist
ls android/app/google-services.json
ls ios/Runner/GoogleService-Info.plist

# Re-download Firebase config if missing
# Go to Firebase Console → Project Settings → Your apps
```

#### Runtime Issues

**App Crashes on Startup**
- Check device logs: `flutter logs`
- Verify Firebase configuration
- Check for missing permissions
- Ensure minimum SDK requirements are met

**Calculation Errors**
- Check expression syntax
- Verify mathematical operations are supported
- Review error logs in debug console

**Database Issues**
- Clear app data to reset local database
- Check available storage space
- Verify database file permissions

### Debug Commands

```bash
# View device logs
flutter logs

# Run in verbose mode
flutter run --verbose

# Check Flutter doctor
flutter doctor -v

# Clean all build artifacts
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### Performance Issues

- **Slow startup**: Check Firebase initialization
- **UI lag**: Profile with Flutter DevTools
- **Memory issues**: Monitor with Android Profiler/iOS Instruments
- **Battery drain**: Check background services

## 📊 Project Metrics

### Code Quality
- **Test Coverage**: Target >80%
- **Code Analysis**: Zero flutter analyze warnings
- **Platform Support**: 6 platforms (Android, iOS, Web, Windows, macOS, Linux)

### Performance
- **Startup Time**: <2 seconds (cold start)
- **Memory Usage**: <50MB (average)
- **Battery Impact**: Minimal background usage
- **Smooth Animations**: 60 FPS target

### Security
- **Code Obfuscation**: Enabled in release builds
- **Certificate Pinning**: Firebase security
- **Play Integrity**: Device verification
- **Secure Storage**: Encrypted local data

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)
- ✅ **Web** (Chrome, Firefox, Safari)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Code Style
- Follow Dart and Flutter conventions
- Use `flutter analyze` to check for issues
- Format code with `dart format`
- Write tests for new features

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you found this project helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 🤝 Contributing to the code

---

**Made with ❤️ using Flutter**

