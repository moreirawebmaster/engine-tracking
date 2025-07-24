import 'dart:async';
import 'dart:developer' as developer;

import 'package:engine_tracking/engine_tracking.dart';

/// Centralized logging service for the Engine Tracking library.
///
/// Provides comprehensive logging capabilities with multiple levels (debug, info, warning, error, fatal)
/// and automatic integration with analytics and bug tracking services.
///
/// This service automatically enriches log messages with session information and can
/// send logs to both analytics and bug tracking services when they are initialized.
///
/// Example:
/// ```dart
/// // Basic logging
/// await EngineLog.info('User logged in successfully');
/// await EngineLog.error('Failed to load user data', error: exception);
///
/// // Logging with additional data
/// await EngineLog.debug('API request completed', data: {
///   'endpoint': '/api/users',
///   'duration_ms': 150,
///   'status_code': 200,
/// });
/// ```
class EngineLog {
  static const String _name = 'ENGINE_LOG';

  static Future<void> _logWithLevel(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final EngineLogLevelType? level,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    final levelLog = level ?? EngineLogLevelType.info;
    final prefix = _getLevelPrefix(levelLog);
    final dataString = data == null ? '' : '- [Data]: ${data.toString()}';
    final time = DateTime.now().toIso8601String();

    final logMessage = '$prefix $message';

    developer.log(
      logMessage + dataString,
      name: logName,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      level: levelLog.value,
    );

    final baseAttributes = {
      'message': logMessage,
      'tag': logName,
      'level': levelLog.name,
      if (data != null) ...data,
      'time': time,
    };

    final attributes = EngineSession.instance.enrichWithSessionId(baseAttributes);

    if (EngineAnalytics.isEnabled && includeInAnalytics) {
      await EngineAnalytics.logEvent(message, attributes);
    }

    if (EngineBugTracking.isEnabled) {
      unawaited(EngineBugTracking.log(message, attributes: attributes, level: levelLog.name, stackTrace: stackTrace));

      if (levelLog == EngineLogLevelType.error || levelLog == EngineLogLevelType.fatal) {
        await EngineBugTracking.recordError(
          error ?? Exception(logMessage),
          stackTrace ?? StackTrace.current,
          isFatal: levelLog == EngineLogLevelType.fatal,
          reason: message,
          data: attributes,
        );
      }
    }
  }

  /// Logs a debug level message.
  ///
  /// Debug messages are typically used for detailed diagnostic information
  /// that is only useful during development and debugging.
  ///
  /// [message] - The message to log.
  /// [includeInAnalytics] - Whether to include this log in analytics events.
  /// [logName] - Optional custom log name for categorization.
  /// [error] - Optional error object to include with the log.
  /// [stackTrace] - Optional stack trace to include with the log.
  /// [data] - Optional additional data to include with the log.
  static Future<void> debug(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
      includeInAnalytics: includeInAnalytics,
      logName: logName,
      level: EngineLogLevelType.debug,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Logs an info level message.
  ///
  /// Info messages are used for general information about application flow
  /// and important events that are not errors or warnings.
  ///
  /// [message] - The message to log.
  /// [includeInAnalytics] - Whether to include this log in analytics events.
  /// [logName] - Optional custom log name for categorization.
  /// [error] - Optional error object to include with the log.
  /// [stackTrace] - Optional stack trace to include with the log.
  /// [data] - Optional additional data to include with the log.
  static Future<void> info(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
      includeInAnalytics: includeInAnalytics,
      logName: logName,
      level: EngineLogLevelType.info,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Logs a warning level message.
  ///
  /// Warning messages indicate potential issues or unexpected conditions
  /// that are not errors but should be monitored.
  ///
  /// [message] - The message to log.
  /// [includeInAnalytics] - Whether to include this log in analytics events.
  /// [logName] - Optional custom log name for categorization.
  /// [error] - Optional error object to include with the log.
  /// [stackTrace] - Optional stack trace to include with the log.
  /// [data] - Optional additional data to include with the log.
  static Future<void> warning(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
      includeInAnalytics: includeInAnalytics,
      logName: logName,
      level: EngineLogLevelType.warning,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Logs an error level message.
  ///
  /// Error messages indicate that something went wrong but the application
  /// can continue running. These are automatically sent to bug tracking services.
  ///
  /// [message] - The message to log.
  /// [includeInAnalytics] - Whether to include this log in analytics events.
  /// [logName] - Optional custom log name for categorization.
  /// [error] - Optional error object to include with the log.
  /// [stackTrace] - Optional stack trace to include with the log.
  /// [data] - Optional additional data to include with the log.
  static Future<void> error(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
      includeInAnalytics: includeInAnalytics,
      logName: logName,
      level: EngineLogLevelType.error,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Logs a fatal level message.
  ///
  /// Fatal messages indicate critical errors that may cause the application
  /// to crash or become unusable. These are automatically sent to bug tracking
  /// services as fatal errors.
  ///
  /// [message] - The message to log.
  /// [includeInAnalytics] - Whether to include this log in analytics events.
  /// [logName] - Optional custom log name for categorization.
  /// [error] - Optional error object to include with the log.
  /// [stackTrace] - Optional stack trace to include with the log.
  /// [data] - Optional additional data to include with the log.
  static Future<void> fatal(
    final String message, {
    final bool includeInAnalytics = true,
    final String logName = _name,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
      includeInAnalytics: includeInAnalytics,
      logName: logName,
      level: EngineLogLevelType.fatal,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  static String _getLevelPrefix(final EngineLogLevelType level) {
    switch (level) {
      case EngineLogLevelType.debug:
        return '[DEBUG]';
      case EngineLogLevelType.info:
        return '[INFO]';
      case EngineLogLevelType.warning:
        return '[WARNING]';
      case EngineLogLevelType.error:
        return '[ERROR]';
      case EngineLogLevelType.fatal:
        return '[FATAL]';
      case EngineLogLevelType.none:
        return '';
      case EngineLogLevelType.verbose:
        return '[VERBOSE]';
    }
  }
}
