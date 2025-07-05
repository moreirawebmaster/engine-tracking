import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';

/// Central initializer for Engine Tracking services
///
/// Provides methods to initialize analytics and bug tracking services
/// together or individually with adapters, models, or default configurations.
class EngineTrackingInitialize {
  EngineTrackingInitialize._();

  /// Initialize tracking services with custom adapters
  ///
  /// [analyticsAdapters] List of analytics adapters to initialize.
  /// Can be null to skip analytics initialization.
  ///
  /// [bugTrackingAdapters] List of bug tracking adapters to initialize.
  /// Can be null to skip bug tracking initialization.
  static Future<void> initWithAdapters({
    final List<IEngineAnalyticsAdapter>? analyticsAdapters,
    final List<IEngineBugTrackingAdapter>? bugTrackingAdapters,
  }) async {
    final futures = <Future<void>>[];

    if (analyticsAdapters != null) {
      futures.add(EngineAnalytics.init(analyticsAdapters));
    }

    if (bugTrackingAdapters != null) {
      futures.add(EngineBugTracking.init(bugTrackingAdapters));
    }

    await Future.wait(futures);
  }

  /// Initialize tracking services with configuration models
  ///
  /// [analyticsModel] Analytics configuration model.
  /// Can be null to skip analytics initialization.
  ///
  /// [bugTrackingModel] Bug tracking configuration model.
  /// Can be null to skip bug tracking initialization.
  static Future<void> initWithModels({
    final EngineAnalyticsModel? analyticsModel,
    final EngineBugTrackingModel? bugTrackingModel,
  }) async {
    final futures = <Future<void>>[];

    if (analyticsModel != null) {
      futures.add(EngineAnalytics.initWithModel(analyticsModel));
    }

    if (bugTrackingModel != null) {
      futures.add(EngineBugTracking.initWithModel(bugTrackingModel));
    }

    await Future.wait(futures);
  }

  /// Initialize both services with default disabled configurations
  static Future<void> initWithDefaults() async {
    await initWithModels(
      analyticsModel: EngineAnalyticsModelDefault(),
      bugTrackingModel: EngineBugTrackingModelDefault(),
    );
  }

  /// Dispose all initialized tracking services
  static Future<void> dispose() async {
    await Future.wait([
      EngineAnalytics.dispose(),
      EngineBugTracking.dispose(),
    ]);
  }

  /// Returns true if both analytics and bug tracking are initialized
  static bool get isInitialized => EngineAnalytics.isInitialized && EngineBugTracking.isInitialized;

  /// Returns true if at least one service is enabled
  static bool get isEnabled => EngineAnalytics.isEnabled || EngineBugTracking.isEnabled;
}
