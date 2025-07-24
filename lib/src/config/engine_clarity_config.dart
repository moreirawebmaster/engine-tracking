import 'package:engine_tracking/src/config/config.dart';
import 'package:engine_tracking/src/enums/enums.dart';

class EngineClarityConfig extends IEngineConfig {
  EngineClarityConfig({
    required super.enabled,
    required this.projectId,
    this.level = EngineLogLevelType.info,
  });

  final String projectId;

  final EngineLogLevelType level;

  @override
  String toString() => 'EngineClarityConfig(enabled: $enabled, projectId: *****)';
}
