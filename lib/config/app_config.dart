import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  // App Information
  static const String appName = 'Calculator';

  // Get version dynamically from pubspec.yaml
  static Future<String> get appVersion async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static const String appDescription =
      'A modern, feature-rich calculator app built with Flutter';

  // Store Links
  static const String playStoreLink =
      'https://play.google.com/store/apps/details?id=dev.fiaz.calculator';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=dev.fiaz.calculator';

  // Links
  static const String githubRepo =
      'https://github.com/muhammad-fiaz/Calculator-Flutter';
  static const String githubUrl =
      'https://github.com/muhammad-fiaz/Calculator-Flutter';
  static const String githubIssues =
      'https://github.com/muhammad-fiaz/Calculator-Flutter/issues';
  static const String githubSponsor =
      'https://github.com/sponsors/muhammad-fiaz';
  static const String donationLink = 'https://pay.muhammadfiaz.com';

  // Developer Information
  static const String developerName = 'Muhammad Fiaz';
  static const String developerEmail = 'contact@muhammadfiaz.com';
  static const String developerWebsite = 'https://muhammad-fiaz.github.io';
  static const String developerGithub = 'https://github.com/muhammad-fiaz';
  static const String developerGithubUrl = 'https://github.com/muhammad-fiaz';

  // Organization Information
  static const String organizationName = 'Fiaz Technologies';
  static const String organizationGithub =
      'https://github.com/FiazTechnologies';
  static const String organizationGithubUrl =
      'https://github.com/FiazTechnologies';
  static const String organizationWebsite = 'https://fiaz.dev';
  static const String organizationEmail = 'contactus@fiaz.dev';

  // Legal Information
  static const String privacyPolicyUrl = 'https://fiaz.dev/privacy';
  static const String termsOfServiceUrl = 'https://fiaz.dev/terms';

  // Social Media Links
  static const String githubProfile = 'https://github.com/muhammad-fiaz';
  static const String linkedinProfile =
      'https://linkedin.com/in/muhammad-fiaz-8b2b57298';
  static const String twitterProfile = 'https://twitter.com/muhammadfiaz_';

  // License
  static const String licenseName = 'Apache License 2.0';
  static const String licenseUrl =
      'https://github.com/muhammad-fiaz/calculator/blob/main/LICENSE';

  // App Features
  static const List<String> features = [
    'Basic arithmetic operations',
    'Scientific calculations',
    'History management with SQLite',
    'Dark/Light theme support',
    'Responsive design',
    'Google Calculator-style interface',
    'Parentheses support with proper precedence',
    'Editable input with cursor positioning',
    'Horizontal scrolling for long expressions',
    'Auto-update functionality',
  ];

  // Calculator Settings
  static const int maxHistoryItems = 100;
  static const int maxDecimalPlaces = 10;
  static const bool enableVibration = true;
  static const bool enableSoundEffects = false;

  // Update Settings
  static const bool enableAutoUpdate = true;
  static const String updateCheckUrl =
      'https://api.github.com/repos/muhammad-fiaz/calculator/releases/latest';
}
