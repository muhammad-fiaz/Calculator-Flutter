import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class GitHubService {
  static const String _baseUrl = 'https://api.github.com';
  static const String _repoOwner = 'muhammad-fiaz';
  static const String _repoName = 'Calculator-Flutter';

  /// Fetch contributors from GitHub repository
  static Future<List<Contributor>> getContributors() async {
    try {
      final appVersion = await AppConfig.appVersion;
      debugPrint(
        'Fetching contributors from: $_baseUrl/repos/$_repoOwner/$_repoName/contributors',
      );
      final response = await http
          .get(
            Uri.parse('$_baseUrl/repos/$_repoOwner/$_repoName/contributors'),
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'Calculator-App/$appVersion',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> contributorsData = json.decode(response.body);
        return contributorsData
            .map((data) => Contributor.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load contributors: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching contributors: $e');
      throw Exception(
        'Unable to fetch contributors. Please check your internet connection.',
      );
    }
  }

  /// Fetch repository information
  static Future<Repository> getRepositoryInfo() async {
    try {
      final appVersion = await AppConfig.appVersion;
      final response = await http
          .get(
            Uri.parse('$_baseUrl/repos/$_repoOwner/$_repoName'),
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'Calculator-App/$appVersion',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> repoData = json.decode(response.body);
        return Repository.fromJson(repoData);
      } else {
        throw Exception(
          'Failed to load repository info: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching repository info: $e');
      throw Exception('Unable to fetch repository information.');
    }
  }

  /// Fetch commit statistics for contributors
  static Future<List<ContributorStats>> getContributorStats() async {
    try {
      final appVersion = await AppConfig.appVersion;
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/repos/$_repoOwner/$_repoName/stats/contributors',
            ),
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'Calculator-App/$appVersion',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> statsData = json.decode(response.body);
        return statsData
            .map((data) => ContributorStats.fromJson(data))
            .toList();
      } else if (response.statusCode == 202) {
        // GitHub is still computing stats, return empty list
        return [];
      } else {
        throw Exception(
          'Failed to load contributor stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching contributor stats: $e');
      return []; // Return empty list on error for stats
    }
  }
}

class Contributor {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  final String type;
  final int contributions;

  Contributor({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
    required this.contributions,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      login: json['login'] ?? '',
      id: json['id'] ?? 0,
      avatarUrl: json['avatar_url'] ?? '',
      htmlUrl: json['html_url'] ?? '',
      type: json['type'] ?? 'User',
      contributions: json['contributions'] ?? 0,
    );
  }
}

class Repository {
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final int stargazersCount;
  final int forksCount;
  final String language;
  final String? license;
  final DateTime createdAt;
  final DateTime updatedAt;

  Repository({
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.language,
    this.license,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'] ?? '',
      htmlUrl: json['html_url'] ?? '',
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      language: json['language'] ?? '',
      license: json['license']?['name'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class ContributorStats {
  final Contributor author;
  final int total;
  final List<WeeklyStats> weeks;

  ContributorStats({
    required this.author,
    required this.total,
    required this.weeks,
  });

  factory ContributorStats.fromJson(Map<String, dynamic> json) {
    return ContributorStats(
      author: Contributor.fromJson(json['author'] ?? {}),
      total: json['total'] ?? 0,
      weeks:
          (json['weeks'] as List<dynamic>?)
              ?.map((week) => WeeklyStats.fromJson(week))
              .toList() ??
          [],
    );
  }
}

class WeeklyStats {
  final DateTime week;
  final int additions;
  final int deletions;
  final int commits;

  WeeklyStats({
    required this.week,
    required this.additions,
    required this.deletions,
    required this.commits,
  });

  factory WeeklyStats.fromJson(Map<String, dynamic> json) {
    return WeeklyStats(
      week: DateTime.fromMillisecondsSinceEpoch((json['w'] ?? 0) * 1000),
      additions: json['a'] ?? 0,
      deletions: json['d'] ?? 0,
      commits: json['c'] ?? 0,
    );
  }
}
