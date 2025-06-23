import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:engine_tracking/src/models/engine_bug_tracking_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineBugTrackingModel', () {
    test('should create model with configurations', () {
      const crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro.example.com',
        appName: 'TestApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'test-key',
      );

      final model = EngineBugTrackingModel(
        crashlyticsConfig: crashlyticsConfig,
        faroConfig: faroConfig,
      );

      expect(model.crashlyticsConfig, equals(crashlyticsConfig));
      expect(model.faroConfig, equals(faroConfig));
    });

    test('should have correct toString representation', () {
      const crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
      const faroConfig = EngineFaroConfig(
        enabled: false,
        endpoint: '',
        appName: '',
        appVersion: '',
        environment: '',
        apiKey: '',
      );

      final model = EngineBugTrackingModel(
        crashlyticsConfig: crashlyticsConfig,
        faroConfig: faroConfig,
      );

      final toString = model.toString();
      expect(toString, contains('EngineBugTrackingModel'));
      expect(toString, contains('crashlyticsConfig'));
      expect(toString, contains('faroConfig'));
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

    test('should implement EngineBugTrackingModel interface', () {
      final model = EngineBugTrackingModelDefault();

      expect(model, isA<EngineBugTrackingModel>());
    });
  });
}
