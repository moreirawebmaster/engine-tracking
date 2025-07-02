import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

class EngineWidget extends StatelessWidget {
  const EngineWidget({
    required this.app,
    required this.clarityConfig,
    super.key,
  });

  final Widget app;
  final EngineClarityConfig clarityConfig;

  @override
  Widget build(final BuildContext context) {
    if (clarityConfig.enabled) {
      return ClarityWidget(
        app: app,
        clarityConfig: ClarityConfig(
          projectId: clarityConfig.projectId,
          userId: clarityConfig.userId,
          logLevel: switch (clarityConfig.level) {
            EngineLogLevelType.verbose => LogLevel.Verbose,
            EngineLogLevelType.fatal => LogLevel.Verbose,
            EngineLogLevelType.debug => LogLevel.Debug,
            EngineLogLevelType.info => LogLevel.Info,
            EngineLogLevelType.warning => LogLevel.Warn,
            EngineLogLevelType.error => LogLevel.Error,
            EngineLogLevelType.none => LogLevel.None,
          },
        ),
      );
    }
    return app;
  }
}
