import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineFaroConfig', () {
    test('should create config with all parameters', () {
      final config = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro.example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'test-api-key',
        namespace: '',
        platform: '',
      );

      expect(config.enabled, isTrue);
      expect(config.endpoint, equals('https://faro.example.com'));
      expect(config.appName, equals('TestApp'));
      expect(config.appVersion, equals('1.0.0'));
      expect(config.environment, equals('production'));
      expect(config.apiKey, equals('test-api-key'));
    });

    test('should create disabled config', () {
      final config = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
        namespace: '',
        platform: '',
      );

      expect(config.enabled, isFalse);
      expect(config.endpoint, isEmpty);
      expect(config.appName, isEmpty);
      expect(config.appVersion, isEmpty);
      expect(config.environment, isEmpty);
      expect(config.apiKey, isEmpty);
    });

    test('should have correct toString representation with masked API key', () {
      final config = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro.example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'secret-key-123',
        namespace: '',
        platform: '',
      );

      final toString = config.toString();
      expect(toString, contains('enabled: true'));
      expect(toString, contains('endpoint: https://faro.example.com'));
      expect(toString, contains('appName: TestApp'));
      expect(toString, contains('appVersion: 1.0.0'));
      expect(toString, contains('environment: production'));
      expect(toString, contains('apiKey: ****'));
      expect(toString, isNot(contains('secret-key-123')));
    });

    test('should handle empty API key in toString', () {
      final config = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
        namespace: '',
        platform: '',
      );

      final toString = config.toString();
      expect(toString, contains('apiKey: ****'));
    });
  });
}
