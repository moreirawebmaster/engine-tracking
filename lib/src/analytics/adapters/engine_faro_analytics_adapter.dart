import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro.dart';
import 'package:flutter/widgets.dart';

/// Grafana Faro analytics adapter for the Engine Tracking library.
///
/// Provides integration with Grafana Faro for observability and analytics.
class EngineFaroAnalyticsAdapter implements IEngineAnalyticsAdapter<EngineFaroConfig> {
  /// Creates a new Grafana Faro analytics adapter.
  ///
  /// [config] - The Grafana Faro configuration.
  EngineFaroAnalyticsAdapter(this.config);

  /// The Grafana Faro configuration.
  @override
  final EngineFaroConfig config;

  /// The name of this adapter.
  @override
  String get adapterName => 'Grafana Faro';

  /// Whether this adapter is enabled.
  @override
  bool get isEnabled => config.enabled;

  /// Whether this adapter has been initialized.
  @override
  bool get isInitialized => _isInitialized;

  bool _isInitialized = false;

  /// Whether Grafana Faro is initialized and ready.
  bool get isFaroInitialized => isEnabled && _isInitialized && _faro != null;

  Faro? _faro;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      debugPrint('Faro is not enabled or already initialized');
      return;
    }

    _isInitialized = true;

    try {
      _faro = Faro();
      if (!EngineBugTracking.isFaroInitialized) {
        await _faro?.init(
          optionsConfiguration: FaroConfig(
            apiKey: config.apiKey,
            appName: config.appName,
            appVersion: config.appVersion,
            appEnv: config.environment,
            collectorUrl: config.endpoint,
            enableCrashReporting: true,
            anrTracking: true,
            namespace: config.namespace,
          ),
        );
      }
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
      _faro?.pushEvent(name, attributes: convertToStringMap(parameters));
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
      _faro?.setUserMeta(userId: userId, userEmail: email, userName: name);
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
      debugPrint('setPage: Faro is not initialized');
      return;
    }

    try {
      _faro?.setViewMeta(name: screenName);
      _faro?.pushEvent(
        'navigation',
        attributes: {...?parameters, 'screen': screenName, 'previousScreen': previousScreen ?? ''},
        trace: {'to_screen': screenName, 'previousScreen': previousScreen ?? ''},
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
      _faro?.pushEvent('app_open', attributes: convertToStringMap(parameters));
    } catch (e) {
      debugPrint('logAppOpen: Error logging app open: $e');
    }
  }

  @override
  Future<void> reset() async {
    if (isFaroInitialized) {
      debugPrint('reset: Faro is not initialized');
      return;
    }

    try {
      _faro?.setUserMeta(userId: null, userEmail: null, userName: null);
    } catch (e) {
      debugPrint('reset: Error resetting: $e');
    }
  }
}
