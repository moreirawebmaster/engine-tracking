import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';

class EngineAnalytics {
  EngineAnalytics._();

  static bool _isInitialized = false;

  static bool get isEnabled => _adapters.isNotEmpty;
  static bool get isInitialized => _isInitialized;

  static bool get isClarityInitialized => _isAdapterTypeInitialized<EngineClarityAdapter>();
  static bool get isFaroInitialized => _isAdapterTypeInitialized<EngineFaroAnalyticsAdapter>();
  static bool get isFirebaseInitialized => _isAdapterTypeInitialized<EngineFirebaseAnalyticsAdapter>();
  static bool get isGoogleLoggingInitialized => _isAdapterTypeInitialized<EngineGoogleLoggingAnalyticsAdapter>();
  static bool get isSplunkInitialized => _isAdapterTypeInitialized<EngineSplunkAnalyticsAdapter>();

  static final _adapters = <IEngineAnalyticsAdapter>[];

  static bool isAdapterInitialized(final PredicateAnalytics predicate) => _adapters.any(predicate);

  static bool _isAdapterTypeInitialized<T extends IEngineAnalyticsAdapter>() =>
      _adapters.whereType<T>().any((final adapter) => adapter.isInitialized);

  /// Retrieves the configuration for a specific adapter type.
  ///
  /// Returns the configuration if an enabled adapter of type [TAdapter] is found,
  /// otherwise returns null.
  ///
  /// Example:
  /// ```dart
  /// final config = EngineAnalytics.getConfig<EngineFirebaseAnalyticsConfig, FirebaseAnalyticsAdapter>();
  /// ```
  static TConfig? getConfig<TConfig extends IEngineConfig, TAdapter extends IEngineAnalyticsAdapter>() {
    final enabledAdapter = _adapters.whereType<TAdapter>().where((final adapter) => adapter.isEnabled).firstOrNull;

    if (enabledAdapter?.config is TConfig) {
      return enabledAdapter!.config as TConfig;
    }

    return null;
  }

  static Future<void> init(final List<IEngineAnalyticsAdapter> adapters) async {
    if (_isInitialized) {
      return;
    }

    _adapters
      ..clear()
      ..addAll(adapters.where((final adapter) => adapter.isEnabled));

    final initializes = _adapters.map((final adapter) => adapter.initialize());
    await Future.wait(initializes);

    _isInitialized = true;
  }

  static Future<void> initWithModel(final EngineAnalyticsModel model) async {
    final adapters = <IEngineAnalyticsAdapter>[
      if (model.clarityConfig != null) EngineClarityAdapter(model.clarityConfig!),
      if (model.firebaseAnalyticsConfig != null) EngineFirebaseAnalyticsAdapter(model.firebaseAnalyticsConfig!),
      if (model.faroConfig != null) EngineFaroAnalyticsAdapter(model.faroConfig!),
      if (model.googleLoggingConfig != null) EngineGoogleLoggingAnalyticsAdapter(model.googleLoggingConfig!),
      if (model.splunkConfig != null) EngineSplunkAnalyticsAdapter(model.splunkConfig!),
    ];

    await init(adapters);
  }

  static Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    final disposes = _adapters.map((final adapter) => adapter.dispose());
    await Future.wait(disposes);

    _adapters.clear();
    _isInitialized = false;
  }

  static Future<void> reset() async {
    final resets = _adapters.map((final adapter) => adapter.reset());
    await Future.wait(resets);
  }

  static Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final logEvents = _adapters.map((final adapter) => adapter.logEvent(name, parameters));
    await Future.wait(logEvents);
  }

  static Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setUserIds = _adapters.map((final adapter) => adapter.setUserId(userId, email, name));
    await Future.wait(setUserIds);
  }

  static Future<void> setUserProperty(final String name, final String? value) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setUserProperties = _adapters.map((final adapter) => adapter.setUserProperty(name, value));
    await Future.wait(setUserProperties);
  }

  static Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setPages = _adapters.map((final adapter) => adapter.setPage(screenName, previousScreen, parameters));
    await Future.wait(setPages);
  }

  static Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final logAppOpens = _adapters.map((final adapter) => adapter.logAppOpen(parameters));
    await Future.wait(logAppOpens);
  }
}
