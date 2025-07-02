import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/widgets.dart';

abstract class EngineStatefulWidget extends StatefulWidget {
  const EngineStatefulWidget({super.key});

  @override
  EngineStatefulWidgetState<EngineStatefulWidget> createState();
}

abstract class EngineStatefulWidgetState<T extends EngineStatefulWidget> extends State<T> {
  EngineStatefulWidgetState() {
    _screenOpenTime = DateTime.now();
  }

  String get screenName => runtimeType.toString();

  Map<String, dynamic>? get screenParameters => null;

  bool get enableAutoTracking => true;

  bool get enableLifecycleTracking => true;

  late final DateTime _screenOpenTime;

  @override
  void initState() {
    super.initState();

    if (enableLifecycleTracking) {
      unawaited(
        EngineLog.debug(
          'screen_initialized',
          logName: 'init',
          data: {
            'screen_name': screenName,
          },
        ),
      );
    }

    if (enableAutoTracking) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _trackScreenView();
      });
    }
  }

  @override
  void dispose() {
    if (enableLifecycleTracking) {
      final timeSpent = DateTime.now().difference(_screenOpenTime);
      unawaited(
        EngineLog.debug(
          'screen_closed',
          logName: 'view',
          data: {
            'screen_name': screenName,
            'time_spent_seconds': timeSpent.inSeconds,
          },
        ),
      );
    }

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => buildWithTracking(context);

  Widget buildWithTracking(final BuildContext context);

  Future<void> _trackScreenView() async {
    await EngineLog.debug(
      'screen_viewed',
      logName: 'view',
      data: {
        'screen_name': screenName,
        if (screenParameters != null) 'parameters': screenParameters,
      },
    );
  }

  Future<void> logUserAction(
    final String action, {
    final Map<String, dynamic>? parameters,
  }) async {
    final actionData = <String, dynamic>{
      'screen_name': screenName,
      'action': action,
      if (parameters != null) ...parameters,
    };

    await EngineLog.debug(
      'user_action',
      logName: 'action',
      data: actionData,
    );
  }

  Future<void> logCustomEvent(
    final String eventName, {
    final Map<String, dynamic>? parameters,
  }) async {
    final eventData = <String, dynamic>{
      'screen_name': screenName,

      if (parameters != null) ...parameters,
    };

    await EngineLog.debug(
      eventName,
      logName: 'event',
      data: eventData,
    );
  }

  Future<void> logScreenError(
    final String reason, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, dynamic>? additionalData,
  }) async {
    final errorData = <String, dynamic>{
      'screen_name': screenName,
      if (additionalData != null) ...additionalData,
    };

    await EngineLog.error(
      reason,
      logName: 'error',
      error: exception,
      stackTrace: stackTrace,
      data: errorData,
    );
  }

  Future<void> logStateChange(
    final String stateDescription, {
    final Map<String, dynamic>? additionalData,
  }) async {
    final stateData = <String, dynamic>{
      'screen_name': screenName,
      'state_change': stateDescription,
      if (additionalData != null) ...additionalData,
    };

    await EngineLog.debug(
      'state_change',
      logName: 'state',
      data: stateData,
    );
  }
}
