import 'dart:io';

/// Configuration class for Engine HTTP tracking
///
/// This class defines the configuration options for HTTP request/response logging
/// using the EngineHttpOverride system.
class EngineHttpTrackingConfig {
  /// Creates a new HTTP tracking configuration
  ///
  /// [enableRequestLogging] Whether to log HTTP requests
  /// [enableResponseLogging] Whether to log HTTP responses
  /// [enableTimingLogging] Whether to log request/response timing
  /// [enableHeaderLogging] Whether to log request/response headers
  /// [enableBodyLogging] Whether to log request/response body
  /// [maxBodyLogLength] Maximum length of body content to log
  /// [logName] Custom log name for HTTP tracking logs
  /// [baseOverride] Optional base HttpOverrides to chain with
  const EngineHttpTrackingConfig({
    this.enableRequestLogging = true,
    this.enableResponseLogging = true,
    this.enableTimingLogging = true,
    this.enableHeaderLogging = false,
    this.enableBodyLogging = false,
    this.maxBodyLogLength = 1000,
    this.logName = 'HTTP_TRACKING',
    this.baseOverride,
  });

  /// Whether to log HTTP requests
  final bool enableRequestLogging;

  /// Whether to log HTTP responses
  final bool enableResponseLogging;

  /// Whether to log request/response timing
  final bool enableTimingLogging;

  /// Whether to log request/response headers (be careful with sensitive data)
  final bool enableHeaderLogging;

  /// Whether to log request/response body (be careful with sensitive data)
  final bool enableBodyLogging;

  /// Maximum length of body content to log
  final int maxBodyLogLength;

  /// Custom log name for HTTP tracking logs
  final String logName;

  /// Optional base HttpOverrides to chain with (e.g., FaroHttpOverrides)
  final HttpOverrides? baseOverride;

  @override
  String toString() =>
      'EngineHttpTrackingConfig(enableRequestLogging: $enableRequestLogging, '
      'enableResponseLogging: $enableResponseLogging, enableTimingLogging: $enableTimingLogging, '
      'enableHeaderLogging: $enableHeaderLogging, enableBodyLogging: $enableBodyLogging, '
      'maxBodyLogLength: $maxBodyLogLength, logName: $logName)';
}
