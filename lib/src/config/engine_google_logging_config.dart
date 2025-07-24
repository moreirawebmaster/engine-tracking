import 'package:engine_tracking/src/config/config.dart';

class EngineGoogleLoggingConfig extends IEngineConfig {
  EngineGoogleLoggingConfig({
    required super.enabled,
    required this.projectId,
    required this.logName,
    required this.credentials,
    this.resource,
  });

  final String projectId;
  final String logName;
  final Map<String, dynamic> credentials;
  final Map<String, dynamic>? resource;

  @override
  String toString() =>
      'EngineGoogleLoggingConfig(enabled: $enabled, projectId: $projectId, logName: $logName, credentials: ****, resource: $resource)';
}
