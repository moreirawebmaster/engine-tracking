import 'package:engine_tracking/src/config/config.dart';

abstract class IEngineAnalyticsAdapter<TConfig extends IEngineConfig> {
  String get adapterName;
  bool get isEnabled;
  bool get isInitialized;
  TConfig get config;

  Future<void> initialize();
  Future<void> dispose();

  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]);
  Future<void> setUserId(final String? userId, [final String? email, final String? name]);
  Future<void> setUserProperty(final String name, final String? value);
  Future<void> setPage(final String screenName, [final String? previousScreen, final Map<String, dynamic>? parameters]);
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]);
  Future<void> reset();
}
