import 'package:engine_tracking/engine_tracking.dart';

/// Function type for filtering analytics adapters
typedef PredicateAnalytics = bool Function(IEngineAnalyticsAdapter);

/// Function type for filtering bug tracking adapters
typedef PredicateBugTracking = bool Function(IEngineBugTrackingAdapter);

/// Converts a `Map<String, dynamic>` to `Map<String, String>`
///
/// This utility function converts all values in the input map to strings
/// using their toString() method.
///
/// [map] The input map to convert
/// Returns a new map with string values, or null if input is null
Map<String, String>? convertToStringMap(final Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return map.map(
    (final key, final value) => MapEntry(key, value.toString()),
  );
}
