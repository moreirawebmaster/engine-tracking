class EngineSplunkConfig {
  const EngineSplunkConfig({
    required this.enabled,
    required this.endpoint,
    required this.token,
    required this.source,
    required this.sourcetype,
    required this.index,
  });

  final bool enabled;
  final String endpoint;
  final String token;
  final String source;
  final String sourcetype;
  final String index;

  @override
  String toString() =>
      'EngineSplunkConfig(enabled: $enabled, endpoint: $endpoint, source: $source, sourcetype: $sourcetype, index: $index, token: ****)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is EngineSplunkConfig &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          endpoint == other.endpoint &&
          token == other.token &&
          source == other.source &&
          sourcetype == other.sourcetype &&
          index == other.index;

  @override
  int get hashCode =>
      enabled.hashCode ^ endpoint.hashCode ^ token.hashCode ^ source.hashCode ^ sourcetype.hashCode ^ index.hashCode;
}
