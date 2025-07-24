import 'package:engine_tracking/src/config/config.dart';

/// Configuration for Firebase Crashlytics integration.
///
/// Provides settings for Firebase Crashlytics crash reporting.
class EngineCrashlyticsConfig extends IEngineConfig {
  /// Creates a new Firebase Crashlytics configuration.
  ///
  /// [enabled] - Whether Firebase Crashlytics is enabled.
  EngineCrashlyticsConfig({required super.enabled});

  @override
  String toString() => 'EngineCrashlyticsConfig(enabled: $enabled)';
}
