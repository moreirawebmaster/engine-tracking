import 'dart:convert';
import 'dart:io';

import 'package:engine_tracking/src/analytics/adapters/i_engine_analytics_adapter.dart';
import 'package:engine_tracking/src/config/engine_splunk_config.dart';
import 'package:flutter/material.dart';

class EngineSplunkAnalyticsAdapter implements IEngineAnalyticsAdapter {
  EngineSplunkAnalyticsAdapter(this._config);

  @override
  String get adapterName => 'Splunk';

  @override
  bool get isEnabled => _config.enabled;

  @override
  bool get isInitialized => _isInitialized;

  bool get isSplunkInitialized => isEnabled && _isInitialized;

  bool _isInitialized = false;
  final EngineSplunkConfig _config;
  late final HttpClient _httpClient;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) {
      return;
    }

    try {
      _httpClient = HttpClient();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      debugPrint('failed to initialize Splunk $e');
    }
  }

  @override
  Future<void> dispose() async {
    if (_isInitialized) {
      _httpClient.close();
    }
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isSplunkInitialized) {
      debugPrint('logEvent: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': name,
        'data': parameters ?? {},
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('logEvent: Error logging event: $e');
    }
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isSplunkInitialized) {
      debugPrint('setUserId: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': 'user_identified',
        'data': {
          if (userId != null) 'user_id': userId,
          if (email != null) 'email': email,
          if (name != null) 'name': name,
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('setUserId: Error setting user id: $e');
    }
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    if (!isSplunkInitialized) {
      debugPrint('setUserProperty: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': 'user_property_set',
        'data': {
          'property_name': name,
          'property_value': value,
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('setUserProperty: Error setting user property: $e');
    }
  }

  @override
  Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isSplunkInitialized) {
      debugPrint('setPage: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': 'page_view',
        'data': {
          'screen_name': screenName,
          if (previousScreen != null) 'previous_screen': previousScreen,
          ...?parameters,
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('setPage: Error setting page: $e');
    }
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isSplunkInitialized) {
      debugPrint('logAppOpen: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': 'app_open',
        'data': parameters ?? {},
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('logAppOpen: Error logging app open: $e');
    }
  }

  @override
  Future<void> reset() async {
    if (!isSplunkInitialized) {
      debugPrint('reset: Splunk is not initialized');
      return;
    }

    try {
      await _sendToSplunk({
        'event': 'analytics_reset',
        'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
      });
    } catch (e) {
      debugPrint('reset: Error resetting: $e');
    }
  }

  Future<void> _sendToSplunk(final Map<String, dynamic> data) async {
    final request = await _httpClient.postUrl(Uri.parse(_config.endpoint));

    request.headers.set('Authorization', 'Splunk ${_config.token}');
    request.headers.set('Content-Type', 'application/json');

    final body = jsonEncode({
      'time': data['timestamp'],
      'source': _config.source,
      'sourcetype': _config.sourcetype,
      'index': _config.index,
      'event': data,
    });

    request.write(body);
    final response = await request.close();

    await response.drain<List<int>>();
  }
}
