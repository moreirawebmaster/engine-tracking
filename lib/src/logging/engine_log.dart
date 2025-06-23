import 'dart:async';
import 'dart:developer' as developer;

import 'package:engine_tracking/src/bug_tracking/engine_bug_tracking.dart';
import 'package:engine_tracking/src/enums/engine_log_level_type.dart';

/// Utility class for logging and crash reporting in the Engine framework.
///
/// This class provides methods for logging at different levels (debug, info, warning, error, fatal)
/// and integrates with Firebase Crashlytics for crash reporting or other logging services.
class EngineLog {
  /// The name used for all log messages
  static const String _name = 'ENGINE_LOG';

  static Future<void> _logWithLevel(
    final String message, {
    final String? logName,
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
      name: logName ?? _name,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      level: levelLog.value,
    );

    if (EngineBugTracking.isEnabled) {
      unawaited(EngineBugTracking.log(logMessage));

      if (levelLog == EngineLogLevelType.error || levelLog == EngineLogLevelType.fatal) {
        await EngineBugTracking.recordError(
          error ?? Exception(logMessage),
          stackTrace ?? StackTrace.current,
          isFatal: levelLog == EngineLogLevelType.fatal,
          reason: logMessage,
          data: data,
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
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
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
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
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
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
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
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
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
    final String? logName,
    final Object? error,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? data,
  }) async {
    await _logWithLevel(
      message,
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
    }
  }
}

/// Extension para formatar Map como string
extension MapFormattingExtension on Map<String, dynamic> {
  String toFormattedString() => entries.map((final entry) => '${entry.key}: ${entry.value}').join(', ');
}
