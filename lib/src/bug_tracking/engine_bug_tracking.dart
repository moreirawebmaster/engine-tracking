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

  static bool isAdapterInitialized(final PredicateBugTracking predicate) => _adapters.any(predicate);

  static bool get isCrashlyticsInitialized =>
      isAdapterInitialized((final adapter) => adapter is EngineCrashlyticsAdapter && adapter.isInitialized);
  static bool get isFaroInitialized =>
      isAdapterInitialized((final adapter) => adapter is EngineFaroBugTrackingAdapter && adapter.isInitialized);

  static Future<void> init(final List<IEngineBugTrackingAdapter> adapters) async {
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

  static Future<void> initWithModel(final EngineBugTrackingModel model) async {
    final adapters = <IEngineBugTrackingAdapter>[
      EngineCrashlyticsAdapter(model.crashlyticsConfig),
      EngineFaroBugTrackingAdapter(model.faroConfig),
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

  static void reset() {
    _adapters.clear();
    _isInitialized = false;
  }

  static Future<void> setCustomKey(final String key, final Object value) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.setCustomKey(key, value),
        )
        .toList();
    await Future.wait(futures);
  }

  static Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.setUserIdentifier(id, email, name),
        )
        .toList();
    await Future.wait(futures);
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

    final futures = _adapters
        .map(
          (final adapter) => adapter.log(
            message,
            level: level,
            attributes: attributes,
            stackTrace: stackTrace,
          ),
        )
        .toList();
    await Future.wait(futures);
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

    final futures = _adapters
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
    await Future.wait(futures);
  }

  static Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final futures = _adapters
        .map(
          (final adapter) => adapter.recordFlutterError(errorDetails),
        )
        .toList();
    await Future.wait(futures);
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

  @Deprecated('Use individual adapter checks instead')
  static bool get isCrashlyticsEnabled =>
      _adapters.any((final adapter) => adapter is EngineCrashlyticsAdapter && adapter.isEnabled);

  @Deprecated('Use individual adapter checks instead')
  static bool get isFaroEnabled =>
      _adapters.any((final adapter) => adapter is EngineFaroBugTrackingAdapter && adapter.isEnabled);
}
