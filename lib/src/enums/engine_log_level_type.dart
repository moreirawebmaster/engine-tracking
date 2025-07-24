/// Log level types for Engine Tracking logging and analytics.
///
/// Defines the severity of log messages and events.
enum EngineLogLevelType {
  /// No logging.
  none('NONE', 0),

  /// Debug level logging.
  debug('DEBUG', 100),

  /// Informational logging.
  info('INFO', 800),

  /// Warning level logging.
  warning('WARNING', 900),

  /// Error level logging.
  error('ERROR', 1000),

  /// Fatal error logging.
  fatal('FATAL', 1200),

  /// Verbose logging.
  verbose('VERBOSE', 1600);

  /// Creates a new log level type.
  const EngineLogLevelType(this.name, this.value);

  /// Creates a log level type from its name.
  factory EngineLogLevelType.fromName(final String name) =>
      EngineLogLevelType.values.firstWhere((final e) => e.name == name, orElse: () => EngineLogLevelType.debug);

  /// Creates a log level type from its value.
  factory EngineLogLevelType.fromValue(final int value) =>
      EngineLogLevelType.values.firstWhere((final e) => e.value == value, orElse: () => EngineLogLevelType.debug);

  /// The name of the log level.
  final String name;

  /// The numeric value of the log level.
  final int value;
}
