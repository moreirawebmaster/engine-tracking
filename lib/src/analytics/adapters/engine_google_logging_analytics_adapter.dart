import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/logging/v2.dart' as logging;
import 'package:googleapis_auth/auth_io.dart' as auth;

class EngineGoogleLoggingAnalyticsAdapter implements IEngineAnalyticsAdapter {
  EngineGoogleLoggingAnalyticsAdapter(this._config);

  bool _isInitialized = false;

  @override
  String get adapterName => 'Google Cloud Logging Analytics';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isGoogleLoggingAnalyticsInitialized => isEnabled && _isInitialized;

  final EngineGoogleLoggingConfig _config;
  late final logging.LoggingApi _loggingApi;
  late final auth.AuthClient _authClient;
  String? _userId;

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
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isGoogleLoggingAnalyticsInitialized) {
      debugPrint('logEvent: Google Cloud Logging Analytics is not initialized');
      return;
    }

    try {
      final enrichedParameters = EngineSession.instance.enrichWithSessionId(parameters);

      final logEntry = logging.LogEntry()
        ..jsonPayload = {
          'eventType': 'analytics',
          'eventName': name,
          'parameters': enrichedParameters ?? {},
          'userId': _userId,
          'timestamp': DateTime.now().toIso8601String(),
        }
        ..severity = 'INFO'
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-analytics'
        ..resource = logging.MonitoredResource.fromJson(
          _config.resource ??
              {
                'type': 'global',
              },
        );

      final request = logging.WriteLogEntriesRequest()
        ..entries = [logEntry]
        ..logName = 'projects/${_config.projectId}/logs/${_config.logName}-analytics';

      await _loggingApi.entries.write(request);
    } catch (e) {
      debugPrint('logEvent: Error logging event: $e');
    }
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isGoogleLoggingAnalyticsInitialized) {
      debugPrint('setUserId: Google Cloud Logging Analytics is not initialized');
      return;
    }

    try {
      _userId = userId;
      await logEvent('user_identification', {
        'userId': userId,
        'email': email,
        'name': name,
      });
    } catch (e) {
      debugPrint('setUserId: Error setting user id: $e');
    }
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    if (!isGoogleLoggingAnalyticsInitialized) {
      debugPrint('setUserProperty: Google Cloud Logging Analytics is not initialized');
      return;
    }

    try {
      await logEvent('user_property_set', {
        'propertyName': name,
        'propertyValue': value,
      });
    } catch (e) {
      debugPrint('setUserProperty: Error setting user property: $e');
    }
  }

  @override
  Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isGoogleLoggingAnalyticsInitialized) {
      debugPrint('setPage: Google Cloud Logging Analytics is not initialized');
      return;
    }

    try {
      await logEvent('screen_view', {
        'screenName': screenName,
        'previousScreen': previousScreen,
        'screenClass': parameters?['screen_class'] ?? 'Flutter',
        ...?parameters,
      });
    } catch (e) {
      debugPrint('setPage: Error setting page: $e');
    }
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isGoogleLoggingAnalyticsInitialized) {
      debugPrint('logAppOpen: Google Cloud Logging Analytics is not initialized');
      return;
    }

    try {
      await logEvent('app_open', parameters);
    } catch (e) {
      debugPrint('logAppOpen: Error logging app open: $e');
    }
  }

  @override
  Future<void> reset() async {}
}
