import 'package:engine_tracking/src/config/engine_http_tracking_config.dart';

/// Model for HTTP tracking configuration in Engine Tracking.
///
/// Aggregates HTTP tracking service configuration and controls whether
/// HTTP tracking is enabled globally.
class EngineHttpTrackingModel {
  /// Creates a new HTTP tracking model.
  ///
  /// [enabled] Whether HTTP tracking is enabled globally
  /// [httpTrackingConfig] HTTP tracking configuration
  const EngineHttpTrackingModel({
    required this.enabled,
    required this.httpTrackingConfig,
  });

  /// Whether HTTP tracking is enabled globally
  final bool enabled;

  /// HTTP tracking configuration
  final EngineHttpTrackingConfig httpTrackingConfig;

  @override
  String toString() => 'EngineHttpTrackingModel(enabled: $enabled, httpTrackingConfig: $httpTrackingConfig)';
}

/// Default implementation of EngineHttpTrackingModel with HTTP tracking disabled.
class EngineHttpTrackingModelDefault implements EngineHttpTrackingModel {
  const EngineHttpTrackingModelDefault();

  @override
  bool get enabled => false;

  @override
  EngineHttpTrackingConfig get httpTrackingConfig => const EngineHttpTrackingConfig(
    enableRequestLogging: false,
    enableResponseLogging: false,
    enableTimingLogging: false,
    enableHeaderLogging: false,
    enableBodyLogging: false,
    maxBodyLogLength: 0,
    logName: 'HTTP_TRACKING_DISABLED',
  );
}
