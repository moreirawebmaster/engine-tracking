import 'package:engine_tracking/src/bug_tracking/engine_bug_tracking.dart';
import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/models/engine_bug_tracking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineBugTracking', () {
    setUp(() {
      EngineBugTracking.reset();
    });

    group('Initialization', () {
      test('should reset properly', () {
        EngineBugTracking.reset();
        expect(EngineBugTracking.isEnabled, isFalse);
      });

      test('should handle disabled services', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
        expect(EngineBugTracking.isEnabled, isFalse);
      });

      test('should initialize with Crashlytics enabled only', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        expect(EngineBugTracking.isCrashlyticsEnabled, isTrue);
        expect(EngineBugTracking.isFaroEnabled, isFalse);
        expect(EngineBugTracking.isEnabled, isTrue);
      });

      test('should initialize with Faro enabled only', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineBugTracking.init(model);

        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.isEnabled, isTrue);
      });

      test('should initialize with both services enabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineBugTracking.init(model);

        expect(EngineBugTracking.isCrashlyticsEnabled, isTrue);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
        expect(EngineBugTracking.isEnabled, isTrue);
      });
    });

    group('Method Calls', () {
      test('should handle custom key when services disabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        // Should not throw even when services are disabled
        await EngineBugTracking.setCustomKey('test_key', 'test_value');
      });

      test('should handle user identifier when services disabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        // Should not throw even when services are disabled
        await EngineBugTracking.setUserIdentifier('user123', 'user@example.com', 'Test User');

        // Should handle zero user ID
        await EngineBugTracking.setUserIdentifier('0', 'user@example.com', 'Test User');
      });

      test('should handle logging when services disabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        // Should not throw even when services are disabled
        await EngineBugTracking.log('Test message');
        await EngineBugTracking.log(
          'Test message',
          level: 'error',
          attributes: {'key': 'value'},
          stackTrace: StackTrace.current,
        );
      });

      test('should handle error recording when services disabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        // Should not throw even when services are disabled
        try {
          throw Exception('Test exception');
        } catch (e, stackTrace) {
          await EngineBugTracking.recordError(e, stackTrace);
          await EngineBugTracking.recordError(
            e,
            stackTrace,
            reason: 'Test error',
            information: ['Additional info'],
            isFatal: true,
            data: {'extra': 'data'},
          );
        }
      });

      test('should handle Flutter error recording when services disabled', () async {
        final model = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(model);

        final errorDetails = FlutterErrorDetails(
          exception: Exception('Test Flutter error'),
          stack: StackTrace.current,
          library: 'test',
        );

        // Should not throw even when services are disabled
        await EngineBugTracking.recordFlutterError(errorDetails);
      });
    });

    group('Configuration Checks', () {
      test('should correctly identify enabled services', () async {
        final crashlyticsModel = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineBugTracking.init(crashlyticsModel);
        expect(EngineBugTracking.isCrashlyticsEnabled, isTrue);
        expect(EngineBugTracking.isFaroEnabled, isFalse);

        EngineBugTracking.reset();

        final faroModel = EngineBugTrackingModel(
          crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineBugTracking.init(faroModel);
        expect(EngineBugTracking.isCrashlyticsEnabled, isFalse);
        expect(EngineBugTracking.isFaroEnabled, isTrue);
      });
    });
  });
}
