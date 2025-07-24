import 'package:engine_tracking/src/config/config.dart';

/// Configuration for Google Cloud Logging integration.
///
/// Provides settings for Google Cloud Logging analytics and bug tracking.
class EngineGoogleLoggingConfig extends IEngineConfig {
  /// Creates a new Google Cloud Logging configuration.
  ///
  /// [enabled] - Whether Google Cloud Logging is enabled.
  /// [projectId] - The Google Cloud project ID.
  /// [logName] - The log name.
  /// [credentials] - The service account credentials as a map.
  /// [resource] - Optional monitored resource configuration.
  EngineGoogleLoggingConfig({
    required super.enabled,
    required this.projectId,
    required this.logName,
    required this.credentials,
    this.resource,
  });

  /// The Google Cloud project ID.
  final String projectId;

  /// The log name.
  final String logName;

  /// The service account credentials as a map.
  final Map<String, dynamic> credentials;

  /// Optional monitored resource configuration.
  final Map<String, dynamic>? resource;

  @override
  String toString() =>
      'EngineGoogleLoggingConfig(enabled: $enabled, projectId: $projectId, logName: $logName, credentials: ****, resource: $resource)';
}
