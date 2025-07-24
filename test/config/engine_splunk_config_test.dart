import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineSplunkConfig', () {
    test('should create instance with all parameters', () {
      final config = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk-hec.example.com:8088/services/collector',
        token: 'test-hec-token',
        source: 'mobile-app',
        sourcetype: 'json',
        index: 'main',
      );

      expect(config.enabled, isTrue);
      expect(config.endpoint, equals('https://splunk-hec.example.com:8088/services/collector'));
      expect(config.token, equals('test-hec-token'));
      expect(config.source, equals('mobile-app'));
      expect(config.sourcetype, equals('json'));
      expect(config.index, equals('main'));
    });

    test('should create disabled instance', () {
      final config = EngineSplunkConfig(
        enabled: false,
        endpoint: '',
        token: '',
        source: '',
        sourcetype: '',
        index: '',
      );

      expect(config.enabled, isFalse);
      expect(config.endpoint, isEmpty);
      expect(config.token, isEmpty);
      expect(config.source, isEmpty);
      expect(config.sourcetype, isEmpty);
      expect(config.index, isEmpty);
    });

    test('toString should mask token', () {
      final config = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk.example.com',
        token: 'secret-token-123',
        source: 'app',
        sourcetype: 'json',
        index: 'main',
      );

      final stringRepresentation = config.toString();
      expect(stringRepresentation, contains('enabled: true'));
      expect(stringRepresentation, contains('endpoint: https://splunk.example.com'));
      expect(stringRepresentation, contains('source: app'));
      expect(stringRepresentation, contains('sourcetype: json'));
      expect(stringRepresentation, contains('index: main'));
      expect(stringRepresentation, contains('token: ****'));
      expect(stringRepresentation, isNot(contains('secret-token-123')));
    });

    test('should not be equal to different types', () {
      final config = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://example.com',
        token: 'token',
        source: 'source',
        sourcetype: 'json',
        index: 'main',
      );

      expect(config, isNot(equals('string')));
      expect(config, isNot(equals(123)));
      expect(config, isNot(equals(true)));
    });
  });
}
