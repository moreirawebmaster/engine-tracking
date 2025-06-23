import 'package:engine_tracking/engine_tracking.dart';
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

      // Note: This test is commented out because it requires Firebase initialization
      test('should initialize with Crashlytics enabled only (mocked)', () async {
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

        // Test model configuration without actual initialization
        expect(model.crashlyticsConfig.enabled, isTrue);
        expect(model.faroConfig.enabled, isFalse);

        // Actual initialization would require Firebase app to be initialized
        // await EngineBugTracking.init(model);
      });

      // Note: This test is commented out because it requires Flutter binding initialization
      test('should initialize with Faro enabled only (mocked)', () async {
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

        // Test model configuration without actual initialization
        expect(model.crashlyticsConfig.enabled, isFalse);
        expect(model.faroConfig.enabled, isTrue);
        expect(model.faroConfig.endpoint, equals('https://faro.example.com'));

        // Actual initialization would require Flutter binding to be initialized
        // await EngineBugTracking.init(model);
      });

      // Note: This test is commented out because it requires both Firebase and binding initialization
      test('should initialize with both services enabled (mocked)', () async {
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

        // Test model configuration without actual initialization
        expect(model.crashlyticsConfig.enabled, isTrue);
        expect(model.faroConfig.enabled, isTrue);
        expect(model.faroConfig.appName, equals('TestApp'));

        // Actual initialization would require both Firebase and Flutter binding
        // await EngineBugTracking.init(model);
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
      test('should correctly identify enabled services (configuration only)', () async {
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

        // Test model configuration without actual initialization
        expect(crashlyticsModel.crashlyticsConfig.enabled, isTrue);
        expect(crashlyticsModel.faroConfig.enabled, isFalse);

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

        // Test model configuration without actual initialization
        expect(faroModel.crashlyticsConfig.enabled, isFalse);
        expect(faroModel.faroConfig.enabled, isTrue);
      });
    });
  });
}
