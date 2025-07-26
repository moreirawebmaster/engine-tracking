import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:engine_tracking/src/http/engine_http_override.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineHttpTracking', () {
    tearDown(() {
      EngineHttpTracking.disable();
      HttpOverrides.global = null;
    });

    test('should initialize with valid model', () {
      const model = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          enableRequestLogging: true,
          enableResponseLogging: true,
          logName: 'TEST_HTTP',
        ),
      );

      EngineHttpTracking.initWithModel(model);

      expect(EngineHttpTracking.isEnabled, isTrue);
      expect(EngineHttpTracking.model, equals(model));
      expect(EngineHttpTracking.config?.logName, equals('TEST_HTTP'));
      expect(HttpOverrides.current, isA<EngineHttpOverride>());
    });

    test('should not initialize when disabled', () {
      const model = EngineHttpTrackingModel(
        enabled: false,
        httpTrackingConfig: EngineHttpTrackingConfig(
          logName: 'TEST_HTTP',
        ),
      );

      EngineHttpTracking.initWithModel(model);

      expect(EngineHttpTracking.isEnabled, isFalse);
      expect(EngineHttpTracking.model, isNull);
      expect(EngineHttpTracking.config, isNull);
    });

    test('should update model', () {
      const initialModel = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          enableRequestLogging: true,
          logName: 'INITIAL',
        ),
      );

      const updatedModel = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          enableRequestLogging: false,
          enableResponseLogging: true,
          logName: 'UPDATED',
        ),
      );

      EngineHttpTracking.initWithModel(initialModel);
      expect(EngineHttpTracking.config?.logName, equals('INITIAL'));

      EngineHttpTracking.updateModel(updatedModel);
      expect(EngineHttpTracking.config?.logName, equals('UPDATED'));
      expect(EngineHttpTracking.config?.enableRequestLogging, isFalse);
      expect(EngineHttpTracking.config?.enableResponseLogging, isTrue);
    });

    test('should disable HTTP tracking', () {
      const model = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          logName: 'TEST_HTTP',
        ),
      );

      EngineHttpTracking.initWithModel(model);
      expect(EngineHttpTracking.isEnabled, isTrue);

      EngineHttpTracking.disable();
      expect(EngineHttpTracking.isEnabled, isFalse);
      expect(EngineHttpTracking.model, isNull);
      expect(EngineHttpTracking.config, isNull);
    });

    test('should execute with scoped model', () async {
      const initialModel = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          logName: 'INITIAL',
        ),
      );

      EngineHttpTracking.initWithModel(initialModel);

      expect(EngineHttpTracking.config?.logName, equals('INITIAL'));
    });

    test('should return correct stats', () {
      // First disable any existing tracking
      EngineHttpTracking.disable();

      const model = EngineHttpTrackingModel(
        enabled: true,
        httpTrackingConfig: EngineHttpTrackingConfig(
          logName: 'TEST_HTTP',
        ),
      );

      final stats = EngineHttpTracking.getStats();
      expect(stats['is_enabled'], isFalse);
      expect(stats['has_model'], isFalse);

      EngineHttpTracking.initWithModel(model);

      final enabledStats = EngineHttpTracking.getStats();
      expect(enabledStats['is_enabled'], isTrue);
      expect(enabledStats['has_model'], isTrue);
      expect(enabledStats['current_override'], contains('EngineHttpOverride'));
    });

    group('Model validation', () {
      test('should create development-like model', () {
        const model = EngineHttpTrackingModel(
          enabled: true,
          httpTrackingConfig: EngineHttpTrackingConfig(
            enableRequestLogging: true,
            enableResponseLogging: true,
            enableTimingLogging: true,
            enableHeaderLogging: true,
            enableBodyLogging: true,
            maxBodyLogLength: 2000,
            logName: 'HTTP_TRACKING_DEV',
          ),
        );

        expect(model.enabled, isTrue);
        expect(model.httpTrackingConfig.enableRequestLogging, isTrue);
        expect(model.httpTrackingConfig.enableResponseLogging, isTrue);
        expect(model.httpTrackingConfig.enableTimingLogging, isTrue);
        expect(model.httpTrackingConfig.enableHeaderLogging, isTrue);
        expect(model.httpTrackingConfig.enableBodyLogging, isTrue);
        expect(model.httpTrackingConfig.maxBodyLogLength, equals(2000));
        expect(model.httpTrackingConfig.logName, equals('HTTP_TRACKING_DEV'));
      });

      test('should create default disabled model', () {
        const model = EngineHttpTrackingModelDefault();

        expect(model.enabled, isFalse);
        expect(model.httpTrackingConfig.enableRequestLogging, isFalse);
        expect(model.httpTrackingConfig.enableResponseLogging, isFalse);
        expect(model.httpTrackingConfig.logName, equals('HTTP_TRACKING_DISABLED'));
      });
    });
  });
}
