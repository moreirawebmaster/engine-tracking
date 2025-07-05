import 'package:engine_tracking/src/bug_tracking/adapters/i_engine_bug_tracking_adapter.dart';
import 'package:engine_tracking/src/config/engine_google_logging_config.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart' as logging;
import 'package:googleapis_auth/auth_io.dart' as auth;

class EngineGoogleLoggingBugTrackingAdapter implements IEngineBugTrackingAdapter {
  EngineGoogleLoggingBugTrackingAdapter(this._config);

  bool _isInitialized = false;

  @override
  String get adapterName => 'Google Cloud Logging Bug Tracking';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isGoogleLoggingBugTrackingInitialized => isEnabled && _isInitialized;

  final EngineGoogleLoggingConfig _config;
  late final logging.LoggingApi _loggingApi;
  late final auth.AuthClient _authClient;
  final Map<String, Object> _customKeys = {};
  String? _userId;
  String? _userEmail;
  String? _userName;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      return;
    }

    try {
      _authClient = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(_config.credentials),
        [logging.LoggingApi.loggingWriteScope],
      );

      _loggingApi = logging.LoggingApi(_authClient);
      _isInitialized = true;
    } catch (e) {
      debugPrint('initialize: Error initializing Google Cloud Logging: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<void> dispose() async {
    _authClient.close();
    _customKeys.clear();
    _isInitialized = false;
  }

  @override
  Future<void> setCustomKey(final String key, final Object value) async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('setCustomKey: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      _customKeys[key] = value;
    } catch (e) {
      debugPrint('setCustomKey: Error setting custom key: $e');
    }
  }

  @override
  Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('setUserIdentifier: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      _userId = id;
      _userEmail = email;
      _userName = name;

      await log(
        'User identified',
        attributes: {
          'userId': id,
          'email': email,
          'name': name,
        },
      );
    } catch (e) {
      debugPrint('setUserIdentifier: Error setting user identifier: $e');
    }
  }

  @override
  Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  }) async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('log: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      final logEntry = logging.LogEntry()
        ..jsonPayload = {
          'eventType': 'bug_tracking',
          'message': message,
          'level': level ?? 'INFO',
          'attributes': attributes ?? {},
          'customKeys': _customKeys,
          'user': {
            'id': _userId,
            'email': _userEmail,
            'name': _userName,
          },
          'timestamp': DateTime.now().toIso8601String(),
          if (stackTrace != null) 'stackTrace': stackTrace.toString(),
        }
        ..severity = level?.toUpperCase()
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-bug-tracking'
        ..resource = logging.MonitoredResource.fromJson(
          _config.resource ??
              {
                'type': 'global',
              },
        );

      final request = logging.WriteLogEntriesRequest()
        ..entries = [logEntry]
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-bug-tracking';

      await _loggingApi.entries.write(request);
    } catch (e) {
      debugPrint('log: Error logging: $e');
    }
  }

  @override
  Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  }) async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('recordError: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      final logEntry = logging.LogEntry()
        ..jsonPayload = {
          'eventType': 'error',
          'exception': exception.toString(),
          'exceptionType': exception.runtimeType.toString(),
          'reason': reason,
          'isFatal': isFatal,
          'information': information.map((final e) => e.toString()).toList(),
          'data': data ?? {},
          'customKeys': _customKeys,
          'user': {
            'id': _userId,
            'email': _userEmail,
            'name': _userName,
          },
          'timestamp': DateTime.now().toIso8601String(),
          if (stackTrace != null) 'stackTrace': stackTrace.toString(),
        }
        ..severity = isFatal ? 'CRITICAL' : 'ERROR'
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-errors'
        ..resource = logging.MonitoredResource.fromJson(
          _config.resource ??
              {
                'type': 'global',
              },
        );

      final request = logging.WriteLogEntriesRequest()
        ..entries = [logEntry]
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-errors';

      await _loggingApi.entries.write(request);
    } catch (e) {
      debugPrint('recordError: Error recording error: $e');
    }
  }

  @override
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('recordFlutterError: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      await recordError(
        errorDetails.exception,
        errorDetails.stack,
        reason: errorDetails.context?.toDescription() ?? 'Flutter Error',
        information: [
          if (errorDetails.library != null) 'Library: ${errorDetails.library}',
          if (errorDetails.context != null) 'Context: ${errorDetails.context}',
          if (errorDetails.informationCollector != null) errorDetails.informationCollector!().join('\n'),
        ],
        isFatal: false,
        data: {
          'library': errorDetails.library,
          'silent': errorDetails.silent,
        },
      );
    } catch (e) {
      debugPrint('recordFlutterError: Error recording Flutter error: $e');
    }
  }

  @override
  Future<void> testCrash() async {
    if (!isGoogleLoggingBugTrackingInitialized) {
      debugPrint('testCrash: Google Cloud Logging Bug Tracking is not initialized');
      return;
    }

    try {
      await recordError(
        'Test crash triggered',
        StackTrace.current,
        reason: 'Manual test crash',
        isFatal: true,
        data: {'test': true},
      );
    } catch (e) {
      debugPrint('testCrash: Error in test crash: $e');
    }
  }
}
