import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';

/// Main analytics service for the Engine Tracking library.
///
/// Provides a unified interface for analytics tracking across multiple services
/// including Firebase Analytics, Microsoft Clarity, Grafana Faro, Splunk, and Google Cloud Logging.
///
/// This class follows the singleton pattern and manages multiple analytics adapters
/// simultaneously, allowing you to track events to multiple services with a single call.
///
/// Example:
/// ```dart
/// // Initialize with specific adapters
/// await EngineAnalytics.init([
///   EngineFirebaseAnalyticsAdapter(firebaseConfig),
///   EngineClarityAdapter(clarityConfig),
/// ]);
///
/// // Or initialize with a model
/// await EngineAnalytics.initWithModel(analyticsModel);
///
/// // Track events
/// await EngineAnalytics.logEvent('button_clicked', {'button_id': 'submit'});
/// await EngineAnalytics.setUserId('user123', 'user@example.com', 'John Doe');
/// ```
class EngineAnalytics {
  EngineAnalytics._();

  static bool _isInitialized = false;

  /// Whether analytics tracking is enabled and has at least one adapter configured.
  static bool get isEnabled => _adapters.isNotEmpty;

  /// Whether the analytics service has been initialized.
  static bool get isInitialized => _isInitialized;

  /// Whether Microsoft Clarity analytics adapter is initialized and ready.
  static bool get isClarityInitialized => _isAdapterTypeInitialized<EngineClarityAdapter>();

  /// Whether Grafana Faro analytics adapter is initialized and ready.
  static bool get isFaroInitialized => _isAdapterTypeInitialized<EngineFaroAnalyticsAdapter>();

  /// Whether Firebase Analytics adapter is initialized and ready.
  static bool get isFirebaseInitialized => _isAdapterTypeInitialized<EngineFirebaseAnalyticsAdapter>();

  /// Whether Google Cloud Logging analytics adapter is initialized and ready.
  static bool get isGoogleLoggingInitialized => _isAdapterTypeInitialized<EngineGoogleLoggingAnalyticsAdapter>();

  /// Whether Splunk analytics adapter is initialized and ready.
  static bool get isSplunkInitialized => _isAdapterTypeInitialized<EngineSplunkAnalyticsAdapter>();

  static final _adapters = <IEngineAnalyticsAdapter>[];

  /// Checks if any adapter matches the given predicate and is initialized.
  ///
  /// [predicate] - Function to test each adapter.
  /// Returns true if any adapter matches the predicate and is initialized.
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

  /// Initializes the analytics service with the provided adapters.
  ///
  /// Only enabled adapters will be initialized. If the service is already
  /// initialized, this method will return immediately.
  ///
  /// [adapters] - List of analytics adapters to initialize.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.init([
  ///   EngineFirebaseAnalyticsAdapter(firebaseConfig),
  ///   EngineClarityAdapter(clarityConfig),
  /// ]);
  /// ```
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

  /// Initializes the analytics service using a configuration model.
  ///
  /// Creates adapters based on the provided model's configuration objects.
  /// Only configurations that are not null will be used to create adapters.
  ///
  /// [model] - Analytics configuration model containing various service configs.
  ///
  /// Example:
  /// ```dart
  /// final model = EngineAnalyticsModel(
  ///   firebaseAnalyticsConfig: firebaseConfig,
  ///   clarityConfig: clarityConfig,
  /// );
  /// await EngineAnalytics.initWithModel(model);
  /// ```
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

  /// Disposes of all analytics adapters and resets the service state.
  ///
  /// This method should be called when the analytics service is no longer needed,
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

  /// Resets all analytics adapters to their initial state.
  ///
  /// This method calls reset() on all initialized adapters, which may
  /// clear cached data or reset internal state depending on the adapter implementation.
  static Future<void> reset() async {
    final resets = _adapters.map((final adapter) => adapter.reset());
    await Future.wait(resets);
  }

  /// Logs a custom analytics event to all initialized adapters.
  ///
  /// [name] - The name of the event to log.
  /// [parameters] - Optional parameters to include with the event.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.logEvent('button_clicked', {
  ///   'button_id': 'submit',
  ///   'screen': 'login',
  /// });
  /// ```
  static Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final logEvents = _adapters.map((final adapter) => adapter.logEvent(name, parameters));
    await Future.wait(logEvents);
  }

  /// Sets the user ID and optional user information across all analytics adapters.
  ///
  /// [userId] - The unique identifier for the user.
  /// [email] - Optional email address of the user.
  /// [name] - Optional display name of the user.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.setUserId('user123', 'user@example.com', 'John Doe');
  /// ```
  static Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setUserIds = _adapters.map((final adapter) => adapter.setUserId(userId, email, name));
    await Future.wait(setUserIds);
  }

  /// Sets a user property across all analytics adapters.
  ///
  /// [name] - The name of the user property.
  /// [value] - The value to set for the property.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.setUserProperty('subscription_type', 'premium');
  /// await EngineAnalytics.setUserProperty('user_level', 'advanced');
  /// ```
  static Future<void> setUserProperty(final String name, final String? value) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final setUserProperties = _adapters.map((final adapter) => adapter.setUserProperty(name, value));
    await Future.wait(setUserProperties);
  }

  /// Sets the current page/screen across all analytics adapters.
  ///
  /// [screenName] - The name of the current screen/page.
  /// [previousScreen] - Optional name of the previous screen.
  /// [parameters] - Optional parameters to include with the page view.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.setPage('home_screen', 'login_screen', {
  ///   'source': 'deep_link',
  ///   'campaign': 'summer_sale',
  /// });
  /// ```
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

  /// Logs an app open event across all analytics adapters.
  ///
  /// [parameters] - Optional parameters to include with the app open event.
  ///
  /// Example:
  /// ```dart
  /// await EngineAnalytics.logAppOpen({
  ///   'source': 'notification',
  ///   'campaign_id': 'summer_2024',
  /// });
  /// ```
  static Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) {
      return;
    }

    final logAppOpens = _adapters.map((final adapter) => adapter.logAppOpen(parameters));
    await Future.wait(logAppOpens);
  }
}
