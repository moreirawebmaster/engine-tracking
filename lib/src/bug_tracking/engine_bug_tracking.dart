import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/foundation.dart';

/// Main bug tracking service for the Engine Tracking library.
///
/// Provides a unified interface for error tracking and crash reporting across multiple services
/// including Firebase Crashlytics, Grafana Faro, and Google Cloud Logging.
///
/// This class automatically captures Flutter errors and platform errors, and manages
/// multiple bug tracking adapters simultaneously.
///
/// Example:
/// ```dart
/// // Initialize with specific adapters
/// await EngineBugTracking.init([
///   EngineCrashlyticsAdapter(crashlyticsConfig),
///   EngineFaroBugTrackingAdapter(faroConfig),
/// ]);
///
/// // Or initialize with a model
/// await EngineBugTracking.initWithModel(bugTrackingModel);
///
/// // Set custom keys for better error context
/// await EngineBugTracking.setCustomKey('user_level', 'premium');
/// ```
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

  /// Whether bug tracking is enabled and has at least one adapter configured.
  static bool get isEnabled => _adapters.isNotEmpty;

  /// Whether the bug tracking service has been initialized.
  static bool get isInitialized => _isInitialized;

  static final _adapters = <IEngineBugTrackingAdapter>[];

  /// Whether Firebase Crashlytics adapter is initialized and ready.
  static bool get isCrashlyticsInitialized => _isAdapterTypeInitialized<EngineCrashlyticsAdapter>();

  /// Whether Grafana Faro bug tracking adapter is initialized and ready.
  static bool get isFaroInitialized => _isAdapterTypeInitialized<EngineFaroBugTrackingAdapter>();

  /// Whether Google Cloud Logging bug tracking adapter is initialized and ready.
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

  /// Initializes the bug tracking service with the provided adapters.
  ///
  /// Only enabled adapters will be initialized. If the service is already
  /// initialized, this method will return immediately.
  ///
  /// [adapters] - List of bug tracking adapters to initialize.
  ///
  /// Example:
  /// ```dart
  /// await EngineBugTracking.init([
  ///   EngineCrashlyticsAdapter(crashlyticsConfig),
  ///   EngineFaroBugTrackingAdapter(faroConfig),
  /// ]);
  /// ```
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

  /// Initializes the bug tracking service using a configuration model.
  ///
  /// Creates adapters based on the provided model's configuration objects.
  /// Only configurations that are not null will be used to create adapters.
  ///
  /// [model] - Bug tracking configuration model containing various service configs.
  ///
  /// Example:
  /// ```dart
  /// final model = EngineBugTrackingModel(
  ///   crashlyticsConfig: crashlyticsConfig,
  ///   faroConfig: faroConfig,
  /// );
  /// await EngineBugTracking.initWithModel(model);
  /// ```
  static Future<void> initWithModel(final EngineBugTrackingModel model) async {
    final adapters = <IEngineBugTrackingAdapter>[
      if (model.crashlyticsConfig != null) EngineCrashlyticsAdapter(model.crashlyticsConfig!),
      if (model.faroConfig != null) EngineFaroBugTrackingAdapter(model.faroConfig!),
      if (model.googleLoggingConfig != null) EngineGoogleLoggingBugTrackingAdapter(model.googleLoggingConfig!),
    ];

    await init(adapters);
  }

  /// Disposes of all bug tracking adapters and resets the service state.
  ///
  /// This method should be called when the bug tracking service is no longer needed,
  /// typically during app shutdown or when switching configurations.
  ///
  /// If the service is not initialized, this method will return immediately.
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
