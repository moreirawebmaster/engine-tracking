import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

/// Engine Widget that automatically integrates with initialized tracking services
///
/// This widget automatically detects if Microsoft Clarity has been initialized
/// through the EngineAnalytics system and wraps the app with ClarityWidget if needed.
/// No manual configuration is required - it uses the configuration from the
/// initialized Clarity adapter.
///
/// The widget will:
/// 1. Check if EngineAnalytics has been initialized with a Clarity adapter
/// 2. If Clarity is enabled and configured, wrap the app with ClarityWidget
/// 3. If Clarity is not available or disabled, return the app unchanged
///
/// Example usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize analytics with Clarity configuration
///   final analyticsModel = EngineAnalyticsModel(
///     clarityConfig: EngineClarityConfig(
///       enabled: true,
///       projectId: 'your-project-id',
///     ),
///     // ... other configs
///   );
///
///   await EngineAnalytics.initWithModel(analyticsModel);
///
///   // EngineWidget will automatically detect and use Clarity if is initialize
///   runApp(EngineWidget(app: MyApp()));
/// }
/// ```
class EngineWidget extends StatelessWidget {
  /// Creates a new EngineWidget
  ///
  /// [app] The main application widget to wrap
  /// [key] The widget key
  const EngineWidget({
    required this.app,
    super.key,
  });

  /// The main application widget to wrap
  final Widget app;

  @override
  Widget build(final BuildContext context) {
    // Check if Clarity has been initialized through EngineAnalytics
    final clarityConfig = EngineAnalytics.getConfig<EngineClarityConfig, EngineClarityAdapter>();

    if (clarityConfig != null && clarityConfig.enabled) {
      return ClarityWidget(
        app: app,
        clarityConfig: ClarityConfig(
          projectId: clarityConfig.projectId,

          logLevel: _mapLogLevel(clarityConfig.level),
        ),
      );
    }

    return app;
  }

  LogLevel _mapLogLevel(final EngineLogLevelType level) {
    switch (level) {
      case EngineLogLevelType.verbose:
      case EngineLogLevelType.fatal:
        return LogLevel.Verbose;
      case EngineLogLevelType.debug:
        return LogLevel.Debug;
      case EngineLogLevelType.info:
        return LogLevel.Info;
      case EngineLogLevelType.warning:
        return LogLevel.Warn;
      case EngineLogLevelType.error:
        return LogLevel.Error;
      case EngineLogLevelType.none:
        return LogLevel.None;
    }
  }
}
