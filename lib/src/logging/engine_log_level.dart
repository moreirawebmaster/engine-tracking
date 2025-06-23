enum EngineLogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

extension EngineLogLevelExtension on EngineLogLevel {
  String get name {
    switch (this) {
      case EngineLogLevel.debug:
        return 'DEBUG';
      case EngineLogLevel.info:
        return 'INFO';
      case EngineLogLevel.warning:
        return 'WARNING';
      case EngineLogLevel.error:
        return 'ERROR';
      case EngineLogLevel.fatal:
        return 'FATAL';
    }
  }

  int get value {
    switch (this) {
      case EngineLogLevel.debug:
        return 500;
      case EngineLogLevel.info:
        return 800;
      case EngineLogLevel.warning:
        return 900;
      case EngineLogLevel.error:
        return 1000;
      case EngineLogLevel.fatal:
        return 1200;
    }
  }
}
