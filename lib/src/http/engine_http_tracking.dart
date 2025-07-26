import 'dart:async';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:engine_tracking/src/http/engine_http_override.dart';

/// HTTP tracking service for the Engine Tracking library.
///
/// Provides comprehensive HTTP request and response tracking capabilities
/// by intercepting all HTTP requests through Flutter's HttpOverrides system.
///
/// This service can log request/response headers, bodies, timing information,
/// and other HTTP-related data for debugging and monitoring purposes.
///
/// Example:
/// ```dart
/// final config = EngineHttpTrackingConfig(
///   enabled: true,
///   enableRequestLogging: true,
///   enableResponseLogging: true,
///   enableTimingLogging: true,
/// );
///
/// EngineHttpTracking.initialize(config);
/// ```
class EngineHttpTracking {
  static EngineHttpTrackingModel? _model;
  static HttpOverrides? _previousOverride;
  static bool _isEnabled = false;

  /// Gets the current HTTP tracking model.
  ///
  /// Returns null if HTTP tracking has not been initialized.
  static EngineHttpTrackingModel? get model => _model;

  /// Gets the current HTTP tracking configuration.
  ///
  /// Returns null if HTTP tracking has not been initialized.
  static EngineHttpTrackingConfig? get config => _model?.httpTrackingConfig;

  /// Whether HTTP tracking is currently enabled and active.
  ///
  /// Returns true if HTTP tracking has been initialized and is actively
  /// intercepting HTTP requests.
  static bool get isEnabled => _isEnabled;

  /// Initializes HTTP tracking with the given model.
  ///
  /// This method sets up the global HttpOverrides to use EngineHttpOverride
  /// for logging HTTP requests and responses. If HTTP tracking is disabled
  /// in the model, this method will disable tracking instead.
  ///
  /// [model] - The HTTP tracking model containing configuration and enabled state.
  /// [preserveExisting] - Whether to preserve existing HttpOverrides by chaining them.
  ///                      If true, existing overrides will be called before Engine overrides.
  ///
  /// Example:
  /// ```dart
  /// final model = EngineHttpTrackingModel(
  ///   enabled: true,
  ///   httpTrackingConfig: EngineHttpTrackingConfig(
  ///     enableRequestLogging: true,
  ///     enableResponseLogging: true,
  ///     maxBodyLogLength: 1000,
  ///   ),
  /// );
  ///
  /// EngineHttpTracking.initWithModel(model);
  /// ```
  static void initWithModel(final EngineHttpTrackingModel model, {final bool preserveExisting = true}) {
    if (!model.enabled) {
      disable();
      return;
    }

    _model = model;
    final config = model.httpTrackingConfig;

    HttpOverrides? baseOverride = config.baseOverride;
    if (preserveExisting && baseOverride == null) {
      baseOverride = HttpOverrides.current;
    }

    final engineOverride = EngineHttpOverride(
      enableRequestLogging: config.enableRequestLogging,
      enableResponseLogging: config.enableResponseLogging,
      enableTimingLogging: config.enableTimingLogging,
      enableHeaderLogging: config.enableHeaderLogging,
      enableBodyLogging: config.enableBodyLogging,
      maxBodyLogLength: config.maxBodyLogLength,
      logName: config.logName,
      existingOverrides: baseOverride,
    );

    // Set the global override
    HttpOverrides.global = engineOverride;
    _isEnabled = true;

    unawaited(
      EngineLog.info(
        'HTTP tracking initialized',
        logName: 'ENGINE_HTTP_TRACKING',
        data: {
          'model': model.toString(),
          'has_base_override': baseOverride != null,
          'preserve_existing': preserveExisting,
        },
      ),
    );
  }

  /// Disables HTTP tracking and restores previous HttpOverrides.
  ///
  /// This method removes the EngineHttpOverride and restores the previous
  /// HttpOverrides configuration if one existed. If no previous override
  /// was found, it sets HttpOverrides.global to null.
  ///
  /// If HTTP tracking is not currently enabled, this method does nothing.
  static void disable() {
    if (!_isEnabled) return;

    // Restore previous override if it exists
    if (_previousOverride != null) {
      HttpOverrides.global = _previousOverride;
      _previousOverride = null;
    } else {
      HttpOverrides.global = null;
    }

    _isEnabled = false;
    _model = null;

    unawaited(EngineLog.info('HTTP tracking disabled', logName: 'ENGINE_HTTP_TRACKING'));
  }

  /// Updates the HTTP tracking model.
  ///
  /// This method allows you to update the model without fully
  /// reinitializing the system. If HTTP tracking has not been initialized,
  /// it will initialize with the new model.
  ///
  /// [newModel] - The new model to apply.
  static void updateModel(final EngineHttpTrackingModel newModel) {
    if (_model == null) {
      initWithModel(newModel);
      return;
    }

    final preserveExisting = HttpOverrides.current != null;
    initWithModel(newModel, preserveExisting: preserveExisting);
  }

  /// Logs a custom HTTP-related event
  ///
  /// This method can be used to log custom HTTP-related events that
  /// are not automatically captured by the HttpOverride.
  @Deprecated('Dont Use logCustomEvent it is removed in next version')
  static Future<void> logCustomEvent(
    final String message, {
    final Map<String, dynamic>? data,
    final String? logName,
  }) async {
    await EngineLog.debug(message, logName: logName ?? config?.logName ?? 'HTTP_TRACKING', data: data);
  }

  /// Initializes HTTP tracking with the given configuration (legacy method).
  ///
  /// This method is kept for backward compatibility. It creates a model
  /// with the configuration and enabled=true, then calls initWithModel.
  ///
  /// [config] - The configuration for HTTP tracking.
  /// [preserveExisting] - Whether to preserve existing HttpOverrides by chaining them.
  @Deprecated('Use initWithModel instead')
  static void initialize(final EngineHttpTrackingConfig config, {final bool preserveExisting = true}) {
    final model = EngineHttpTrackingModel(
      enabled: true,
      httpTrackingConfig: config,
    );
    initWithModel(model, preserveExisting: preserveExisting);
  }

  /// Gets statistics about HTTP tracking
  static Map<String, dynamic> getStats() => {
    'is_enabled': _isEnabled,
    'has_model': _model != null,
    'model': _model?.toString(),
    'current_override': HttpOverrides.current?.runtimeType.toString(),
  };
}
