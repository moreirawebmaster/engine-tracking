import 'package:engine_tracking/src/config/config.dart';
import 'package:flutter/foundation.dart';

/// Interface for bug tracking adapters in the Engine Tracking library.
///
/// Defines the contract that all bug tracking adapters must implement
/// to provide consistent error tracking and crash reporting functionality.
///
/// [TConfig] - The configuration type for this adapter.
abstract class IEngineBugTrackingAdapter<TConfig extends IEngineConfig> {
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

  /// Sets a custom key for error context.
  ///
  /// [key] - The key name.
  /// [value] - The key value.
  Future<void> setCustomKey(final String key, final Object value);

  /// Sets the user identifier for error tracking.
  ///
  /// [id] - The user ID.
  /// [email] - The user email.
  /// [name] - The user name.
  Future<void> setUserIdentifier(final String id, final String email, final String name);

  /// Logs a message for debugging purposes.
  ///
  /// [message] - The message to log.
  /// [level] - Optional log level.
  /// [attributes] - Optional attributes to include.
  /// [stackTrace] - Optional stack trace.
  Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  });

  /// Records an error with optional context.
  ///
  /// [exception] - The exception to record.
  /// [stackTrace] - Optional stack trace.
  /// [reason] - Optional reason for the error.
  /// [information] - Optional additional information.
  /// [isFatal] - Whether this is a fatal error.
  /// [data] - Optional additional data.
  Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  });

  /// Records a Flutter error.
  ///
  /// [errorDetails] - The Flutter error details.
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails);

  /// Tests crash reporting functionality.
  Future<void> testCrash();
}
