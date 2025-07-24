import 'package:engine_tracking/src/config/config.dart';

class EngineCrashlyticsConfig extends IEngineConfig {
  EngineCrashlyticsConfig({required super.enabled});

  @override
  String toString() => 'EngineCrashlyticsConfig(enabled: $enabled)';
}
