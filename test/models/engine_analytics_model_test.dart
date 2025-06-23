import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:engine_tracking/src/models/engine_analytics_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineAnalyticsModel', () {
    test('should create model with configurations', () {
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro.example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'test-key',
      );

      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: firebaseConfig,
        faroConfig: faroConfig,
      );

      expect(model.firebaseAnalyticsConfig, equals(firebaseConfig));
      expect(model.faroConfig, equals(faroConfig));
    });

    test('should have correct toString representation', () {
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
      );

      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: firebaseConfig,
        faroConfig: faroConfig,
      );

      final toString = model.toString();
      expect(toString, contains('EngineAnalyticsModel'));
      expect(toString, contains('firebaseAnalyticsConfig'));
      expect(toString, contains('faroConfig'));
    });
  });

  group('EngineAnalyticsModelDefault', () {
    test('should have disabled Firebase Analytics config', () {
      final model = EngineAnalyticsModelDefault();

      expect(model.firebaseAnalyticsConfig.enabled, isFalse);
    });

    test('should have disabled Faro config', () {
      final model = EngineAnalyticsModelDefault();

      expect(model.faroConfig.enabled, isFalse);
      expect(model.faroConfig.endpoint, isEmpty);
      expect(model.faroConfig.appName, isEmpty);
      expect(model.faroConfig.appVersion, isEmpty);
      expect(model.faroConfig.environment, isEmpty);
      expect(model.faroConfig.apiKey, isEmpty);
    });

    test('should implement EngineAnalyticsModel interface', () {
      final model = EngineAnalyticsModelDefault();

      expect(model, isA<EngineAnalyticsModel>());
    });
  });
}
