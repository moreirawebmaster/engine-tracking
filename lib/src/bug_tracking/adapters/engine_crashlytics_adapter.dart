import 'package:engine_tracking/src/bug_tracking/adapters/i_engine_bug_tracking_adapter.dart';
import 'package:engine_tracking/src/config/engine_crashlytics_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class EngineCrashlyticsAdapter implements IEngineBugTrackingAdapter<EngineCrashlyticsConfig> {
  EngineCrashlyticsAdapter(this.config);

  @override
  String get adapterName => 'Firebase Crashlytics';

  @override
  bool get isEnabled => config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  @override
  final EngineCrashlyticsConfig config;

  bool get isCrashlyticsInitialized => isEnabled && _isInitialized && _crashlytics != null;

  bool _isInitialized = false;

  FirebaseCrashlytics? _crashlytics;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      return;
    }

    _isInitialized = true;

    try {
      _crashlytics = FirebaseCrashlytics.instance;
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);
    } catch (e) {
      _isInitialized = false;
      debugPrint('failed to initialize Crashlytics $e');
    }
  }

  @override
  Future<void> dispose() async {
    _crashlytics = null;
    _isInitialized = false;
  }

  @override
  Future<void> setCustomKey(final String key, final Object value) async {
    if (!isCrashlyticsInitialized) {
      debugPrint('setCustomKey: Crashlytics is not initialized');
      return;
    }

    try {
      await _crashlytics?.setCustomKey(key, value);
    } catch (e) {
      debugPrint('setCustomKey: Error setting custom key: $e');
    }
  }

  @override
  Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isCrashlyticsInitialized) {
      debugPrint('setUserIdentifier: Crashlytics is not initialized');
      return;
    }

    if (id == '0') {
      return;
    }

    try {
      await _crashlytics?.setUserIdentifier(id);
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
    if (!isCrashlyticsInitialized) {
      debugPrint('log: Crashlytics is not initialized');
      return;
    }

    try {
      await _crashlytics?.log(message);
    } catch (e) {
      debugPrint('log: Error logging message: $e');
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
    if (!isCrashlyticsInitialized) {
      debugPrint('recordError: Crashlytics is not initialized');
      return;
    }

    try {
      await _crashlytics?.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information,
        fatal: isFatal,
        printDetails: kDebugMode,
      );
    } catch (e) {
      debugPrint('recordError: Error recording error: $e');
    }
  }

  @override
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isCrashlyticsInitialized) {
      debugPrint('recordFlutterError: Crashlytics is not initialized');
      return;
    }

    try {
      await _crashlytics?.recordFlutterError(errorDetails);
    } catch (e) {
      debugPrint('recordFlutterError: Error recording Flutter error: $e');
    }
  }

  @override
  Future<void> testCrash() async {
    if (!isCrashlyticsInitialized) {
      debugPrint('testCrash: Crashlytics is not initialized');
      return;
    }

    if (kDebugMode) {
      try {
        _crashlytics?.crash();
      } catch (e) {
        debugPrint('testCrash: Error testing crash: $e');
      }
    }
  }
}
