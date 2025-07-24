import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/widgets.dart';

class EngineClarityAdapter implements IEngineAnalyticsAdapter<EngineClarityConfig> {
  EngineClarityAdapter(this.config);

  @override
  final EngineClarityConfig config;

  @override
  String get adapterName => 'Microsoft Clarity';

  @override
  bool get isEnabled => config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isFaroInitialized => isEnabled && _isInitialized;

  bool _isInitialized = false;

  @override
  Future<void> dispose() => Future.value(null);

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      debugPrint('Clarity is not enabled or already initialized');
      return;
    }
    _isInitialized = true;
    try {
      Clarity.setCustomSessionId(EngineSession.instance.sessionId);
    } catch (e) {
      _isInitialized = false;
    }
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    Clarity.sendCustomEvent('open_app');
    await Future.value(null);
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    Clarity.sendCustomEvent(name);
    await Future.value(null);
  }

  @override
  Future<void> reset() async {
    Clarity.setOnSessionStartedCallback((final sessionId) {
      Clarity.setCustomSessionId(EngineSession.instance.sessionId);
    });
    await Future.value(null);
  }

  @override
  Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    Clarity.setCurrentScreenName(screenName);
    await Future.value(null);
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    Clarity.setCustomUserId(userId ?? email ?? name ?? '');
    await Future.value(null);
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) {
    Clarity.setCustomTag(name, value ?? '');
    return Future.value(null);
  }
}
