import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineCrashlyticsConfig', () {
    test('should create config with enabled true', () {
      const config = EngineCrashlyticsConfig(enabled: true);

      expect(config.enabled, isTrue);
    });

    test('should create config with enabled false', () {
      const config = EngineCrashlyticsConfig(enabled: false);

      expect(config.enabled, isFalse);
    });

    test('should have correct toString representation', () {
      const config = EngineCrashlyticsConfig(enabled: true);

      expect(config.toString(), equals('EngineCrashlyticsConfig(enabled: true)'));
    });

    test('should have correct equality comparison', () {
      const config1 = EngineCrashlyticsConfig(enabled: true);
      const config2 = EngineCrashlyticsConfig(enabled: true);
      const config3 = EngineCrashlyticsConfig(enabled: false);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
      expect(config1 == config1, isTrue);
    });

    test('should have correct hashCode', () {
      const config1 = EngineCrashlyticsConfig(enabled: true);
      const config2 = EngineCrashlyticsConfig(enabled: true);
      const config3 = EngineCrashlyticsConfig(enabled: false);

      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1.hashCode, isNot(equals(config3.hashCode)));
    });

    test('should not be equal to different types', () {
      const config = EngineCrashlyticsConfig(enabled: true);

      expect(config, isNot(equals('string')));
      expect(config, isNot(equals(42)));
      expect(config, isNot(equals(null)));
    });
  });
}
