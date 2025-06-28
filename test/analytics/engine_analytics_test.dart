import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_configs.dart';

void main() {
  group('EngineAnalytics', () {
    tearDown(() async {
      await EngineAnalytics.dispose();
    });

    test('should initialize with adapters', () async {
      final adapters = [
        EngineFirebaseAnalyticsAdapter(
          const EngineFirebaseAnalyticsConfig(enabled: false),
        ),
        EngineFaroAnalyticsAdapter(
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
        EngineSplunkAnalyticsAdapter(
          const EngineSplunkConfig(
            enabled: false,
            endpoint: '',
            token: '',
            source: '',
            sourcetype: '',
            index: '',
          ),
        ),
      ];

      await EngineAnalytics.init(adapters);

      expect(EngineAnalytics.isInitialized, isTrue);
      expect(EngineAnalytics.isEnabled, isFalse);
    });

    test('should initialize with model', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(EngineAnalytics.isInitialized, isTrue);
      expect(EngineAnalytics.isEnabled, isFalse);
    });

    test('should handle log event without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.logEvent('test_event'), returnsNormally);
    });

    test('should handle setUserId without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.setUserId('user123'), returnsNormally);
    });

    test('should handle setUserProperty without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.setUserProperty('test_prop', 'value'), returnsNormally);
    });

    test('should handle setPage without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.setPage('test_page'), returnsNormally);
    });

    test('should handle logAppOpen without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.logAppOpen(), returnsNormally);
    });

    test('should have enabled adapters when configs are enabled', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
        faroConfig: const EngineFaroConfig(
          enabled: true,
          endpoint: 'https://example.com',
          appName: 'TestApp',
          appVersion: '1.0.0',
          environment: 'test',
          apiKey: 'test-key',
          namespace: '',
          platform: '',
        ),
        googleLoggingConfig: TestConfigs.googleLoggingConfig,
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(EngineAnalytics.isEnabled, isTrue);
      expect(EngineAnalytics.isInitialized, isTrue);
    });

    test('should handle reset without throwing', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.reset(), returnsNormally);
    });

    test('should handle custom events', () async {
      final model = EngineAnalyticsModel(
        firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
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
        splunkConfig: const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
      );

      await EngineAnalytics.initWithModel(model);

      expect(() async => EngineAnalytics.logEvent('purchase', {'transaction_id': 'txn_123'}), returnsNormally);
      expect(() async => EngineAnalytics.logEvent('login', {'method': 'email'}), returnsNormally);
      expect(() async => EngineAnalytics.logEvent('sign_up', {'method': 'google'}), returnsNormally);
    });
  });
}
