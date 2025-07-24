import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/widgets.dart';

/// Base class for stateful widgets with automatic tracking capabilities
///
/// This abstract class provides automatic screen tracking, lifecycle events,
/// and user action logging for stateful widgets.
abstract class EngineStatefulWidget extends StatefulWidget {
  /// Creates a new EngineStatefulWidget
  ///
  /// [key] The widget key
  const EngineStatefulWidget({super.key});

  @override
  EngineStatefulWidgetState<EngineStatefulWidget> createState();
}

/// State class for EngineStatefulWidget with tracking capabilities
///
/// This abstract class provides automatic tracking functionality including
/// screen lifecycle events, user actions, and custom events.
abstract class EngineStatefulWidgetState<T extends EngineStatefulWidget> extends State<T> {
  /// Creates a new EngineStatefulWidgetState
  ///
  /// Initializes the screen open time for tracking purposes.
  EngineStatefulWidgetState() {
    _screenOpenTime = DateTime.now();
  }

  /// Returns the screen name for tracking purposes
  String get screenName => runtimeType.toString();

  /// Returns screen parameters for tracking
  Map<String, dynamic>? get screenParameters => null;

  /// Whether to enable automatic screen tracking
  bool get enableAutoTracking => true;

  /// Whether to enable lifecycle event tracking
  bool get enableLifecycleTracking => true;

  /// Timestamp when the screen was opened
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

  /// Build method that includes tracking functionality
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

  /// Logs a user action with screen context
  ///
  /// [action] The action being performed
  /// [parameters] Optional parameters for the action
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

  /// Logs a custom event with screen context
  ///
  /// [eventName] The name of the custom event
  /// [parameters] Optional parameters for the event
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

  /// Logs a screen error with context
  ///
  /// [reason] The reason for the error
  /// [exception] Optional exception object
  /// [stackTrace] Optional stack trace
  /// [additionalData] Optional additional error data
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

  /// Logs a state change with screen context
  ///
  /// [stateDescription] Description of the state change
  /// [additionalData] Optional additional data about the state change
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
