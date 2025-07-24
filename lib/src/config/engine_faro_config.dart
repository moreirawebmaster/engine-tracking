import 'dart:io';

import 'package:engine_tracking/src/config/config.dart';

/// Configuration for Grafana Faro integration.
///
/// Provides settings for Grafana Faro observability and analytics.
class EngineFaroConfig extends IEngineConfig {
  /// Creates a new Grafana Faro configuration.
  ///
  /// [enabled] - Whether Grafana Faro is enabled.
  /// [endpoint] - The Grafana Faro endpoint URL.
  /// [appName] - The application name.
  /// [appVersion] - The application version.
  /// [environment] - The environment name.
  /// [apiKey] - The Grafana Faro API key.
  /// [namespace] - The namespace for events.
  /// [platform] - The platform identifier.
  /// [httpTrackingEnable] - Whether to enable HTTP tracking.
  /// [httpOverrides] - Optional HTTP overrides for tracking.
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

  /// The Grafana Faro endpoint URL.
  final String endpoint;

  /// The application name.
  final String appName;

  /// The application version.
  final String appVersion;

  /// The environment name.
  final String environment;

  /// The Grafana Faro API key.
  final String apiKey;

  /// The namespace for events.
  final String namespace;

  /// The platform identifier.
  final String platform;

  /// Optional HTTP overrides for tracking.
  final HttpOverrides? httpOverrides;

  /// Whether to enable HTTP tracking.
  final bool httpTrackingEnable;

  @override
  String toString() =>
      'EngineFaroConfig(enabled: $enabled, endpoint: $endpoint, appName: $appName, appVersion: $appVersion, environment: $environment, apiKey: ****, namespace: $namespace, platform: $platform)';
}
