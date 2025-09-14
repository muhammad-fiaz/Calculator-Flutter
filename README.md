
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
- **State Management**: Efficient state management using Provider pattern
- **Local Storage**: Persistent settings and history using SharedPreferences
- **Error Handling**: Robust error handling for invalid expressions
- **Performance Optimized**: Smooth animations and fast calculations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Firebase project configured (for analytics)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/muhammad-fiaz/Calculator-Flutter.git
   cd Calculator-Flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
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

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Add your app to the Firebase project
3. Download configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Enable Crashlytics and Performance Monitoring

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

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code quality
flutter analyze
```

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

