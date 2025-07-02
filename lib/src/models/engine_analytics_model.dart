import 'package:engine_tracking/src/config/engine_clarity_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:engine_tracking/src/config/engine_google_logging_config.dart';
import 'package:engine_tracking/src/config/engine_splunk_config.dart';

class EngineAnalyticsModel {
  EngineAnalyticsModel({
    required this.clarityConfig,
    required this.firebaseAnalyticsConfig,
    required this.faroConfig,
    required this.googleLoggingConfig,
    required this.splunkConfig,
  });

  final EngineClarityConfig clarityConfig;
  final EngineFirebaseAnalyticsConfig firebaseAnalyticsConfig;
  final EngineFaroConfig faroConfig;
  final EngineGoogleLoggingConfig googleLoggingConfig;
  final EngineSplunkConfig splunkConfig;

  @override
  String toString() =>
      'EngineAnalyticsModel(clarityConfig: $clarityConfig, firebaseAnalyticsConfig: $firebaseAnalyticsConfig, faroConfig: $faroConfig, googleLoggingConfig: $googleLoggingConfig, splunkConfig: $splunkConfig)';
}

class EngineAnalyticsModelDefault implements EngineAnalyticsModel {
  @override
  EngineClarityConfig get clarityConfig => const EngineClarityConfig(enabled: false, projectId: '');

  @override
  EngineFirebaseAnalyticsConfig get firebaseAnalyticsConfig => const EngineFirebaseAnalyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig => const EngineFaroConfig(
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
  EngineGoogleLoggingConfig get googleLoggingConfig => const EngineGoogleLoggingConfig(
    enabled: false,
    projectId: '',
    logName: '',
    credentials: {},
  );

  @override
  EngineSplunkConfig get splunkConfig =>
      const EngineSplunkConfig(enabled: false, endpoint: '', token: '', source: '', sourcetype: '', index: '');
}
