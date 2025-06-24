import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';

class EngineAnalytics {
  EngineAnalytics._();

  static bool _isInitialized = false;

  static bool get isEnabled => _adapters.isNotEmpty;
  static bool get isInitialized => _isInitialized;
  static bool get isFaroInitialized =>
      isAdapterInitialized((final adapter) => adapter is EngineFaroAnalyticsAdapter && adapter.isInitialized);
  static bool get isFirebaseInitialized =>
      isAdapterInitialized((final adapter) => adapter is EngineFirebaseAnalyticsAdapter && adapter.isInitialized);
  static bool get isSplunkInitialized =>
      isAdapterInitialized((final adapter) => adapter is EngineSplunkAnalyticsAdapter && adapter.isInitialized);

  static final _adapters = <IEngineAnalyticsAdapter>[];

  static bool isAdapterInitialized(final PredicateAnalytics predicate) => _adapters.any(predicate);

  static Future<void> init(final List<IEngineAnalyticsAdapter> adapters) async {
    if (_isInitialized) {
      return;
    }

    _adapters
      ..clear()
      ..addAll(adapters.where((final adapter) => adapter.isEnabled));

    final futures = _adapters.map((final adapter) => adapter.initialize()).toList();

    await Future.wait(futures);

    _isInitialized = true;
  }

  static Future<void> initWithModel(final EngineAnalyticsModel model) async {
    final adapters = <IEngineAnalyticsAdapter>[
      EngineFirebaseAnalyticsAdapter(model.firebaseAnalyticsConfig),
      EngineFaroAnalyticsAdapter(model.faroConfig),
      EngineSplunkAnalyticsAdapter(model.splunkConfig),
    ];

    await init(adapters);
  }

  static Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.dispose(),
        )
        .toList();
    await Future.wait(futures);

    _adapters.clear();
    _isInitialized = false;
  }

  static Future<void> reset() async {
    final futures = _adapters.map((final adapter) => adapter.reset()).toList();
    await Future.wait(futures);
  }

  static Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.logEvent(name, parameters),
        )
        .toList();
    await Future.wait(futures);
  }

  static Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.setUserId(userId, email, name),
        )
        .toList();
    await Future.wait(futures);
  }

  static Future<void> setUserProperty(final String name, final String? value) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters.map((final adapter) => adapter.setUserProperty(name, value));
    await Future.wait(futures);
  }

  static Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.setPage(
            screenName,
            previousScreen,
            parameters,
          ),
        )
        .toList();
    await Future.wait(futures);
  }

  static Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters.map(
      (final adapter) => adapter.logAppOpen(parameters),
    );
    await Future.wait(futures);
  }
}
