import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

Future<void> initializeAnalyticsExample() async {
  final firebaseConfig = EngineFirebaseAnalyticsConfig(enabled: true);
  final faroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect/d447b8aa9e6c8fdae9cf8c28701ede4e',
    appName: 'stmr',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'd447b8aa9e6c8fdae9cf8c28701ede4e',
    namespace: 'analytics',
    platform: 'flutter',
  );

  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: firebaseConfig,
    faroConfig: faroConfig,
    splunkConfig: EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
    clarityConfig: EngineClarityConfig(enabled: false, projectId: ''),
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
}

Future<void> initializeAnalyticsWithMultipleAdapters() async {
  final firebaseAdapter = EngineFirebaseAnalyticsAdapter(EngineFirebaseAnalyticsConfig(enabled: true));
  final faroAdapter = EngineFaroAnalyticsAdapter(
    EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect/d447b8aa9e6c8fdae9cf8c28701ede4e',
      appName: 'stmr',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'd447b8aa9e6c8fdae9cf8c28701ede4e',
      namespace: 'analytics',
      platform: 'flutter',
    ),
  );

  await EngineAnalytics.init([firebaseAdapter, faroAdapter]);
}

Future<void> initializeAnalyticsWithTraditionalModel() async {
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: true),
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
    clarityConfig: EngineClarityConfig(enabled: false, projectId: ''),
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
}

Future<void> demonstrateAnalyticsUsage() async {
  await EngineAnalytics.setUserId('user123', 'user@example.com', 'John Doe');

  await EngineAnalytics.logEvent('button_clicked', {
    'button_name': 'test_button',
    'screen': 'home',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  });

  await EngineAnalytics.setUserProperty('user_level', 'premium');
  await EngineAnalytics.setUserProperty('subscription_type', 'monthly');

  await EngineAnalytics.logEvent('screen_view', {
    'screen_name': 'HomePage',
    'screen_class': 'HomePage',
  });

  await EngineAnalytics.logAppOpen();

  await EngineAnalytics.logEvent('purchase', {
    'currency': 'USD',
    'value': 29.99,
    'items': [
      {'item_id': 'premium_subscription', 'item_name': 'Premium Subscription'},
    ],
  });
}

class CustomAnalyticsAdapter implements IEngineAnalyticsAdapter {
  bool _isInitialized = false;

  @override
  String get adapterName => 'Custom Analytics';

  @override
  bool get isEnabled => true;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<void> reset() async {}

  @override
  Future<void> logEvent(final String eventName, [final Map<String, dynamic>? parameters]) async {
    debugPrint('Custom Analytics: $eventName with $parameters');
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    debugPrint('Custom Analytics: Set user $userId ($email)');
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    debugPrint('Custom Analytics: Set property $name = $value');
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    debugPrint('Custom Analytics: App opened');
  }

  @override
  Future<void> setPage(
    final String pageName, [
    final String? previousPageName,
    final Map<String, dynamic>? parameters,
  ]) async {
    debugPrint('Custom Analytics: Page $pageName (from $previousPageName)');
  }

  @override
  IEngineConfig get config => throw UnimplementedError();
}
