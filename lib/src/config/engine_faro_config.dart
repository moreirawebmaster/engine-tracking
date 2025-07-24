import 'dart:io';

import 'package:engine_tracking/src/config/config.dart';

class EngineFaroConfig extends IEngineConfig {
  EngineFaroConfig({
    required super.enabled,
    required this.endpoint,
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.apiKey,
    required this.namespace,
    required this.platform,
    this.httpTrackingEnable = false,
    this.httpOverrides,
  });

  final String endpoint;
  final String appName;
  final String appVersion;
  final String environment;
  final String apiKey;
  final String namespace;
  final String platform;
  final HttpOverrides? httpOverrides;
  final bool httpTrackingEnable;

  @override
  String toString() =>
      'EngineFaroConfig(enabled: $enabled, endpoint: $endpoint, appName: $appName, appVersion: $appVersion, environment: $environment, apiKey: ****, namespace: $namespace, platform: $platform)';
}
