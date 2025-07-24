import 'package:engine_tracking/src/config/config.dart';
import 'package:flutter/foundation.dart';

abstract class IEngineBugTrackingAdapter<TConfig extends IEngineConfig> {
  String get adapterName;
  bool get isEnabled;
  bool get isInitialized;
  TConfig get config;

  Future<void> initialize();
  Future<void> dispose();

  Future<void> setCustomKey(final String key, final Object value);
  Future<void> setUserIdentifier(final String id, final String email, final String name);
  Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  });
  Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  });
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails);
  Future<void> testCrash();
}
