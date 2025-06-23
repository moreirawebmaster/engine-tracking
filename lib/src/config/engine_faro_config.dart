import 'dart:io';

class EngineFaroConfig {
  const EngineFaroConfig({
    required this.enabled,
    required this.endpoint,
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.apiKey,
    this.httpOverrides,
  });

  final bool enabled;
  final String endpoint;
  final String appName;
  final String appVersion;
  final String environment;
  final String apiKey;
  final HttpOverrides? httpOverrides;

  @override
  String toString() =>
      'EngineFaroConfig(enabled: $enabled, endpoint: $endpoint, appName: $appName, appVersion: $appVersion, environment: $environment, apiKey: ****)';
}
