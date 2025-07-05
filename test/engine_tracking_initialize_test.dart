import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineTrackingInitialize', () {
    tearDown(() async {
      await EngineTrackingInitialize.dispose();
    });

    group('initWithAdapters', () {
      test('should initialize both analytics and bug tracking with adapters', () async {
        final analyticsAdapters = <IEngineAnalyticsAdapter>[
          EngineFirebaseAnalyticsAdapter(const EngineFirebaseAnalyticsConfig(enabled: false)),
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
        ];

        final bugTrackingAdapters = <IEngineBugTrackingAdapter>[
          EngineCrashlyticsAdapter(const EngineCrashlyticsConfig(enabled: false)),
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

        await EngineTrackingInitialize.initWithAdapters(
          analyticsAdapters: analyticsAdapters,
          bugTrackingAdapters: bugTrackingAdapters,
        );

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineTrackingInitialize.isInitialized, isTrue);
      });

      test('should initialize only analytics when bug tracking is null', () async {
        final analyticsAdapters = <IEngineAnalyticsAdapter>[
          EngineFirebaseAnalyticsAdapter(const EngineFirebaseAnalyticsConfig(enabled: false)),
        ];

        await EngineTrackingInitialize.initWithAdapters(
          analyticsAdapters: analyticsAdapters,
          bugTrackingAdapters: null,
        );

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isFalse);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should initialize only bug tracking when analytics is null', () async {
        final bugTrackingAdapters = <IEngineBugTrackingAdapter>[
          EngineCrashlyticsAdapter(const EngineCrashlyticsConfig(enabled: false)),
        ];

        await EngineTrackingInitialize.initWithAdapters(
          analyticsAdapters: null,
          bugTrackingAdapters: bugTrackingAdapters,
        );

        expect(EngineAnalytics.isInitialized, isFalse);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should handle null adapter lists', () async {
        await EngineTrackingInitialize.initWithAdapters(
          analyticsAdapters: null,
          bugTrackingAdapters: null,
        );

        expect(EngineAnalytics.isInitialized, isFalse);
        expect(EngineBugTracking.isInitialized, isFalse);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should handle empty adapter lists', () async {
        await EngineTrackingInitialize.initWithAdapters(
          analyticsAdapters: [],
          bugTrackingAdapters: [],
        );

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineAnalytics.isEnabled, isFalse);
        expect(EngineBugTracking.isEnabled, isFalse);
      });
    });

    group('initWithModels', () {
      test('should initialize both analytics and bug tracking with models', () async {
        final analyticsModel = EngineAnalyticsModel(
          clarityConfig: const EngineClarityConfig(enabled: false, projectId: ''),
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
          googleLoggingConfig: const EngineGoogleLoggingConfig(
            enabled: false,
            projectId: '',
            logName: '',
            credentials: {},
          ),
          splunkConfig: const EngineSplunkConfig(
            enabled: false,
            endpoint: '',
            token: '',
            source: '',
            sourcetype: '',
            index: '',
          ),
        );

        final bugTrackingModel = EngineBugTrackingModel(
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
          googleLoggingConfig: const EngineGoogleLoggingConfig(
            enabled: false,
            projectId: '',
            logName: '',
            credentials: {},
          ),
        );

        await EngineTrackingInitialize.initWithModels(
          analyticsModel: analyticsModel,
          bugTrackingModel: bugTrackingModel,
        );

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineTrackingInitialize.isInitialized, isTrue);
      });

      test('should initialize only analytics when bug tracking is null', () async {
        final analyticsModel = EngineAnalyticsModel(
          clarityConfig: const EngineClarityConfig(enabled: false, projectId: ''),
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
          googleLoggingConfig: const EngineGoogleLoggingConfig(
            enabled: false,
            projectId: '',
            logName: '',
            credentials: {},
          ),
          splunkConfig: const EngineSplunkConfig(
            enabled: false,
            endpoint: '',
            token: '',
            source: '',
            sourcetype: '',
            index: '',
          ),
        );

        await EngineTrackingInitialize.initWithModels(
          analyticsModel: analyticsModel,
          bugTrackingModel: null,
        );

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isFalse);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should initialize only bug tracking when analytics is null', () async {
        final bugTrackingModel = EngineBugTrackingModel(
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
          googleLoggingConfig: const EngineGoogleLoggingConfig(
            enabled: false,
            projectId: '',
            logName: '',
            credentials: {},
          ),
        );

        await EngineTrackingInitialize.initWithModels(
          analyticsModel: null,
          bugTrackingModel: bugTrackingModel,
        );

        expect(EngineAnalytics.isInitialized, isFalse);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should handle null models', () async {
        await EngineTrackingInitialize.initWithModels(
          analyticsModel: null,
          bugTrackingModel: null,
        );

        expect(EngineAnalytics.isInitialized, isFalse);
        expect(EngineBugTracking.isInitialized, isFalse);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });
    });

    group('initWithDefaults', () {
      test('should initialize both services with default models', () async {
        await EngineTrackingInitialize.initWithDefaults();

        expect(EngineAnalytics.isInitialized, isTrue);
        expect(EngineBugTracking.isInitialized, isTrue);
        expect(EngineTrackingInitialize.isInitialized, isTrue);
        expect(EngineAnalytics.isEnabled, isFalse);
        expect(EngineBugTracking.isEnabled, isFalse);
      });
    });

    group('dispose', () {
      test('should dispose both analytics and bug tracking', () async {
        await EngineTrackingInitialize.initWithDefaults();

        expect(EngineTrackingInitialize.isInitialized, isTrue);

        await EngineTrackingInitialize.dispose();

        expect(EngineAnalytics.isInitialized, isFalse);
        expect(EngineBugTracking.isInitialized, isFalse);
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });
    });

    group('isInitialized', () {
      test('should return true when both services are initialized', () async {
        await EngineTrackingInitialize.initWithDefaults();
        expect(EngineTrackingInitialize.isInitialized, isTrue);
      });

      test('should return false when services are not initialized', () {
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });

      test('should return false when only one service is initialized', () async {
        await EngineAnalytics.initWithModel(EngineAnalyticsModelDefault());
        expect(EngineTrackingInitialize.isInitialized, isFalse);
      });
    });

    group('isEnabled', () {
      test('should return true when at least one service is enabled', () async {
        final analyticsModel = EngineAnalyticsModel(
          clarityConfig: const EngineClarityConfig(enabled: false, projectId: ''),
          firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
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
          googleLoggingConfig: const EngineGoogleLoggingConfig(
            enabled: false,
            projectId: '',
            logName: '',
            credentials: {},
          ),
          splunkConfig: const EngineSplunkConfig(
            enabled: false,
            endpoint: '',
            token: '',
            source: '',
            sourcetype: '',
            index: '',
          ),
        );

        await EngineTrackingInitialize.initWithModels(
          analyticsModel: analyticsModel,
          bugTrackingModel: EngineBugTrackingModelDefault(),
        );

        expect(EngineTrackingInitialize.isEnabled, isTrue);
      });

      test('should return false when no services are enabled', () async {
        await EngineTrackingInitialize.initWithDefaults();
        expect(EngineTrackingInitialize.isEnabled, isFalse);
      });
    });
  });
}
