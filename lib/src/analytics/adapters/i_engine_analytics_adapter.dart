import 'package:engine_tracking/src/config/config.dart';

/// Interface for analytics adapters in the Engine Tracking library.
///
/// Defines the contract that all analytics adapters must implement
/// to provide consistent analytics functionality across different services.
///
/// [TConfig] - The configuration type for this adapter.
abstract class IEngineAnalyticsAdapter<TConfig extends IEngineConfig> {
  /// The name of this adapter.
  String get adapterName;

  /// Whether this adapter is enabled.
  bool get isEnabled;

  /// Whether this adapter has been initialized.
  bool get isInitialized;

  /// The configuration for this adapter.
  TConfig get config;

  /// Initializes this adapter.
  Future<void> initialize();

  /// Disposes of this adapter and cleans up resources.
  Future<void> dispose();

  /// Logs an analytics event.
  ///
  /// [name] - The name of the event.
  /// [parameters] - Optional parameters for the event.
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]);

  /// Sets the user ID and optional user information.
  ///
  /// [userId] - The user ID.
  /// [email] - Optional email address.
  /// [name] - Optional display name.
  Future<void> setUserId(final String? userId, [final String? email, final String? name]);

  /// Sets a user property.
  ///
  /// [name] - The property name.
  /// [value] - The property value.
  Future<void> setUserProperty(final String name, final String? value);

  /// Sets the current page/screen.
  ///
  /// [screenName] - The screen name.
  /// [previousScreen] - Optional previous screen name.
  /// [parameters] - Optional page parameters.
  Future<void> setPage(final String screenName, [final String? previousScreen, final Map<String, dynamic>? parameters]);

  /// Logs an app open event.
  ///
  /// [parameters] - Optional parameters for the event.
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]);

  /// Resets this adapter to its initial state.
  Future<void> reset();
}
