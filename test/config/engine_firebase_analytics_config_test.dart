import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineFirebaseAnalyticsConfig', () {
    test('should create config with enabled true', () {
      const config = EngineFirebaseAnalyticsConfig(enabled: true);

      expect(config.enabled, isTrue);
    });

    test('should create config with enabled false', () {
      const config = EngineFirebaseAnalyticsConfig(enabled: false);

      expect(config.enabled, isFalse);
    });

    test('should have correct toString representation', () {
      const config = EngineFirebaseAnalyticsConfig(enabled: true);

      expect(config.toString(), equals('EngineFirebaseAnalyticsConfig(enabled: true)'));
    });

    test('should have correct equality comparison', () {
      const config1 = EngineFirebaseAnalyticsConfig(enabled: true);
      const config2 = EngineFirebaseAnalyticsConfig(enabled: true);
      const config3 = EngineFirebaseAnalyticsConfig(enabled: false);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
      expect(config1 == config1, isTrue);
    });

    test('should have correct hashCode', () {
      const config1 = EngineFirebaseAnalyticsConfig(enabled: true);
      const config2 = EngineFirebaseAnalyticsConfig(enabled: true);
      const config3 = EngineFirebaseAnalyticsConfig(enabled: false);

      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1.hashCode, isNot(equals(config3.hashCode)));
    });

    test('should not be equal to different types', () {
      const config = EngineFirebaseAnalyticsConfig(enabled: true);

      expect(config, isNot(equals('string')));
      expect(config, isNot(equals(42)));
      expect(config, isNot(equals(null)));
    });
  });
}
