import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineCrashlyticsConfig', () {
    test('should create config with enabled true', () {
      final config = EngineCrashlyticsConfig(enabled: true);

      expect(config.enabled, isTrue);
    });

    test('should create config with enabled false', () {
      final config = EngineCrashlyticsConfig(enabled: false);

      expect(config.enabled, isFalse);
    });

    test('should have correct toString representation', () {
      final config = EngineCrashlyticsConfig(enabled: true);

      expect(config.toString(), equals('EngineCrashlyticsConfig(enabled: true)'));
    });

    test('should not be equal to different types', () {
      final config = EngineCrashlyticsConfig(enabled: true);

      expect(config, isNot(equals('string')));
      expect(config, isNot(equals(42)));
      expect(config, isNot(equals(null)));
    });
  });
}
