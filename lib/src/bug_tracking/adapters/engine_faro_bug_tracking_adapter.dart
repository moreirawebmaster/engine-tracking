import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro.dart';
import 'package:flutter/foundation.dart';

class EngineFaroBugTrackingAdapter implements IEngineBugTrackingAdapter<EngineFaroConfig> {
  EngineFaroBugTrackingAdapter(this.config);

  @override
  String get adapterName => 'Grafana Faro Bug Tracking';

  @override
  bool get isEnabled => config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isFaroInitialized => isEnabled && _isInitialized && _faro != null;

  bool _isInitialized = false;

  @override
  final EngineFaroConfig config;

  Faro? _faro;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      debugPrint('Faro Bug Tracking is not enabled or already initialized');
      return;
    }

    _isInitialized = true;

    try {
      _faro = Faro();

      if (config.httpTrackingEnable) {
        HttpOverrides.global = FaroHttpOverrides(config.httpOverrides ?? HttpOverrides.current);
      }

      if (EngineAnalytics.isFaroInitialized) {
        return;
      }

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
      _faro!.pushLog(
        message,
        level: LogLevel.fromString(level) ?? LogLevel.info,
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

      _faro!.pushError(
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

      _faro!.pushError(
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

        _faro!.pushError(
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
