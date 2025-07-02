import 'package:engine_tracking/src/src.dart';

class EngineClarityConfig {
  const EngineClarityConfig({
    required this.enabled,
    required this.projectId,
    this.level = EngineLogLevelType.info,
    this.userId,
  });

  final bool enabled;

  final String projectId;

  final String? userId;

  final EngineLogLevelType level;

  @override
  String toString() => 'EngineClarityConfig(enabled: $enabled, projectId: *****, userId: *****)';
}
