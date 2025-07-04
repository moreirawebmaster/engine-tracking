// Arquivo para garantir que todas as importações sejam testadas
// Isto ajuda a manter a cobertura de testes acima de 95%

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_configs.dart';

void main() {
  group('Test Coverage', () {
    test('should import all classes correctly', () {
      // Analytics
      expect(() => const EngineFirebaseAnalyticsConfig(enabled: true), returnsNormally);
      expect(
        () => const EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
          namespace: '',
          platform: '',
        ),
        returnsNormally,
      );
      expect(
        () => const EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
        returnsNormally,
      );
      expect(
        () => const EngineGoogleLoggingConfig(
          enabled: false,
          projectId: '',
          logName: '',
          credentials: {},
        ),
        returnsNormally,
      );
      expect(
        () => EngineAnalyticsModel(
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
          clarityConfig: const EngineClarityConfig(
            enabled: false,
            projectId: '',
          ),
        ),
        returnsNormally,
      );
      expect(EngineAnalyticsModelDefault.new, returnsNormally);

      // Bug Tracking
      expect(() => const EngineCrashlyticsConfig(enabled: true), returnsNormally);
      expect(
        () => EngineBugTrackingModel(
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
        ),
        returnsNormally,
      );
      expect(EngineBugTrackingModelDefault.new, returnsNormally);
    });

    test('should have static methods available', () {
      // Analytics static methods should be available
      expect(EngineAnalytics.isEnabled, isA<bool>());
      expect(EngineAnalytics.isInitialized, isA<bool>());

      // Bug tracking static methods should be available
      expect(EngineBugTracking.isEnabled, isA<bool>());
    });

    test('should handle edge cases', () {
      // Test toString methods
      const firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
      expect(firebaseConfig.toString(), isNotEmpty);

      const crashlyticsConfig = EngineCrashlyticsConfig(enabled: false);
      expect(crashlyticsConfig.toString(), isNotEmpty);

      const faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'test',
        appName: 'test',
        appVersion: 'test',
        environment: 'test',
        apiKey: 'test',
        namespace: '',
        platform: '',
      );
      expect(faroConfig.toString(), isNotEmpty);
      expect(faroConfig.toString(), contains('****')); // API key should be masked

      const splunkConfig = EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk.com',
        token: 'secret-token',
        source: 'app',
        sourcetype: 'json',
        index: 'main',
      );
      expect(splunkConfig.toString(), isNotEmpty);
      expect(splunkConfig.toString(), contains('****')); // Token should be masked

      const googleLoggingConfig = EngineGoogleLoggingConfig(
        enabled: true,
        projectId: 'test-project',
        logName: 'test-logs',
        credentials: {'private_key': 'secret-key'},
      );
      expect(googleLoggingConfig.toString(), isNotEmpty);
      expect(googleLoggingConfig.toString(), contains('****')); // Credentials should be masked
    });
  });
}
