import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';

class EngineAnalyticsModel {
  EngineAnalyticsModel({required this.firebaseAnalyticsConfig, required this.faroConfig});

  final EngineFirebaseAnalyticsConfig firebaseAnalyticsConfig;
  final EngineFaroConfig faroConfig;

  @override
  String toString() =>
      'EngineAnalyticsModel(firebaseAnalyticsConfig: $firebaseAnalyticsConfig, faroConfig: $faroConfig)';
}

class EngineAnalyticsModelDefault implements EngineAnalyticsModel {
  @override
  EngineFirebaseAnalyticsConfig get firebaseAnalyticsConfig => const EngineFirebaseAnalyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig =>
      const EngineFaroConfig(enabled: false, endpoint: '', appName: '', appVersion: '', environment: '', apiKey: '');
}
