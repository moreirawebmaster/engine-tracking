class EngineGoogleLoggingConfig {
  const EngineGoogleLoggingConfig({
    required this.enabled,
    required this.projectId,
    required this.logName,
    required this.credentials,
    this.resource,
  });

  final bool enabled;
  final String projectId;
  final String logName;
  final Map<String, dynamic> credentials;
  final Map<String, dynamic>? resource;

  @override
  String toString() =>
      'EngineGoogleLoggingConfig(enabled: $enabled, projectId: $projectId, logName: $logName, credentials: ****, resource: $resource)';
}
