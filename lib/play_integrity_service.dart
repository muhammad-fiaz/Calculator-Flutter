import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Service for handling Google Play Integrity API integration
class PlayIntegrityService {
  static const MethodChannel _channel = MethodChannel('play_integrity');

  /// Request integrity verdict from Google Play
  /// Returns a map containing the integrity verdict data
  static Future<Map<String, dynamic>?> requestIntegrityVerdict() async {
    try {
      final result = await _channel.invokeMethod('requestIntegrityVerdict');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      // Log error to Crashlytics instead of print
      await FirebaseCrashlytics.instance.log(
        'Failed to get integrity verdict: ${e.message}',
      );
      return null;
    }
  }

  /// Check if the device is considered trustworthy
  static Future<bool> isDeviceTrustworthy() async {
    final verdict = await requestIntegrityVerdict();
    if (verdict == null) return false;

    // Check device integrity
    final deviceIntegrity = verdict['deviceIntegrity'] as String?;
    if (deviceIntegrity == null) return false;

    // Consider device trustworthy if integrity is MEETS_BASIC_INTEGRITY or better
    return deviceIntegrity.contains('MEETS_BASIC_INTEGRITY') ||
        deviceIntegrity.contains('MEETS_STRONG_INTEGRITY');
  }

  /// Get detailed integrity information for debugging
  static Future<String> getIntegrityDetails() async {
    final verdict = await requestIntegrityVerdict();
    if (verdict == null) return 'Unable to get integrity verdict';

    return '''
Device Integrity: ${verdict['deviceIntegrity'] ?? 'Unknown'}
App Recognition Verdict: ${verdict['appRecognitionVerdict'] ?? 'Unknown'}
Request Hash: ${verdict['requestHash'] ?? 'Unknown'}
Package Name: ${verdict['packageName'] ?? 'Unknown'}
Timestamp: ${verdict['timestampMillis'] ?? 'Unknown'}
    '''
        .trim();
  }
}
