import 'package:engine_tracking/src/config/engine_clarity_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:engine_tracking/src/config/engine_google_logging_config.dart';
import 'package:engine_tracking/src/config/engine_splunk_config.dart';

/// Model for analytics configuration in Engine Tracking.
///
/// Aggregates all analytics service configurations.
class EngineAnalyticsModel {
  /// Creates a new analytics model.
  ///
  /// [clarityConfig] - Microsoft Clarity configuration.
  /// [firebaseAnalyticsConfig] - Firebase Analytics configuration.
  /// [faroConfig] - Grafana Faro configuration.
  /// [googleLoggingConfig] - Google Cloud Logging configuration.
  /// [splunkConfig] - Splunk configuration.
  EngineAnalyticsModel({
    required this.clarityConfig,
    required this.firebaseAnalyticsConfig,
    required this.faroConfig,
    required this.googleLoggingConfig,
    required this.splunkConfig,
  });

  /// Microsoft Clarity configuration.
  final EngineClarityConfig? clarityConfig;

  /// Firebase Analytics configuration.
  final EngineFirebaseAnalyticsConfig? firebaseAnalyticsConfig;

  /// Grafana Faro configuration.
  final EngineFaroConfig? faroConfig;

  /// Google Cloud Logging configuration.
  final EngineGoogleLoggingConfig? googleLoggingConfig;

  /// Splunk configuration.
  final EngineSplunkConfig? splunkConfig;

  @override
  String toString() =>
      'EngineAnalyticsModel(clarityConfig: $clarityConfig, firebaseAnalyticsConfig: $firebaseAnalyticsConfig, faroConfig: $faroConfig, googleLoggingConfig: $googleLoggingConfig, splunkConfig: $splunkConfig)';
}

/// Default implementation of EngineAnalyticsModel with all services disabled.
class EngineAnalyticsModelDefault implements EngineAnalyticsModel {
  @override
  EngineClarityConfig get clarityConfig => EngineClarityConfig(enabled: false, projectId: '');

  @override
  EngineFirebaseAnalyticsConfig get firebaseAnalyticsConfig => EngineFirebaseAnalyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig => EngineFaroConfig(
    enabled: false,
    endpoint: '',
    appName: '',
    appVersion: '',
    environment: '',
    apiKey: '',
    namespace: '',
    platform: '',
  );

  @override
  EngineGoogleLoggingConfig get googleLoggingConfig =>
      EngineGoogleLoggingConfig(enabled: false, projectId: '', logName: '', credentials: {});

  @override
  EngineSplunkConfig get splunkConfig =>
      EngineSplunkConfig(enabled: false, endpoint: '', token: '', source: '', sourcetype: '', index: '');
}
