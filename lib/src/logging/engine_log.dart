import 'dart:async';
import 'dart:developer' as developer;

import 'package:engine_tracking/engine_tracking.dart';

/// Utility class for logging and crash reporting in the Engine framework.
///
/// This class provides methods for logging at different levels (debug, info, warning, error, fatal)
/// and integrates with Firebase Crashlytics for crash reporting or other logging services.
class EngineLog {
  /// The name used for all log messages
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

    final logMessage = '$prefix $message $dataString';

    developer.log(
      logMessage,
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
      'time': DateTime.now(),
    };

    final attributes = EngineSession.instance.enrichWithSessionId(baseAttributes);

    if (EngineAnalytics.isEnabled && includeInAnalytics) {
      await EngineAnalytics.logEvent(
        message,
        attributes,
      );
    }

    if (EngineBugTracking.isEnabled) {
      unawaited(
        EngineBugTracking.log(
          message,
          attributes: attributes,
          level: levelLog.name,
          stackTrace: stackTrace,
        ),
      );

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

  /// Log debug level message
  ///
  /// [message] The message to log
  /// [logName] Optional custom log name
  /// [error] Optional error object
  /// [stackTrace] Optional stack trace
  /// [data] Optional additional data to include with the log
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

  /// Log info level message
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

  /// Log warning level message
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

  /// Log error level message
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

  /// Log fatal level message
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
