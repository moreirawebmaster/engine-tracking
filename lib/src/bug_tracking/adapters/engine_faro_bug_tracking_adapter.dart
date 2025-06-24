import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro_sdk.dart';
import 'package:flutter/foundation.dart';

class EngineFaroBugTrackingAdapter implements IEngineBugTrackingAdapter {
  EngineFaroBugTrackingAdapter(this._config);

  @override
  String get adapterName => 'Grafana Faro Bug Tracking';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isFaroInitialized => isEnabled && _isInitialized && _faro != null;

  bool _isInitialized = false;
  final EngineFaroConfig _config;
  Faro? _faro;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      debugPrint('Faro Bug Tracking is not enabled or already initialized');
      return;
    }

    try {
      _faro = Faro();
      HttpOverrides.global = FaroHttpOverrides(null);

      if (EngineAnalytics.isFaroInitialized) {
        return;
      }

      await _faro?.init(
        optionsConfiguration: FaroConfig(
          apiKey: _config.apiKey,
          appName: _config.appName,
          appVersion: _config.appVersion,
          appEnv: _config.environment,
          collectorUrl: _config.endpoint,
          enableCrashReporting: true,
          anrTracking: true,
          refreshRateVitals: true,
          namespace: _config.namespace,
        ),
      );
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      debugPrint('failed to initialize Faro Bug Tracking $e');
    }
  }

  @override
  Future<void> dispose() async {
    _faro = null;
    _isInitialized = false;
  }

  @override
  Future<void> setCustomKey(final String key, final Object value) async {
    if (!isFaroInitialized) {
      debugPrint('setCustomKey: Faro Bug Tracking is not initialized');
      return;
    }

    // Faro doesn't have a direct equivalent for custom keys
    // We can use context for similar functionality
  }

  @override
  Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isFaroInitialized) {
      debugPrint('setUserIdentifier: Faro Bug Tracking is not initialized');
      return;
    }

    if (id == '0') {
      return;
    }

    try {
      _faro!.setUserMeta(userId: id, userEmail: email, userName: name);
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
    if (!isFaroInitialized) {
      debugPrint('log: Faro Bug Tracking is not initialized');
      return;
    }

    try {
      await _faro!.pushLog(
        message,
        level: level,
        context: convertToStringMap(attributes),
        trace: {'stack': (stackTrace ?? StackTrace.current).toString()},
      );
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
    if (!isFaroInitialized) {
      debugPrint('recordError: Faro Bug Tracking is not initialized');
      return;
    }

    try {
      final contextData = <String, dynamic>{
        'data': data?.toString() ?? '',
        'information': information.map((final e) => e.toString()).join(', '),
        'isFatal': isFatal.toString(),
      };

      await _faro!.pushError(
        type: reason ?? 'Unknown',
        value: exception.toString(),
        context: convertToStringMap(contextData),
        stacktrace: stackTrace,
      );
    } catch (e) {
      debugPrint('recordError: Error recording error: $e');
    }
  }

  @override
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isFaroInitialized) {
      debugPrint('recordFlutterError: Faro Bug Tracking is not initialized');
      return;
    }

    try {
      final contextData = <String, dynamic>{
        'data': errorDetails.exception.toString(),
        'information': errorDetails.informationCollector?.call().join(', ') ?? 'No information available',
        'isFatal': 'false',
        'silent': errorDetails.silent.toString(),
        'package': errorDetails.library.toString(),
        'context': errorDetails.context?.toStringDeep() ?? 'No context available',
        'summary': errorDetails.summary.toString(),
      };

      await _faro!.pushError(
        type: 'FlutterError',
        value: errorDetails.exception.toString(),
        context: convertToStringMap(contextData),
        stacktrace: errorDetails.stack,
      );
    } catch (e) {
      debugPrint('recordFlutterError: Error recording Flutter error: $e');
    }
  }

  @override
  Future<void> testCrash() async {
    if (!isFaroInitialized) {
      debugPrint('testCrash: Faro Bug Tracking is not initialized');
      return;
    }

    if (kDebugMode) {
      try {
        final contextData = <String, dynamic>{'test': 'true'};

        await _faro!.pushError(
          type: 'TestCrash',
          value: 'This is a test crash for Faro',
          context: convertToStringMap(contextData),
          stacktrace: StackTrace.current,
        );
      } catch (e) {
        debugPrint('testCrash: Error testing crash: $e');
      }
    }
  }
}
