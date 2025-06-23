import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';

class EngineBugTrackingModel {
  EngineBugTrackingModel({required this.crashlyticsConfig, required this.faroConfig});

  final EngineCrashlyticsConfig crashlyticsConfig;
  final EngineFaroConfig faroConfig;

  @override
  String toString() => 'EngineBugTrackingModel(crashlyticsConfig: $crashlyticsConfig, faroConfig: $faroConfig)';
}

class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  @override
  EngineCrashlyticsConfig get crashlyticsConfig => const EngineCrashlyticsConfig(enabled: false);

  @override
  EngineFaroConfig get faroConfig =>
      const EngineFaroConfig(enabled: false, endpoint: '', appName: '', appVersion: '', environment: '', apiKey: '');
}
