import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineFirebaseAnalyticsConfig', () {
    test('should create config with enabled true', () {
      final config = EngineFirebaseAnalyticsConfig(enabled: true);

      expect(config.enabled, isTrue);
    });

    test('should create config with enabled false', () {
      final config = EngineFirebaseAnalyticsConfig(enabled: false);

      expect(config.enabled, isFalse);
    });

    test('should have correct toString representation', () {
      final config = EngineFirebaseAnalyticsConfig(enabled: true);

      expect(config.toString(), equals('EngineFirebaseAnalyticsConfig(enabled: true)'));
    });
  });
}
