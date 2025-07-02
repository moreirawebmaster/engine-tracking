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
}
