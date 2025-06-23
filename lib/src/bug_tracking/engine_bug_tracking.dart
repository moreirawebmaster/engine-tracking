import 'dart:async';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro_sdk.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class EngineBugTracking {
  EngineBugTracking._() {
    FlutterError.onError = (final details) async {
      await recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (final error, final stack) {
      unawaited(recordError(error, stack));
      return true;
    };
  }

  static FirebaseCrashlytics? _crashlytics;
  static Faro? _faro;
  static EngineBugTrackingModel? _engineBugTrackingModel;
  static bool _isInitialized = false;

  /// Initialize crash reporting functionality
  ///
  /// [model] is the model that contains the configuration for the bug tracking
  static Future<void> init(final EngineBugTrackingModel model) async {
    _engineBugTrackingModel = model;

    await Future.wait([
      if (model.crashlyticsConfig.enabled) _initCrashlytics(),
      if (model.faroConfig.enabled) _initFaro(),
    ]);

    _isInitialized = true;
  }

  static void reset() {
    _crashlytics = null;
    _faro = null;
    _engineBugTrackingModel = null;
    _isInitialized = false;
  }

  static Future<void> _initCrashlytics() async {
    _crashlytics = FirebaseCrashlytics.instance;
    await _crashlytics!.setCrashlyticsCollectionEnabled(true);
  }

  /// Initialize Faro with configuration
  static Future<void> _initFaro() async {
    _faro = Faro();
    HttpOverrides.global = FaroHttpOverrides(null);
    await _faro?.init(
      optionsConfiguration: FaroConfig(
        apiKey: _engineBugTrackingModel!.faroConfig.apiKey,
        appName: _engineBugTrackingModel!.faroConfig.appName,
        appVersion: _engineBugTrackingModel!.faroConfig.appVersion,
        appEnv: _engineBugTrackingModel!.faroConfig.environment,
        collectorUrl: _engineBugTrackingModel!.faroConfig.endpoint,
        enableCrashReporting: true,
        anrTracking: true,
      ),
    );
  }

  /// Set a custom key-value pair for crash reporting
  static Future<void> setCustomKey(final String key, final Object value) async {
    if (isCrashlyticsEnabled) {
      await _crashlytics!.setCustomKey(key, value);
    }
  }

  /// Set user identifier for crash reporting
  static Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (id == '0') {
      return;
    }

    if (isCrashlyticsEnabled) {
      await _crashlytics?.setUserIdentifier(id);
    }

    if (isFaroEnabled) {
      _faro?.setUserMeta(userId: id, userEmail: email, userName: name);
    }
  }

  /// Log a message for crash reporting
  static Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  }) async {
    if (isCrashlyticsEnabled) {
      await _crashlytics?.log(message);
    }

    if (isFaroEnabled) {
      await _faro?.pushLog(
        message,
        level: level,
        context: attributes,
        trace: {'stack': stackTrace?.toString() ?? 'Stack trace not available'},
      );
    }
  }

  /// Record an error for crash reporting
  static Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  }) async {
    if (isCrashlyticsEnabled) {
      try {
        await _crashlytics!.recordError(
          exception,
          stackTrace,
          reason: reason,
          information: information,
          fatal: isFatal,
          printDetails: kDebugMode,
        );
      } catch (e) {
        debugPrint('Failed to record error in Crashlytics: $e');
      }
    }

    if (isFaroEnabled) {
      await _faro?.pushError(
        type: reason ?? 'Unknown',
        value: exception.toString(),
        context: {
          'data': data?.toString() ?? '',
          'information': information.map((final e) => e.toString()).join(', '),
          'isFatal': isFatal.toString(),
        },
        stacktrace: stackTrace,
      );
    }
  }

  /// Record a Flutter error for crash reporting
  static Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (isCrashlyticsEnabled) {
      try {
        await _crashlytics!.recordFlutterError(errorDetails);
      } catch (e) {
        debugPrint('Failed to record Flutter error in Crashlytics: $e');
      }
    }

    if (isFaroEnabled) {
      await _faro?.pushError(
        type: 'FlutterError',
        value: errorDetails.exception.toString(),
        context: {
          'data': errorDetails.exception.toString(),
          'information': errorDetails.informationCollector?.call().join(', ') ?? 'No information available',
          'isFatal': 'false',
          'silent': errorDetails.silent.toString(),
          'package': errorDetails.library.toString(),
          'context': errorDetails.context?.toStringDeep() ?? 'No context available',
          'summary': errorDetails.summary.toString(),
        },
        stacktrace: errorDetails.stack,
      );
    }
  }

  /// Test crash functionality (only in debug mode)
  static Future<void> testCrash() async {
    if (kDebugMode) {
      if (isCrashlyticsEnabled) {
        try {
          _crashlytics!.crash();
        } catch (e) {
          debugPrint('Failed to test crash in Crashlytics: $e');
        }
      }
    }
  }

  /// Check if Firebase Crashlytics is enabled and available
  static bool get isCrashlyticsEnabled => _engineBugTrackingModel?.crashlyticsConfig.enabled ?? false;

  /// Check if Faro is enabled and available
  static bool get isFaroEnabled => _engineBugTrackingModel?.faroConfig.enabled ?? false;

  /// Check if the bug tracking is enabled
  static bool get isEnabled => _isInitialized && (isCrashlyticsEnabled || isFaroEnabled);
}
