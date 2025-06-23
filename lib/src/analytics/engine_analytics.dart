import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:faro/faro_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class EngineAnalytics {
  EngineAnalytics._();

  static FirebaseAnalytics? _analytics;
  static Faro? _faro;
  static EngineAnalyticsModel? _engineAnalyticsModel;
  static bool _isInitialized = false;

  static Future<void> init(final EngineAnalyticsModel model) async {
    _engineAnalyticsModel = model;

    await Future.wait([
      if (model.firebaseAnalyticsConfig.enabled) _initFirebaseAnalytics(),
      if (model.faroConfig.enabled) _initFaro(),
    ]);

    _isInitialized = true;
  }

  static void reset() {
    _analytics = null;
    _faro = null;
    _engineAnalyticsModel = null;
    _isInitialized = false;
  }

  static Future<void> _initFirebaseAnalytics() async {
    _analytics = FirebaseAnalytics.instance;
  }

  static Future<void> _initFaro() async {
    _faro = Faro();
    if (!EngineBugTracking.isFaroEnabled) {
      await _faro?.init(
        optionsConfiguration: FaroConfig(
          apiKey: _engineAnalyticsModel!.faroConfig.apiKey,
          appName: _engineAnalyticsModel!.faroConfig.appName,
          appVersion: _engineAnalyticsModel!.faroConfig.appVersion,
          appEnv: _engineAnalyticsModel!.faroConfig.environment,
          collectorUrl: _engineAnalyticsModel!.faroConfig.endpoint,
          enableCrashReporting: false,
          anrTracking: false,
        ),
      );
    }
  }

  static Future<void> logEvent(final String name, [final Map<String, Object>? parameters]) async {
    if (isFirebaseAnalyticsEnabled) {
      await _analytics?.logEvent(name: name, parameters: parameters);
    }

    if (isFaroEnabled) {
      await _faro?.pushEvent(name, attributes: parameters?.cast<String, dynamic>());
    }
  }

  static Future<void> setUserId(final String userId, [final String? email, final String? name]) async {
    if (userId == '0' || userId.isEmpty) {
      return;
    }

    if (isFirebaseAnalyticsEnabled) {
      await _analytics?.setUserId(id: userId);
    }

    if (isFaroEnabled) {
      _faro?.setUserMeta(userId: userId, userEmail: email, userName: name);
    }
  }

  static Future<void> setUserProperty(final String name, final String value) async {
    if (isFirebaseAnalyticsEnabled) {
      await _analytics?.setUserProperty(name: name, value: value);
    }
  }

  static Future<void> setPage(
    final String pageName, [
    final String previousPageName = '',
    final String pageClass = 'Flutter',
  ]) async {
    if (isFirebaseAnalyticsEnabled) {
      await _analytics?.logScreenView(screenName: pageName, screenClass: pageClass);
    }

    if (isFaroEnabled) {
      _faro?.setViewMeta(name: pageName);
      await _faro?.pushEvent(
        'view_changed',
        attributes: {
          'fromView': previousPageName,
          'toView': pageName,
        },
      );
    }
  }

  static Future<void> logAppOpen() async {
    if (isFirebaseAnalyticsEnabled) {
      await _analytics?.logAppOpen();
    }

    if (isFaroEnabled) {
      await _faro?.pushEvent('app_open');
    }
  }

  static bool get isFirebaseAnalyticsEnabled => _engineAnalyticsModel?.firebaseAnalyticsConfig.enabled ?? false;

  static bool get isFaroEnabled => _engineAnalyticsModel?.faroConfig.enabled ?? false;

  static bool get isEnabled => _isInitialized && (isFirebaseAnalyticsEnabled || isFaroEnabled);

  static Faro? get faro => _faro;
}
