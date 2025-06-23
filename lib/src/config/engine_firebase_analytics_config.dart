class EngineFirebaseAnalyticsConfig {
  const EngineFirebaseAnalyticsConfig({required this.enabled});

  final bool enabled;

  @override
  String toString() => 'EngineFirebaseAnalyticsConfig(enabled: $enabled)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is EngineFirebaseAnalyticsConfig && runtimeType == other.runtimeType && enabled == other.enabled;

  @override
  int get hashCode => enabled.hashCode;
}
