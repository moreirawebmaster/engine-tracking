import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:engine_tracking/src/config/engine_splunk_config.dart';

class EngineAnalyticsModel {
  EngineAnalyticsModel({
    required this.firebaseAnalyticsConfig,
    required this.faroConfig,
    required this.splunkConfig,
  });

  final EngineFirebaseAnalyticsConfig firebaseAnalyticsConfig;
  final EngineFaroConfig faroConfig;
  final EngineSplunkConfig splunkConfig;

  @override
  String toString() =>
      'EngineAnalyticsModel(firebaseAnalyticsConfig: $firebaseAnalyticsConfig, faroConfig: $faroConfig, splunkConfig: $splunkConfig)';
}

class EngineAnalyticsModelDefault implements EngineAnalyticsModel {
  @override
  EngineFirebaseAnalyticsConfig get firebaseAnalyticsConfig => const EngineFirebaseAnalyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig =>
      const EngineFaroConfig(enabled: false, endpoint: '', appName: '', appVersion: '', environment: '', apiKey: '');

  @override
  EngineSplunkConfig get splunkConfig =>
      const EngineSplunkConfig(enabled: false, endpoint: '', token: '', source: '', sourcetype: '', index: '');
}
