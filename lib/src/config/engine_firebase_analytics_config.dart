import 'package:engine_tracking/src/config/config.dart';

class EngineFirebaseAnalyticsConfig extends IEngineConfig {
  EngineFirebaseAnalyticsConfig({required super.enabled});

  @override
  String toString() => 'EngineFirebaseAnalyticsConfig(enabled: $enabled)';
}
