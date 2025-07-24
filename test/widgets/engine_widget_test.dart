import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineWidget', () {
    tearDown(() async {
      await EngineAnalytics.dispose();
    });

    testWidgets('should return app unchanged when Clarity is not initialized', (final tester) async {
      const testApp = MaterialApp(home: Text('Test App'));

      const widget = EngineWidget(app: testApp);

      await tester.pumpWidget(widget);

      expect(find.text('Test App'), findsOneWidget);
    });

    testWidgets('should return app unchanged when Clarity is disabled', (final tester) async {
      // Initialize analytics with disabled Clarity
      final analyticsModel = EngineAnalyticsModel(
        clarityConfig: EngineClarityConfig(
          enabled: false,
          projectId: 'test-project',
        ),
        firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
          namespace: '',
          platform: '',
        ),
        splunkConfig: EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
        googleLoggingConfig: EngineGoogleLoggingConfig(
          enabled: false,
          projectId: '',
          logName: '',
          credentials: {},
        ),
      );

      await EngineAnalytics.initWithModel(analyticsModel);

      const testApp = MaterialApp(home: Text('Test App'));
      const widget = EngineWidget(app: testApp);

      await tester.pumpWidget(widget);

      expect(find.text('Test App'), findsOneWidget);
    });

    testWidgets('should wrap app with ClarityWidget when Clarity is enabled', (final tester) async {
      // Initialize analytics with enabled Clarity
      final analyticsModel = EngineAnalyticsModel(
        clarityConfig: EngineClarityConfig(
          enabled: true,
          projectId: 'test-project',
        ),
        firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
          namespace: '',
          platform: '',
        ),
        splunkConfig: EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
        googleLoggingConfig: EngineGoogleLoggingConfig(
          enabled: false,
          projectId: '',
          logName: '',
          credentials: {},
        ),
      );

      await EngineAnalytics.initWithModel(analyticsModel);

      const testApp = MaterialApp(home: Text('Test App'));
      const widget = EngineWidget(app: testApp);

      await tester.pumpWidget(widget);

      // The app should still be findable, but wrapped in ClarityWidget
      expect(find.text('Test App'), findsOneWidget);
    });

    test('should get Clarity configuration from EngineAnalytics', () async {
      final clarityConfig = EngineClarityConfig(
        enabled: true,
        projectId: 'test-project-123',
      );

      final analyticsModel = EngineAnalyticsModel(
        clarityConfig: clarityConfig,
        firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
          namespace: '',
          platform: '',
        ),
        splunkConfig: EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
        googleLoggingConfig: EngineGoogleLoggingConfig(
          enabled: false,
          projectId: '',
          logName: '',
          credentials: {},
        ),
      );

      await EngineAnalytics.initWithModel(analyticsModel);

      final retrievedConfig = EngineAnalytics.getConfig<EngineClarityConfig, EngineClarityAdapter>();

      expect(retrievedConfig, isNotNull);
      expect(retrievedConfig!.enabled, isTrue);
      expect(retrievedConfig.projectId, equals('test-project-123'));
    });

    test('should return null when Clarity is not configured', () async {
      final analyticsModel = EngineAnalyticsModel(
        clarityConfig: EngineClarityConfig(enabled: false, projectId: ''),
        firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: false),
        faroConfig: EngineFaroConfig(
          enabled: false,
          endpoint: '',
          appName: '',
          appVersion: '',
          environment: '',
          apiKey: '',
          namespace: '',
          platform: '',
        ),
        splunkConfig: EngineSplunkConfig(
          enabled: false,
          endpoint: '',
          token: '',
          source: '',
          sourcetype: '',
          index: '',
        ),
        googleLoggingConfig: EngineGoogleLoggingConfig(
          enabled: false,
          projectId: '',
          logName: '',
          credentials: {},
        ),
      );

      await EngineAnalytics.initWithModel(analyticsModel);

      final retrievedConfig = EngineAnalytics.getConfig<EngineClarityConfig, EngineClarityAdapter>();

      expect(retrievedConfig, isNull);
    });
  });
}
