/// Base interface for all Engine Tracking configuration classes.
///
/// All configuration classes in the Engine Tracking library must implement
/// this interface to ensure they have the basic enabled/disabled state.
///
/// Example:
/// ```dart
/// class MyCustomConfig implements IEngineConfig {
///   MyCustomConfig({required this.enabled, this.apiKey});
///
///   @override
///   final bool enabled;
///
///   final String? apiKey;
/// }
/// ```
abstract class IEngineConfig {
  /// Creates a new configuration instance.
  ///
  /// [enabled] - Whether this configuration is enabled and should be used.
  IEngineConfig({required this.enabled});

  /// Whether this configuration is enabled and should be used.
  ///
  /// When false, the associated service or adapter will not be initialized
  /// or used for tracking operations.
  final bool enabled;
}
