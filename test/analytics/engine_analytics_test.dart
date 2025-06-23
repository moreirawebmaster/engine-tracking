import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FirebaseAnalytics, Faro])
void main() {
  group('EngineAnalytics', () {
    setUp(() {
      EngineAnalytics.reset();
    });

    group('Initialization', () {
      test('should reset properly', () {
        EngineAnalytics.reset();
        expect(EngineAnalytics.faro, isNull);
      });

      test('should handle disabled services', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isFalse);
        expect(EngineAnalytics.isFaroEnabled, isFalse);
        expect(EngineAnalytics.isEnabled, isFalse);
      });

      test('should initialize with Firebase Analytics enabled only', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isTrue);
        expect(EngineAnalytics.isFaroEnabled, isFalse);
        expect(EngineAnalytics.isEnabled, isTrue);
      });

      test('should initialize with Faro enabled only', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineAnalytics.init(model);

        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isFalse);
        expect(EngineAnalytics.isFaroEnabled, isTrue);
        expect(EngineAnalytics.isEnabled, isTrue);
      });

      test('should initialize with both services enabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineAnalytics.init(model);

        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isTrue);
        expect(EngineAnalytics.isFaroEnabled, isTrue);
        expect(EngineAnalytics.isEnabled, isTrue);
      });
    });

    group('Method Calls', () {
      test('should handle log event when services disabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        // Should not throw even when services are disabled
        await EngineAnalytics.logEvent('test_event', {'key': 'value'});
        await EngineAnalytics.logEvent('test_event');
      });

      test('should handle user ID methods when services disabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        // Should not throw even when services are disabled
        await EngineAnalytics.setUserId('user123');
        await EngineAnalytics.setUserId('user123', 'user@example.com', 'Test User');

        // Should handle invalid user IDs
        await EngineAnalytics.setUserId('0');
        await EngineAnalytics.setUserId('');
      });

      test('should handle user property methods when services disabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        // Should not throw even when services are disabled
        await EngineAnalytics.setUserProperty('user_type', 'premium');
      });

      test('should handle page methods when services disabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        // Should not throw even when services are disabled
        await EngineAnalytics.setPage('HomeScreen');
        await EngineAnalytics.setPage('HomeScreen', 'WelcomeScreen', 'CustomClass');
      });

      test('should handle app open when services disabled', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);

        // Should not throw even when services are disabled
        await EngineAnalytics.logAppOpen();
      });
    });

    group('Configuration Checks', () {
      test('should correctly identify enabled services', () async {
        final firebaseModel = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(firebaseModel);
        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isTrue);
        expect(EngineAnalytics.isFaroEnabled, isFalse);

        EngineAnalytics.reset();

        final faroModel = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineAnalytics.init(faroModel);
        expect(EngineAnalytics.isFirebaseAnalyticsEnabled, isFalse);
        expect(EngineAnalytics.isFaroEnabled, isTrue);
      });
    });

    group('Faro Getter', () {
      test('should return faro instance when available', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: const EngineFaroConfig(
            enabled: true,
            endpoint: 'https://faro.example.com',
            appName: 'TestApp',
            appVersion: '1.0.0',
            environment: 'production',
            apiKey: 'test-key',
          ),
        );

        await EngineAnalytics.init(model);
        expect(EngineAnalytics.faro, isNotNull);
      });

      test('should return null when faro not initialized', () async {
        final model = EngineAnalyticsModel(
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
          faroConfig: const EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
          ),
        );

        await EngineAnalytics.init(model);
        expect(EngineAnalytics.faro, isNull);
      });
    });
  });
}
