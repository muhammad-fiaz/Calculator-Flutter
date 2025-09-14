import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../services/github_service.dart';
import '../config/app_config.dart';

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  List<Contributor>? contributors;
  Repository? repository;
  List<ContributorStats>? contributorStats;
  bool isLoading = true;
  String? errorMessage;
  late Future<String> _appVersion;

  @override
  void initState() {
    super.initState();
    _appVersion = AppConfig.appVersion;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        GitHubService.getContributors(),
        GitHubService.getRepositoryInfo(),
        GitHubService.getContributorStats(),
      ]);

      setState(() {
        contributors = results[0] as List<Contributor>;
        repository = results[1] as Repository;
        contributorStats = results[2] as List<ContributorStats>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits & Contributions'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? _buildErrorWidget()
          : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load contributors',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _launchUrl(context, AppConfig.githubRepo),
              child: const Text('View on GitHub'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Repository Information
          if (repository != null) _buildRepositoryCard(),
          const SizedBox(height: 16),

          // Contributors Section
          _buildSectionHeader('Contributors'),
          const SizedBox(height: 8),
          if (contributors != null && contributors!.isNotEmpty)
            ...contributors!.map(
              (contributor) => _buildContributorCard(contributor),
            )
          else
            _buildEmptyState('No contributors found'),

          const SizedBox(height: 24),

          // Organization Information
          _buildSectionHeader('Organization'),
          const SizedBox(height: 8),
          _buildOrganizationCard(),

          const SizedBox(height: 24),

          // App Information
          _buildSectionHeader('Application'),
          const SizedBox(height: 8),
          _buildAppCard(),
        ],
      ),
    );
  }

  Widget _buildRepositoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    repository!.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (repository!.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                repository!.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatChip(Icons.star, '${repository!.stargazersCount}'),
                const SizedBox(width: 8),
                _buildStatChip(Icons.fork_right, '${repository!.forksCount}'),
                const SizedBox(width: 8),
                if (repository!.language.isNotEmpty)
                  _buildStatChip(Icons.code, repository!.language),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _launchUrl(context, repository!.htmlUrl),
                icon: const Icon(Icons.open_in_new),
                label: const Text('View Repository'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributorCard(Contributor contributor) {
    // Hide stats as requested - no longer needed
    // final stats = contributorStats?.firstWhere(
    //   (stat) => stat.author.login == contributor.login,
    //   orElse: () => ContributorStats(author: contributor, total: 0, weeks: []),
    // );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(contributor.avatarUrl),
          onBackgroundImageError: (_, __) {},
          child: contributor.avatarUrl.isEmpty
              ? Text(contributor.login.substring(0, 1).toUpperCase())
              : null,
        ),
        title: Text(
          contributor.login,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hide contribution numbers as requested
            // Text('${contributor.contributions} contributions'),
            // Hide commit numbers as requested
            // if (stats != null && stats.total > 0)
            //   Text(
            //     '${stats.total} commits',
            //     style: TextStyle(
            //       color: Theme.of(context).colorScheme.primary,
            //       fontSize: 12,
            //     ),
            //   ),
          ],
        ),
        trailing: Icon(
          contributor.type == 'User' ? Icons.person : Icons.business,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => _launchUrl(context, contributor.htmlUrl),
      ),
    );
  }

  Widget _buildOrganizationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppConfig.organizationName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Published by ${AppConfig.organizationName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _launchUrl(context, AppConfig.organizationGithubUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('GitHub'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _launchUrl(context, AppConfig.organizationWebsite),
                    icon: const Icon(Icons.language),
                    label: const Text('Website'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.apps, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppConfig.appName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppConfig.appDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _appVersion,
              builder: (context, snapshot) {
                return Text(
                  'Version ${snapshot.data ?? 'Loading...'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _launchUrl(context, AppConfig.playStoreUrl),
                icon: const Icon(Icons.shop),
                label: const Text('View on Play Store'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
