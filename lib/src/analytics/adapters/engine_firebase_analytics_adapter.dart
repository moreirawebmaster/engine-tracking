import 'package:engine_tracking/src/analytics/adapters/i_engine_analytics_adapter.dart';
import 'package:engine_tracking/src/config/engine_firebase_analytics_config.dart';
import 'package:engine_tracking/src/session/engine_session.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class EngineFirebaseAnalyticsAdapter implements IEngineAnalyticsAdapter {
  bool _isInitialized = false;

  EngineFirebaseAnalyticsAdapter(this._config);

  @override
  String get adapterName => 'Firebase Analytics';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isFirebaseAnalyticsInitialized => isEnabled && _isInitialized && _firebaseAnalytics != null;

  final EngineFirebaseAnalyticsConfig _config;
  FirebaseAnalytics? _firebaseAnalytics;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      return;
    }

    try {
      _firebaseAnalytics = FirebaseAnalytics.instance;
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  @override
  Future<void> dispose() async {
    _firebaseAnalytics = null;
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('logEvent: Firebase Analytics is not initialized');
      return;
    }

    try {
      final enrichedParameters = EngineSession.instance.enrichWithSessionId(parameters);

      await _firebaseAnalytics?.logEvent(
        name: name,
        parameters: enrichedParameters?.map(
          (final k, final v) => MapEntry(k, v as Object),
        ),
      );
    } catch (e) {
      debugPrint('logEvent: Error logging event: $e');
    }
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('setUserId: Firebase Analytics is not initialized');
      return;
    }

    try {
      await _firebaseAnalytics?.setUserId(id: userId);
    } catch (e) {
      debugPrint('setUserId: Error setting user id: $e');
    }
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('setUserProperty: Firebase Analytics is not initialized');
      return;
    }

    try {
      await _firebaseAnalytics?.setUserProperty(name: name, value: value);
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
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('setPage: Firebase Analytics is not initialized');
      return;
    }

    try {
      final enrichedParameters = EngineSession.instance.enrichWithSessionId(parameters);

      await _firebaseAnalytics?.logScreenView(
        screenName: screenName,
        screenClass: enrichedParameters?['screen_class']?.toString() ?? 'Flutter',
        parameters: enrichedParameters?.map(
          (final k, final v) => MapEntry(k, v as Object),
        ),
      );
    } catch (e) {
      debugPrint('setPage: Error setting page: $e');
    }
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('logAppOpen: Firebase Analytics is not initialized');
      return;
    }

    try {
      final enrichedParameters = EngineSession.instance.enrichWithSessionId(parameters);

      await _firebaseAnalytics?.logEvent(
        name: 'app_open',
        parameters: enrichedParameters?.map(
          (final k, final v) => MapEntry(k, v as Object),
        ),
      );
    } catch (e) {
      debugPrint('logAppOpen: Error logging app open: $e');
    }
  }

  @override
  Future<void> reset() async {
    if (!isFirebaseAnalyticsInitialized) {
      debugPrint('reset: Firebase Analytics is not initialized');
      return;
    }

    try {
      await _firebaseAnalytics?.resetAnalyticsData();
    } catch (e) {
      debugPrint('reset: Error resetting: $e');
    }
  }
}
