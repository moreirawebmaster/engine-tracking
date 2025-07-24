import 'package:engine_tracking/src/config/config.dart';

/// Configuration for Splunk integration.
///
/// Provides settings for Splunk analytics and bug tracking.
class EngineSplunkConfig extends IEngineConfig {
  /// Creates a new Splunk configuration.
  ///
  /// [enabled] - Whether Splunk is enabled.
  /// [endpoint] - The Splunk HTTP Event Collector endpoint.
  /// [token] - The Splunk authentication token.
  /// [source] - The Splunk source name.
  /// [sourcetype] - The Splunk source type.
  /// [index] - The Splunk index name.
  EngineSplunkConfig({
    required super.enabled,
    required this.endpoint,
    required this.token,
    required this.source,
    required this.sourcetype,
    required this.index,
  });

  /// The Splunk HTTP Event Collector endpoint.
  final String endpoint;

  /// The Splunk authentication token.
  final String token;

  /// The Splunk source name.
  final String source;

  /// The Splunk source type.
  final String sourcetype;

  /// The Splunk index name.
  final String index;

  @override
  String toString() =>
      'EngineSplunkConfig(enabled: $enabled, endpoint: $endpoint, source: $source, sourcetype: $sourcetype, index: $index, token: ****)';
}
