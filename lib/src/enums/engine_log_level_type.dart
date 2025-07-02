enum EngineLogLevelType {
  none('NONE', 0),
  debug('DEBUG', 100),
  info('INFO', 800),
  warning('WARNING', 900),
  error('ERROR', 1000),
  fatal('FATAL', 1200),
  verbose('VERBOSE', 1600);

  final String name;
  final int value;

  const EngineLogLevelType(this.name, this.value);
  factory EngineLogLevelType.fromName(final String name) =>
      EngineLogLevelType.values.firstWhere((final e) => e.name == name, orElse: () => EngineLogLevelType.debug);

  factory EngineLogLevelType.fromValue(final int value) =>
      EngineLogLevelType.values.firstWhere((final e) => e.value == value, orElse: () => EngineLogLevelType.debug);
}
