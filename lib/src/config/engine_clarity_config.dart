class EngineClarityConfig {
  const EngineClarityConfig({
    required this.enabled,
    required this.projectId,
    this.userId,
  });

  final bool enabled;

  final String projectId;

  final String? userId;

  @override
  String toString() => 'EngineClarityConfig(enabled: $enabled, projectId: *****, userId: *****)';
}
