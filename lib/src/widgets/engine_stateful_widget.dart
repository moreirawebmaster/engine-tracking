import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/widgets.dart';

///  class for StatefulWidget with automatic tracking functionalities
///
/// Usage:
/// ```dart
/// class MinhaTelaPage extends EngineStatefulWidget {
///   const MinhaTelaPage({super.key});
///
///   @override
///   EngineStatefulWidgetState<MinhaTelaPage> createState() => _MinhaTelaPageState();
/// }
///
/// class _MinhaTelaPageState extends EngineStatefulWidgetState<MinhaTelaPage> {
///   @override
///   Widget buildWithTracking(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: ElevatedButton(
///           onPressed: () => logUserAction('botao_clicado'),
///           child: Text('Clique aqui'),
///         ),
///       ),
///     );
///   }
/// }
/// ```
abstract class EngineStatefulWidget extends StatefulWidget {
  const EngineStatefulWidget({super.key});

  @override
  EngineStatefulWidgetState<EngineStatefulWidget> createState();
}

///  state for StatefulWidget with automatic tracking functionalities
abstract class EngineStatefulWidgetState<T extends EngineStatefulWidget> extends State<T> {
  EngineStatefulWidgetState() {
    _screenOpenTime = DateTime.now();
  }

  /// Screen name for tracking. By default uses the class name
  String get screenName => runtimeType.toString();

  /// Additional parameters to send in screen tracking
  Map<String, dynamic>? get screenParameters => null;

  /// Whether to automatically track screen views
  bool get enableAutoTracking => true;

  /// Whether to automatically track lifecycle events
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
      // Execute screen tracking after the first frame
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

  /// Builds the widget with automatic tracking
  @override
  Widget build(final BuildContext context) => buildWithTracking(context);

  /// Method that should be implemented instead of the original build
  Widget buildWithTracking(final BuildContext context);

  /// Tracks the screen view
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

  /// Logs a user action on the current screen
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

  /// Logs a custom event on the current screen
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

  /// Logs a screen-specific error
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

  /// Logs a state change on the screen
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
