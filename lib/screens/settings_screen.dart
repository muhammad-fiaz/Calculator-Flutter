import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../config/app_config.dart';
import '../services/update_service.dart';
import 'authors_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<String> _appVersion;

  @override
  void initState() {
    super.initState();
    _appVersion = AppConfig.appVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6),
                      title: const Text('Theme'),
                      subtitle: Text(
                        _getThemeModeText(themeProvider.themeMode),
                      ),
                      onTap: () => _showThemeDialog(context, themeProvider),
                    ),
                    ListTile(
                      leading: const Icon(Icons.palette),
                      title: const Text('Accent Color'),
                      subtitle: const Text('Choose your preferred color'),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: themeProvider.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      onTap: () => _showColorPicker(context, themeProvider),
                    ),
                    ListTile(
                      leading: const Icon(Icons.format_size),
                      title: const Text('Font Size'),
                      subtitle: Text(
                        '${(themeProvider.fontSize * 100).round()}%',
                      ),
                      trailing: SizedBox(
                        width: 150,
                        child: Slider(
                          value: themeProvider.fontSize,
                          min: 0.8,
                          max: 1.5,
                          divisions: 7,
                          onChanged: (value) =>
                              themeProvider.setFontSize(value),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Calculator Settings
          _buildSectionHeader(context, 'Calculator'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.vibration),
                      title: const Text('Haptic Feedback'),
                      subtitle: const Text('Vibrate on button press'),
                      value: themeProvider.enableVibration,
                      onChanged: themeProvider.setVibration,
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.volume_up),
                      title: const Text('Sound Effects'),
                      subtitle: const Text('Play sounds on button press'),
                      value: themeProvider.enableSounds,
                      onChanged: themeProvider.setSounds,
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.animation),
                      title: const Text('Animations'),
                      subtitle: const Text('Enable UI animations'),
                      value: themeProvider.enableAnimations,
                      onChanged: themeProvider.setAnimations,
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                FutureBuilder<String>(
                  future: _appVersion,
                  builder: (context, snapshot) {
                    return ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Version'),
                      subtitle: Text(snapshot.data ?? 'Loading...'),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.apps),
                  title: const Text('App Name'),
                  subtitle: Text(AppConfig.appName),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Description'),
                  subtitle: Text(AppConfig.appDescription),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Developer'),
                  subtitle: Text(AppConfig.developerName),
                  onTap: () => _launchUrl(context, AppConfig.developerGithub),
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Organization'),
                  subtitle: Text(AppConfig.organizationName),
                  onTap: () =>
                      _launchUrl(context, AppConfig.organizationWebsite),
                ),
                ListTile(
                  leading: const Icon(Icons.system_update),
                  title: const Text('Check for Updates'),
                  subtitle: const Text('Check for the latest version'),
                  onTap: () => UpdateService.manualUpdateCheck(context),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Source Code'),
                  subtitle: const Text('View on GitHub'),
                  onTap: () => _launchUrl(context, AppConfig.githubRepo),
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Report Issues'),
                  subtitle: const Text('Report bugs or request features'),
                  onTap: () => _launchUrl(context, AppConfig.githubIssues),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('Read our privacy policy'),
                  onTap: () => _launchUrl(context, AppConfig.privacyPolicyUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  subtitle: const Text('Read our terms of service'),
                  onTap: () => _launchUrl(context, AppConfig.termsOfServiceUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.gavel),
                  title: const Text('License'),
                  subtitle: Text(AppConfig.licenseName),
                  onTap: () => _showLicenseDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Support Section
          _buildSectionHeader(context, 'Support Development'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red[400]),
                  title: const Text('Donate'),
                  subtitle: const Text('Support further development'),
                  onTap: () => _launchUrl(context, AppConfig.donationLink),
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on_outlined),
                  title: const Text('GitHub Sponsor'),
                  subtitle: const Text('Sponsor on GitHub'),
                  onTap: () => _launchUrl(context, AppConfig.githubSponsor),
                ),
                ListTile(
                  leading: const Icon(Icons.star_outline),
                  title: const Text('Rate on GitHub'),
                  subtitle: const Text('Give us a star on GitHub'),
                  onTap: () => _launchUrl(context, AppConfig.githubRepo),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Credits & Contributions Section
          _buildSectionHeader(context, 'Credits & Contributions'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.people_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Contributors'),
                  subtitle: const Text(
                    'View all contributors and their contributions',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthorsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Contact Developer'),
                  subtitle: Text(AppConfig.developerEmail),
                  onTap: () =>
                      _launchUrl(context, 'mailto:${AppConfig.developerEmail}'),
                ),
                ListTile(
                  leading: const Icon(Icons.store_outlined),
                  title: const Text('Play Store'),
                  subtitle: const Text('Download from Google Play'),
                  onTap: () => _launchUrl(context, AppConfig.playStoreLink),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  AppConfig.appName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with ❤️ using Flutter',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showColorPicker(BuildContext context, ThemeProvider themeProvider) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Accent Color'),
          content: SizedBox(
            width: 280,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected =
                    color.toARGB32() == themeProvider.accentColor.toARGB32();

                return GestureDetector(
                  onTap: () {
                    themeProvider.setAccentColor(color);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System'),
                subtitle: const Text('Follow system setting'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.system);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Light'),
                subtitle: const Text('Light theme'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Dark'),
                subtitle: const Text('Dark theme'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLicenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apache License 2.0'),
          content: SingleChildScrollView(
            child: Text(
              '''Copyright 2025 Muhammad Fiaz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This calculator app is open source and free to use. You can find the complete source code on GitHub and contribute to its development.''',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () => _launchUrl(
                context,
                'https://www.apache.org/licenses/LICENSE-2.0',
              ),
              child: const Text('View Full License'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show user-friendly error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Unable to open link. No app found to handle this URL.',
              ),
              action: SnackBarAction(
                label: 'Copy URL',
                onPressed: () {
                  // Copy URL to clipboard as fallback
                  Clipboard.setData(ClipboardData(text: url));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copied to clipboard')),
                    );
                  }
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
      // Show user-friendly error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error opening link: ${e.toString().split(':').first}',
            ),
            action: SnackBarAction(
              label: 'Copy URL',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL copied to clipboard')),
                  );
                }
              },
            ),
          ),
        );
      }
    }
  }
}
