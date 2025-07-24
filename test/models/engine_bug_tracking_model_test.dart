import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/models/engine_bug_tracking_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_configs.dart';

void main() {
  group('EngineBugTrackingModel', () {
    test('should create model with configurations', () {
      final crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
      final faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro.example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'test-key',
        namespace: '',
        platform: '',
      );

      final model = EngineBugTrackingModel(
        crashlyticsConfig: crashlyticsConfig,
        faroConfig: faroConfig,
        googleLoggingConfig: TestConfigs.googleLoggingConfigEnabled,
      );

      expect(model.crashlyticsConfig, equals(crashlyticsConfig));
      expect(model.faroConfig, equals(faroConfig));
      expect(model.googleLoggingConfig, equals(TestConfigs.googleLoggingConfigEnabled));
    });

    test('should have correct toString representation', () {
      final crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
      final faroConfig = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
        namespace: '',
        platform: '',
      );

      final model = EngineBugTrackingModel(
        crashlyticsConfig: crashlyticsConfig,
        faroConfig: faroConfig,
        googleLoggingConfig: TestConfigs.googleLoggingConfig,
      );

      final toString = model.toString();
      expect(toString, contains('EngineBugTrackingModel'));
      expect(toString, contains('crashlyticsConfig'));
      expect(toString, contains('faroConfig'));
      expect(toString, contains('googleLoggingConfig'));
    });
  });

  group('EngineBugTrackingModelDefault', () {
    test('should have disabled Crashlytics config', () {
      final model = EngineBugTrackingModelDefault();

      expect(model.crashlyticsConfig.enabled, isFalse);
    });

    test('should have disabled Faro config', () {
      final model = EngineBugTrackingModelDefault();

      expect(model.faroConfig.enabled, isFalse);
      expect(model.faroConfig.endpoint, isEmpty);
      expect(model.faroConfig.appName, isEmpty);
      expect(model.faroConfig.appVersion, isEmpty);
      expect(model.faroConfig.environment, isEmpty);
      expect(model.faroConfig.apiKey, isEmpty);
    });

    test('should have disabled Google Cloud Logging config', () {
      final model = EngineBugTrackingModelDefault();

      expect(model.googleLoggingConfig.enabled, isFalse);
      expect(model.googleLoggingConfig.projectId, isEmpty);
      expect(model.googleLoggingConfig.logName, isEmpty);
      expect(model.googleLoggingConfig.credentials, isEmpty);
    });

    test('should implement EngineBugTrackingModel interface', () {
      final model = EngineBugTrackingModelDefault();

      expect(model, isA<EngineBugTrackingModel>());
    });
  });
}
