import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineAnalyticsModel', () {
    test('should create instance with valid configs', () {
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'test',
        apiKey: 'test-key',
      );
      const splunkConfig = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk.com',
        token: 'test-token',
        source: 'test-source',
        sourcetype: 'json',
        index: 'main',
      );

      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: firebaseConfig,
        faroConfig: faroConfig,
        splunkConfig: splunkConfig,
      );

      expect(model.firebaseAnalyticsConfig, equals(firebaseConfig));
      expect(model.faroConfig, equals(faroConfig));
      expect(model.splunkConfig, equals(splunkConfig));
    });

    test('should not be equal to different types', () {
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: false);
      const faroConfig = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
      );
      const splunkConfig = EngineSplunkConfig(
        enabled: false,
        endpoint: '',
        token: '',
        source: '',
        sourcetype: '',
        index: '',
      );

      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: firebaseConfig,
        faroConfig: faroConfig,
        splunkConfig: splunkConfig,
      );

      expect(model, isNot(equals('string')));
      expect(model, isNot(equals(123)));
      expect(model, isNot(equals(true)));
    });

    test('toString should include all configurations', () {
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'test',
        apiKey: 'test-key',
      );
      const splunkConfig = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk.com',
        token: 'test-token',
        source: 'test-source',
        sourcetype: 'json',
        index: 'main',
      );

      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: firebaseConfig,
        faroConfig: faroConfig,
        splunkConfig: splunkConfig,
      );

      final stringRepresentation = model.toString();
      expect(stringRepresentation, contains('EngineAnalyticsModel'));
      expect(stringRepresentation, contains('firebaseAnalyticsConfig'));
      expect(stringRepresentation, contains('faroConfig'));
      expect(stringRepresentation, contains('splunkConfig'));
    });
  });

  group('EngineAnalyticsModelDefault', () {
    test('should create default instance with disabled configs', () {
      final defaultModel = EngineAnalyticsModelDefault();

      expect(defaultModel.firebaseAnalyticsConfig.enabled, isFalse);
      expect(defaultModel.faroConfig.enabled, isFalse);
      expect(defaultModel.splunkConfig.enabled, isFalse);
    });

    test('should have empty default values', () {
      final defaultModel = EngineAnalyticsModelDefault();

      expect(defaultModel.faroConfig.endpoint, isEmpty);
      expect(defaultModel.faroConfig.appName, isEmpty);
      expect(defaultModel.faroConfig.appVersion, isEmpty);
      expect(defaultModel.faroConfig.environment, isEmpty);
      expect(defaultModel.faroConfig.apiKey, isEmpty);

      expect(defaultModel.splunkConfig.endpoint, isEmpty);
      expect(defaultModel.splunkConfig.token, isEmpty);
      expect(defaultModel.splunkConfig.source, isEmpty);
      expect(defaultModel.splunkConfig.sourcetype, isEmpty);
      expect(defaultModel.splunkConfig.index, isEmpty);
    });
  });
}
