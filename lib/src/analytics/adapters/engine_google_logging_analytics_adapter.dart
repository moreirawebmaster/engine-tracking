import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/logging/v2.dart' as logging;
import 'package:googleapis_auth/auth_io.dart' as auth;

/// Google Cloud Logging analytics adapter for the Engine Tracking library.
///
/// Provides integration with Google Cloud Logging for analytics event tracking.
class EngineGoogleLoggingAnalyticsAdapter implements IEngineAnalyticsAdapter<EngineGoogleLoggingConfig> {
  /// Creates a new Google Cloud Logging analytics adapter.
  ///
  /// [config] - The Google Cloud Logging configuration.
  EngineGoogleLoggingAnalyticsAdapter(this.config);

  /// The Google Cloud Logging configuration.
  @override
  final EngineGoogleLoggingConfig config;

  /// The name of this adapter.
  @override
  String get adapterName => 'Google Cloud Logging Analytics';

  /// Whether this adapter is enabled.
  @override
  bool get isEnabled => config.enabled;

  /// Whether this adapter has been initialized.
  @override
  bool get isInitialized => _isInitialized;

  /// Whether Google Cloud Logging Analytics is initialized and ready.
  bool get isGoogleLoggingAnalyticsInitialized => isEnabled && _isInitialized;

  bool _isInitialized = false;

  String? _userId;

  late final logging.LoggingApi _loggingApi;
  late final auth.AuthClient _authClient;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      return;
    }

    _isInitialized = true;

    try {
      _authClient = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(config.credentials),
        [logging.LoggingApi.loggingWriteScope],
      );

      _loggingApi = logging.LoggingApi(_authClient);
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
        ..logName = 'projects/${config.projectId}/logs/${config.logName}-analytics'
        ..resource = logging.MonitoredResource.fromJson(
          config.resource ??
              {
                'type': 'global',
              },
        );

      final request = logging.WriteLogEntriesRequest()
        ..entries = [logEntry]
        ..logName = 'projects/${config.projectId}/logs/${config.logName}-analytics';

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
