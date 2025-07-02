import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:engine_tracking/src/config/engine_clarity_config.dart';
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
          logLevel: LogLevel.Verbose,
        ),
      );
    }
    return app;
  }
}
