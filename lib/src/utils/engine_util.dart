import 'package:engine_tracking/engine_tracking.dart';

typedef PredicateAnalytics = bool Function(IEngineAnalyticsAdapter);
typedef PredicateBugTracking = bool Function(IEngineBugTrackingAdapter);

Map<String, String>? convertToStringMap(final Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return map.map(
    (final key, final value) => MapEntry(key, value.toString()),
  );
}
