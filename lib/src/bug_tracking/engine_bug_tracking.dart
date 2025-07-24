import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/foundation.dart';

class EngineBugTracking {
  EngineBugTracking._() {
    FlutterError.onError = (final details) async {
      await recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (final error, final stack) {
      unawaited(recordError(error, stack));
      return true;
    };
  }

  static bool _isInitialized = false;

  static bool get isEnabled => _adapters.isNotEmpty;
  static bool get isInitialized => _isInitialized;

  static final _adapters = <IEngineBugTrackingAdapter>[];

  static bool get isCrashlyticsInitialized => _isAdapterTypeInitialized<EngineCrashlyticsAdapter>();
  static bool get isFaroInitialized => _isAdapterTypeInitialized<EngineFaroBugTrackingAdapter>();
  static bool get isGoogleLoggingInitialized => _isAdapterTypeInitialized<EngineGoogleLoggingBugTrackingAdapter>();

  static bool _isAdapterTypeInitialized<T extends IEngineBugTrackingAdapter>() =>
      _adapters.whereType<T>().any((final adapter) => adapter.isInitialized);

  /// Retrieves the configuration for a specific adapter type.
  ///
  /// Returns the configuration if an enabled adapter of type [TAdapter] is found,
  /// otherwise returns null.
  ///
  /// Example:
  /// ```dart
  /// final config = EngineAnalytics.getConfig<EngineFirebaseAnalyticsConfig, EngineCrashlyticsAdapter>();
  /// ```
  static TConfig? getConfig<TConfig extends IEngineConfig, TAdapter extends IEngineBugTrackingAdapter>() {
    final enabledAdapter = _adapters.whereType<TAdapter>().where((final adapter) => adapter.isEnabled).firstOrNull;

    if (enabledAdapter?.config is TConfig) {
      return enabledAdapter!.config as TConfig;
    }

    return null;
  }

  static Future<void> init(final List<IEngineBugTrackingAdapter> adapters) async {
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

  static Future<void> initWithModel(final EngineBugTrackingModel model) async {
    final adapters = <IEngineBugTrackingAdapter>[
      if (model.crashlyticsConfig != null) EngineCrashlyticsAdapter(model.crashlyticsConfig!),
      if (model.faroConfig != null) EngineFaroBugTrackingAdapter(model.faroConfig!),
      if (model.googleLoggingConfig != null) EngineGoogleLoggingBugTrackingAdapter(model.googleLoggingConfig!),
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

  static void reset() {
    _adapters.clear();
    _isInitialized = false;
  }

  static Future<void> setCustomKey(final String key, final Object value) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setCustomKeys = _adapters.map((final adapter) => adapter.setCustomKey(key, value));
    await Future.wait(setCustomKeys);
  }

  static Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setUserIdentifiers = _adapters.map((final adapter) => adapter.setUserIdentifier(id, email, name));
    await Future.wait(setUserIdentifiers);
  }

  static Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  }) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final logs = _adapters.map(
      (final adapter) => adapter.log(
        message,
        level: level,
        attributes: attributes,
        stackTrace: stackTrace,
      ),
    );
    await Future.wait(logs);
  }

  static Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  }) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final errors = _adapters
        .map(
          (final adapter) => adapter.recordError(
            exception,
            stackTrace,
            reason: reason,
            information: information,
            isFatal: isFatal,
            data: data,
          ),
        )
        .toList();
    await Future.wait(errors);
  }

  static Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final erros = _adapters
        .map(
          (final adapter) => adapter.recordFlutterError(errorDetails),
        )
        .toList();
    await Future.wait(erros);
  }

  static Future<void> testCrash() async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters.map(
      (final adapter) => adapter.testCrash(),
    );
    await Future.wait(futures);
  }
}
