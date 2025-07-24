import 'package:engine_tracking/src/config/config.dart';

/// Configuration for Firebase Analytics integration.
///
/// Provides settings for Firebase Analytics event tracking.
class EngineFirebaseAnalyticsConfig extends IEngineConfig {
  /// Creates a new Firebase Analytics configuration.
  ///
  /// [enabled] - Whether Firebase Analytics is enabled.
  EngineFirebaseAnalyticsConfig({required super.enabled});

  @override
  String toString() => 'EngineFirebaseAnalyticsConfig(enabled: $enabled)';
}
