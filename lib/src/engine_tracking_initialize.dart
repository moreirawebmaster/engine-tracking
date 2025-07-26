import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';

/// Central initializer for Engine Tracking services
///
/// Provides methods to initialize analytics and bug tracking services
/// together or individually with adapters, models, or default configurations.
class EngineTrackingInitialize {
  EngineTrackingInitialize._();

  static void _initEngineHttp(final EngineHttpTrackingModel? httpTrackingModel) {
    if (httpTrackingModel != null) {
      EngineHttpTracking.initWithModel(httpTrackingModel, preserveExisting: true);
    }
  }

  /// Initialize tracking services with custom adapters
  ///
  /// [analyticsAdapters] List of analytics adapters to initialize.
  /// Can be null to skip analytics initialization.
  ///
  /// [bugTrackingAdapters] List of bug tracking adapters to initialize.
  /// Can be null to skip bug tracking initialization.
  ///
  /// [httpTrackingModel] HTTP tracking model.
  /// Can be null to skip HTTP tracking initialization.
  static Future<void> initWithAdapters({
    final List<IEngineAnalyticsAdapter>? analyticsAdapters,
    final List<IEngineBugTrackingAdapter>? bugTrackingAdapters,
    final EngineHttpTrackingModel? httpTrackingModel,
  }) async {
    final futures = <Future<void>>[];

    if (analyticsAdapters != null) {
      futures.add(EngineAnalytics.init(analyticsAdapters));
    }

    if (bugTrackingAdapters != null) {
      futures.add(EngineBugTracking.init(bugTrackingAdapters));
    }

    await Future.wait(futures);

    _initEngineHttp(httpTrackingModel);
  }

  /// Initialize tracking services with configuration models
  ///
  /// [analyticsModel] Analytics configuration model.
  /// Can be null to skip analytics initialization.
  ///
  /// [bugTrackingModel] Bug tracking configuration model.
  /// Can be null to skip bug tracking initialization.
  ///
  /// [httpTrackingModel] HTTP tracking model.
  /// Can be null to skip HTTP tracking initialization.
  static Future<void> initWithModels({
    final EngineAnalyticsModel? analyticsModel,
    final EngineBugTrackingModel? bugTrackingModel,
    final EngineHttpTrackingModel? httpTrackingModel,
  }) async {
    await Future.wait([
      if (analyticsModel != null) EngineAnalytics.initWithModel(analyticsModel),
      if (bugTrackingModel != null) EngineBugTracking.initWithModel(bugTrackingModel),
    ]);

    _initEngineHttp(httpTrackingModel);
  }

  /// Initialize both services with default disabled configurations
  static Future<void> initWithDefaults() async {
    await initWithModels(
      analyticsModel: EngineAnalyticsModelDefault(),
      bugTrackingModel: EngineBugTrackingModelDefault(),
      httpTrackingModel: const EngineHttpTrackingModelDefault(),
    );
  }

  /// Dispose all initialized tracking services
  static Future<void> dispose() async {
    await Future.wait([
      EngineAnalytics.dispose(),
      EngineBugTracking.dispose(),
    ]);

    // Disable HTTP tracking
    EngineHttpTracking.disable();
  }

  /// Returns true if both analytics and bug tracking are initialized
  static bool get isInitialized => EngineAnalytics.isInitialized && EngineBugTracking.isInitialized;

  /// Returns true if at least one service is enabled
  static bool get isEnabled => EngineAnalytics.isEnabled || EngineBugTracking.isEnabled || EngineHttpTracking.isEnabled;
}
