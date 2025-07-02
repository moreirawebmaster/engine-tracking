import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_configs.dart';

void main() {
  group('EngineBugTracking', () {
    setUp(EngineBugTracking.reset);

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

        expect(EngineBugTracking.isEnabled, isFalse);
        expect(EngineBugTracking.isInitialized, isTrue);
      });

      test('should initialize with adapters', () async {
        final adapters = [
          EngineCrashlyticsAdapter(
            const EngineCrashlyticsConfig(enabled: false),
          ),
          EngineFaroBugTrackingAdapter(
            const EngineFaroConfig(
              enabled: false,
              endpoint: '',
              appName: '',
              appVersion: '',
              environment: '',
              apiKey: '',
              namespace: '',
              platform: '',
            ),
          ),
        ];

        await EngineBugTracking.init(adapters);

        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineBugTracking.isEnabled, isFalse);
      });

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        expect(model.crashlyticsConfig.enabled, isTrue);
        expect(model.faroConfig.enabled, isFalse);
      });

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        expect(model.crashlyticsConfig.enabled, isFalse);
        expect(model.faroConfig.enabled, isTrue);
        expect(model.faroConfig.endpoint, equals('https://faro.example.com'));
      });

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        expect(model.crashlyticsConfig.enabled, isTrue);
        expect(model.faroConfig.enabled, isTrue);
        expect(model.faroConfig.appName, equals('TestApp'));
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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

        await EngineBugTracking.setUserIdentifier('user123', 'user@example.com', 'Test User');
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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        await EngineBugTracking.initWithModel(model);

        final errorDetails = FlutterErrorDetails(
          exception: Exception('Test Flutter error'),
          stack: StackTrace.current,
          library: 'test',
        );

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

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
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: TestConfigs.googleLoggingConfig,
        );

        expect(faroModel.crashlyticsConfig.enabled, isFalse);
        expect(faroModel.faroConfig.enabled, isTrue);
      });
    });
  });
}
