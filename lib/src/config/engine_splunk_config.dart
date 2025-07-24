import 'package:engine_tracking/src/config/config.dart';

class EngineSplunkConfig extends IEngineConfig {
  EngineSplunkConfig({
    required super.enabled,
    required this.endpoint,
    required this.token,
    required this.source,
    required this.sourcetype,
    required this.index,
  });

  final String endpoint;
  final String token;
  final String source;
  final String sourcetype;
  final String index;

  @override
  String toString() =>
      'EngineSplunkConfig(enabled: $enabled, endpoint: $endpoint, source: $source, sourcetype: $sourcetype, index: $index, token: ****)';
}
