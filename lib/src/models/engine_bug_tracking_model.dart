import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_google_logging_config.dart';

/// Model for bug tracking configuration in Engine Tracking.
///
/// Aggregates all bug tracking service configurations.
class EngineBugTrackingModel {
  /// Creates a new bug tracking model.
  ///
  /// [crashlyticsConfig] - Firebase Crashlytics configuration.
  /// [faroConfig] - Grafana Faro configuration.
  /// [googleLoggingConfig] - Google Cloud Logging configuration.
  EngineBugTrackingModel({this.crashlyticsConfig, this.faroConfig, this.googleLoggingConfig});

  /// Firebase Crashlytics configuration.
  final EngineCrashlyticsConfig? crashlyticsConfig;

  /// Grafana Faro configuration.
  final EngineFaroConfig? faroConfig;

  /// Google Cloud Logging configuration.
  final EngineGoogleLoggingConfig? googleLoggingConfig;

  @override
  String toString() =>
      'EngineBugTrackingModel(crashlyticsConfig: $crashlyticsConfig, faroConfig: $faroConfig, googleLoggingConfig: $googleLoggingConfig)';
}

/// Default implementation of EngineBugTrackingModel with all services disabled.
class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  @override
  EngineCrashlyticsConfig get crashlyticsConfig => EngineCrashlyticsConfig(enabled: false);

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
}
