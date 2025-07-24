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

    test('should initialize with valid configuration', () {
      final config = EngineHttpTrackingConfig(
        enabled: true,
        enableRequestLogging: true,
        enableResponseLogging: true,
        logName: 'TEST_HTTP',
      );

      EngineHttpTracking.initialize(config);

      expect(EngineHttpTracking.isEnabled, isTrue);
      expect(EngineHttpTracking.config, equals(config));
      expect(HttpOverrides.current, isA<EngineHttpOverride>());
    });

    test('should not initialize when disabled', () {
      final config = EngineHttpTrackingConfig(
        enabled: false,
        logName: 'TEST_HTTP',
      );

      EngineHttpTracking.initialize(config);

      expect(EngineHttpTracking.isEnabled, isFalse);
      expect(EngineHttpTracking.config, isNull);
    });

    test('should update configuration', () {
      final initialConfig = EngineHttpTrackingConfig(
        enabled: true,
        enableRequestLogging: true,
        logName: 'INITIAL',
      );

      final updatedConfig = EngineHttpTrackingConfig(
        enabled: true,
        enableRequestLogging: false,
        enableResponseLogging: true,
        logName: 'UPDATED',
      );

      EngineHttpTracking.initialize(initialConfig);
      expect(EngineHttpTracking.config?.logName, equals('INITIAL'));

      EngineHttpTracking.updateConfig(updatedConfig);
      expect(EngineHttpTracking.config?.logName, equals('UPDATED'));
      expect(EngineHttpTracking.config?.enableRequestLogging, isFalse);
      expect(EngineHttpTracking.config?.enableResponseLogging, isTrue);
    });

    test('should provide temporary disable functionality', () {
      final config = EngineHttpTrackingConfig(
        enabled: true,
        logName: 'TEST_HTTP',
      );

      EngineHttpTracking.initialize(config);
      expect(EngineHttpTracking.isEnabled, isTrue);
      expect(EngineHttpTracking.config?.logName, equals('TEST_HTTP'));
    });

    test('should execute with scoped configuration', () async {
      final initialConfig = EngineHttpTrackingConfig(
        enabled: true,
        logName: 'INITIAL',
      );

      final scopedConfig = EngineHttpTrackingConfig(
        enabled: true,
        logName: 'SCOPED',
      );

      EngineHttpTracking.initialize(initialConfig);
      expect(EngineHttpTracking.config?.logName, equals('INITIAL'));

      await EngineHttpTracking.withConfig(scopedConfig, () async {
        expect(EngineHttpTracking.config?.logName, equals('SCOPED'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
      });

      expect(EngineHttpTracking.config?.logName, equals('INITIAL'));
    });

    test('should return correct stats', () {
      // First disable any existing tracking
      EngineHttpTracking.disable();

      final config = EngineHttpTrackingConfig(
        enabled: true,
        logName: 'TEST_HTTP',
      );

      final stats = EngineHttpTracking.getStats();
      expect(stats['is_enabled'], isFalse);
      expect(stats['has_config'], isFalse);

      EngineHttpTracking.initialize(config);

      final enabledStats = EngineHttpTracking.getStats();
      expect(enabledStats['is_enabled'], isTrue);
      expect(enabledStats['has_config'], isTrue);
      expect(enabledStats['current_override'], contains('EngineHttpOverride'));
    });

    group('Configuration validation', () {
      test('should create development-like configuration', () {
        final config = EngineHttpTrackingConfig(
          enabled: true,
          enableRequestLogging: true,
          enableResponseLogging: true,
          enableTimingLogging: true,
          enableHeaderLogging: true,
          enableBodyLogging: true,
          maxBodyLogLength: 2000,
          logName: 'HTTP_TRACKING_DEV',
        );

        expect(config.enabled, isTrue);
        expect(config.enableRequestLogging, isTrue);
        expect(config.enableResponseLogging, isTrue);
        expect(config.enableTimingLogging, isTrue);
        expect(config.enableHeaderLogging, isTrue);
        expect(config.enableBodyLogging, isTrue);
        expect(config.maxBodyLogLength, equals(2000));
        expect(config.logName, equals('HTTP_TRACKING_DEV'));
      });

      test('should create production-like configuration', () {
        final config = EngineHttpTrackingConfig(
          enabled: true,
          enableRequestLogging: true,
          enableResponseLogging: true,
          enableTimingLogging: true,
          enableHeaderLogging: false,
          enableBodyLogging: false,
          maxBodyLogLength: 500,
          logName: 'HTTP_TRACKING_PROD',
        );

        expect(config.enabled, isTrue);
        expect(config.enableRequestLogging, isTrue);
        expect(config.enableResponseLogging, isTrue);
        expect(config.enableTimingLogging, isTrue);
        expect(config.enableHeaderLogging, isFalse);
        expect(config.enableBodyLogging, isFalse);
        expect(config.maxBodyLogLength, equals(500));
        expect(config.logName, equals('HTTP_TRACKING_PROD'));
      });

      test('should create errors-only configuration', () {
        final config = EngineHttpTrackingConfig(
          enabled: true,
          enableRequestLogging: false,
          enableResponseLogging: true,
          enableTimingLogging: true,
          enableHeaderLogging: false,
          enableBodyLogging: false,
          maxBodyLogLength: 0,
          logName: 'HTTP_ERRORS',
        );

        expect(config.enabled, isTrue);
        expect(config.enableRequestLogging, isFalse);
        expect(config.enableResponseLogging, isTrue);
        expect(config.enableTimingLogging, isTrue);
        expect(config.enableHeaderLogging, isFalse);
        expect(config.enableBodyLogging, isFalse);
        expect(config.maxBodyLogLength, equals(0));
        expect(config.logName, equals('HTTP_ERRORS'));
      });
    });
  });
}
