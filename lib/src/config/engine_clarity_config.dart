import 'package:engine_tracking/src/config/config.dart';
import 'package:engine_tracking/src/enums/enums.dart';

/// Configuration for Microsoft Clarity analytics integration.
///
/// Provides settings for Microsoft Clarity session recording and analytics.
class EngineClarityConfig extends IEngineConfig {
  /// Creates a new Microsoft Clarity configuration.
  ///
  /// [enabled] - Whether Microsoft Clarity is enabled.
  /// [projectId] - The Microsoft Clarity project ID.
  /// [level] - The logging level for Microsoft Clarity.
  EngineClarityConfig({
    required super.enabled,
    required this.projectId,
    this.level = EngineLogLevelType.info,
  });

  /// The Microsoft Clarity project ID.
  final String projectId;

  /// The logging level for Microsoft Clarity.
  final EngineLogLevelType level;

  @override
  String toString() => 'EngineClarityConfig(enabled: $enabled, projectId: *****)';
}
