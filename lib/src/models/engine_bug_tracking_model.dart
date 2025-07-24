import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_google_logging_config.dart';

class EngineBugTrackingModel {
  EngineBugTrackingModel({this.crashlyticsConfig, this.faroConfig, this.googleLoggingConfig});

  final EngineCrashlyticsConfig? crashlyticsConfig;
  final EngineFaroConfig? faroConfig;
  final EngineGoogleLoggingConfig? googleLoggingConfig;

  @override
  String toString() =>
      'EngineBugTrackingModel(crashlyticsConfig: $crashlyticsConfig, faroConfig: $faroConfig, googleLoggingConfig: $googleLoggingConfig)';
}

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
