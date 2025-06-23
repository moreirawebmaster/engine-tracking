import 'package:engine_tracking/src/analytics/adapters/i_engine_analytics_adapter.dart';
import 'package:engine_tracking/src/config/engine_faro_config.dart';
import 'package:faro/faro_sdk.dart';
import 'package:flutter/widgets.dart';

class EngineFaroAnalyticsAdapter implements IEngineAnalyticsAdapter {
  final EngineFaroConfig _config;
  bool _isInitialized = false;

  EngineFaroAnalyticsAdapter(this._config);

  @override
  String get adapterName => 'Grafana Faro';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isFaroInitialized => isEnabled && _isInitialized && _faro != null;

  Faro? _faro;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      debugPrint('Faro is not enabled or already initialized');
      return;
    }

    try {
      _faro = Faro();
      if (_config.enabled) {
        await _faro?.init(
          optionsConfiguration: FaroConfig(
            apiKey: _config.apiKey,
            appName: _config.appName,
            appVersion: _config.appVersion,
            appEnv: _config.environment,
            collectorUrl: _config.endpoint,
            enableCrashReporting: false,
            anrTracking: false,
          ),
        );
      }
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isFaroInitialized) {
      debugPrint('logEvent: Faro is not initialized');
      return;
    }

    try {
      await _faro!.pushEvent(name, attributes: parameters);
    } catch (e) {
      debugPrint('logEvent: Error logging event: $e');
    }
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isFaroInitialized) {
      debugPrint('setUserId: Faro is not initialized');
      return;
    }

    if (userId == null || userId == '0' || userId.isEmpty) {
      return;
    }

    try {
      _faro!.setUserMeta(userId: userId, userEmail: email, userName: name);
    } catch (e) {
      debugPrint('setUserId: Error setting user id: $e');
    }
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    if (!isFaroInitialized) {
      debugPrint('setUserProperty: Faro is not initialized');
      return;
    }
  }

  @override
  Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isFaroInitialized) {
      debugPrint('setUserProperty: Faro is not initialized');
      return;
    }

    try {
      _faro!.setViewMeta(name: screenName);
      await _faro!.pushEvent(
        'view_changed',
        attributes: {
          'fromView': previousScreen ?? '',
          'toView': screenName,
          ...?parameters,
        },
      );
    } catch (e) {
      debugPrint('setPage: Error setting page: $e');
    }
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isFaroInitialized) {
      debugPrint('logAppOpen: Faro is not initialized');
      return;
    }

    try {
      await _faro!.pushEvent('app_open', attributes: parameters);
    } catch (e) {
      debugPrint('logAppOpen: Error logging app open: $e');
    }
  }

  @override
  Future<void> reset() async {
    if (!isFaroInitialized) {
      debugPrint('reset: Faro is not initialized');
      return;
    }

    try {
      _faro!.setUserMeta(userId: null, userEmail: null, userName: null);
    } catch (e) {
      debugPrint('reset: Error resetting: $e');
    }
  }
}
