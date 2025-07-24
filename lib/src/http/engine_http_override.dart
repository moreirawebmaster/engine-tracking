import 'dart:io';

import 'package:engine_tracking/src/http/engine_http_client.dart';

/// Custom HTTP override that logs HTTP requests using EngineLog.debug
///
/// This class extends HttpOverrides to intercept HTTP requests and log them
/// using the Engine Tracking logging system. It provides detailed logging
/// of request/response data including timing, status codes, and headers.
class EngineHttpOverride extends HttpOverrides {
  EngineHttpOverride({
    this.enableRequestLogging = true,
    this.enableResponseLogging = true,
    this.enableTimingLogging = true,
    this.enableHeaderLogging = false,
    this.enableBodyLogging = false,
    this.maxBodyLogLength = 1000,
    this.logName = 'HTTP_TRACKING',
    this.ignoreDomains = const ['grafana', 'datadog', 'crashlytics', 'analytics', 'firebase', 'clarity'],
    this.existingOverrides,
  });

  /// Whether to log HTTP requests
  final bool enableRequestLogging;

  /// Whether to log HTTP responses
  final bool enableResponseLogging;

  /// Whether to log request/response timing
  final bool enableTimingLogging;

  /// Whether to log request/response headers
  final bool enableHeaderLogging;

  /// Whether to log request/response body (be careful with sensitive data)
  final bool enableBodyLogging;

  /// Maximum length of body content to log
  final int maxBodyLogLength;

  /// Custom log name for HTTP tracking logs
  final String logName;

  /// Optional existing Overrides to chain with
  final HttpOverrides? existingOverrides;

  /// Ignore domain registered in list
  final List<String> ignoreDomains;

  @override
  HttpClient createHttpClient(final SecurityContext? context) {
    final client = existingOverrides?.createHttpClient(context) ?? super.createHttpClient(context);
    return EngineHttpClient(
      client,
      enableRequestLogging: enableRequestLogging,
      enableResponseLogging: enableResponseLogging,
      enableTimingLogging: enableTimingLogging,
      enableHeaderLogging: enableHeaderLogging,
      enableBodyLogging: enableBodyLogging,
      maxBodyLogLength: maxBodyLogLength,
      logName: logName,
      ignoreDomains: ignoreDomains,
    );
  }
}
