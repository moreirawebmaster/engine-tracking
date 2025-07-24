import 'dart:async';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:engine_tracking/src/http/engine_http_override.dart';

/// Utility class for managing Engine HTTP tracking
///
/// This class provides static methods to enable/disable HTTP tracking
/// and manage the global HttpOverrides configuration.
class EngineHttpTracking {
  static EngineHttpTrackingConfig? _config;
  static HttpOverrides? _previousOverride;
  static bool _isEnabled = false;

  /// Gets the current HTTP tracking configuration
  static EngineHttpTrackingConfig? get config => _config;

  /// Whether HTTP tracking is currently enabled
  static bool get isEnabled => _isEnabled;

  /// Initializes HTTP tracking with the given configuration
  ///
  /// This method sets up the global HttpOverrides to use EngineHttpOverride
  /// for logging HTTP requests and responses.
  ///
  /// [config] The configuration for HTTP tracking
  /// [preserveExisting] Whether to preserve existing HttpOverrides by chaining them
  static void initialize(final EngineHttpTrackingConfig config, {final bool preserveExisting = true}) {
    if (!config.enabled) {
      disable();
      return;
    }

    _config = config;

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
          'config': config.toString(),
          'has_base_override': baseOverride != null,
          'preserve_existing': preserveExisting,
        },
      ),
    );
  }

  /// Disables HTTP tracking
  ///
  /// This method removes the EngineHttpOverride and optionally restores
  /// the previous HttpOverrides configuration.
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
    _config = null;

    unawaited(EngineLog.info('HTTP tracking disabled', logName: 'ENGINE_HTTP_TRACKING'));
  }

  /// Updates the HTTP tracking configuration
  ///
  /// This method allows you to update the configuration without fully
  /// reinitializing the system.
  static void updateConfig(final EngineHttpTrackingConfig newConfig) {
    if (_config == null) {
      initialize(newConfig);
      return;
    }

    final preserveExisting = HttpOverrides.current != null;
    initialize(newConfig, preserveExisting: preserveExisting);
  }

  /// Creates a scoped HTTP tracking configuration
  ///
  /// This method temporarily applies a different configuration for the
  /// duration of the provided function execution.
  static Future<T> withConfig<T>(final EngineHttpTrackingConfig config, final Future<T> Function() operation) async {
    final previousConfig = _config;
    final wasEnabled = _isEnabled;

    try {
      initialize(config);
      return await operation();
    } finally {
      if (wasEnabled && previousConfig != null) {
        initialize(previousConfig);
      } else {
        disable();
      }
    }
  }

  /// Logs a custom HTTP-related event
  ///
  /// This method can be used to log custom HTTP-related events that
  /// are not automatically captured by the HttpOverride.
  static Future<void> logCustomEvent(
    final String message, {
    final Map<String, dynamic>? data,
    final String? logName,
  }) async {
    await EngineLog.debug(message, logName: logName ?? _config?.logName ?? 'HTTP_TRACKING', data: data);
  }

  /// Gets statistics about HTTP tracking
  static Map<String, dynamic> getStats() => {
    'is_enabled': _isEnabled,
    'has_config': _config != null,
    'config': _config?.toString(),
    'current_override': HttpOverrides.current?.runtimeType.toString(),
  };
}
