import 'dart:io';

import 'package:engine_tracking/src/http/engine_http_override.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineHttpOverride', () {
    tearDown(() {
      HttpOverrides.global = null;
    });

    test('should create HTTP client with logging capabilities', () {
      final override = EngineHttpOverride(
        enableRequestLogging: true,
        enableResponseLogging: true,
        logName: 'TEST_HTTP',
      );

      final client = override.createHttpClient(null);
      expect(client, isNotNull);
      expect(client, isA<HttpClient>());
    });

    test('should chain with base override', () {
      final baseOverride = _MockHttpOverride();
      final override = EngineHttpOverride(
        existingOverrides: baseOverride,
        logName: 'TEST_HTTP',
      );

      final client = override.createHttpClient(null);
      expect(client, isNotNull);
    });

    test('should configure logging options correctly', () {
      final override = EngineHttpOverride(
        enableRequestLogging: false,
        enableResponseLogging: true,
        enableTimingLogging: false,
        enableHeaderLogging: true,
        enableBodyLogging: false,
        maxBodyLogLength: 500,
        logName: 'CUSTOM_LOG',
      );

      expect(override.enableRequestLogging, isFalse);
      expect(override.enableResponseLogging, isTrue);
      expect(override.enableTimingLogging, isFalse);
      expect(override.enableHeaderLogging, isTrue);
      expect(override.enableBodyLogging, isFalse);
      expect(override.maxBodyLogLength, equals(500));
      expect(override.logName, equals('CUSTOM_LOG'));
    });

    test('should use default configuration values', () {
      final override = EngineHttpOverride();

      expect(override.enableRequestLogging, isTrue);
      expect(override.enableResponseLogging, isTrue);
      expect(override.enableTimingLogging, isTrue);
      expect(override.enableHeaderLogging, isFalse);
      expect(override.enableBodyLogging, isFalse);
      expect(override.maxBodyLogLength, equals(1000));
      expect(override.logName, equals('HTTP_TRACKING'));
    });

    group('Integration with HttpOverrides.global', () {
      test('should set global override correctly', () {
        final override = EngineHttpOverride(logName: 'GLOBAL_TEST');
        HttpOverrides.global = override;

        expect(HttpOverrides.current, equals(override));
      });

      test('should restore previous override when disabled', () {
        final previousOverride = _MockHttpOverride();
        HttpOverrides.global = previousOverride;

        final engineOverride = EngineHttpOverride(
          existingOverrides: previousOverride,
          logName: 'ENGINE_TEST',
        );
        HttpOverrides.global = engineOverride;

        expect(HttpOverrides.current, equals(engineOverride));

        // Simulate restoration
        HttpOverrides.global = previousOverride;
        expect(HttpOverrides.current, equals(previousOverride));
      });
    });
  });
}

class _MockHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(final SecurityContext? context) => HttpClient(context: context);
}
