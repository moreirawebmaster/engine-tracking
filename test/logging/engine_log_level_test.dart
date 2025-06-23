import 'package:engine_tracking/src/enums/engine_log_level_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineLogLevel', () {
    test('should have correct values', () {
      expect(EngineLogLevelType.debug.value, equals(500));
      expect(EngineLogLevelType.info.value, equals(800));
      expect(EngineLogLevelType.warning.value, equals(900));
      expect(EngineLogLevelType.error.value, equals(1000));
      expect(EngineLogLevelType.fatal.value, equals(1200));
    });

    test('should have correct names', () {
      expect(EngineLogLevelType.debug.name, equals('DEBUG'));
      expect(EngineLogLevelType.info.name, equals('INFO'));
      expect(EngineLogLevelType.warning.name, equals('WARNING'));
      expect(EngineLogLevelType.error.name, equals('ERROR'));
      expect(EngineLogLevelType.fatal.name, equals('FATAL'));
    });

    test('should have correct string representations', () {
      expect(EngineLogLevelType.debug.toString(), contains('debug'));
      expect(EngineLogLevelType.info.toString(), contains('info'));
      expect(EngineLogLevelType.warning.toString(), contains('warning'));
      expect(EngineLogLevelType.error.toString(), contains('error'));
      expect(EngineLogLevelType.fatal.toString(), contains('fatal'));
    });

    test('should have correct hierarchy', () {
      expect(EngineLogLevelType.debug.value < EngineLogLevelType.info.value, isTrue);
      expect(EngineLogLevelType.info.value < EngineLogLevelType.warning.value, isTrue);
      expect(EngineLogLevelType.warning.value < EngineLogLevelType.error.value, isTrue);
      expect(EngineLogLevelType.error.value < EngineLogLevelType.fatal.value, isTrue);
    });

    test('should be enumerable', () {
      const levels = EngineLogLevelType.values;
      expect(levels.length, equals(5));
      expect(levels, contains(EngineLogLevelType.debug));
      expect(levels, contains(EngineLogLevelType.info));
      expect(levels, contains(EngineLogLevelType.warning));
      expect(levels, contains(EngineLogLevelType.error));
      expect(levels, contains(EngineLogLevelType.fatal));
    });

    test('should be comparable', () {
      expect(EngineLogLevelType.debug == EngineLogLevelType.debug, isTrue);
      expect(EngineLogLevelType.debug == EngineLogLevelType.info, isFalse);
      expect(EngineLogLevelType.debug != EngineLogLevelType.info, isTrue);
    });

    test('should have unique values', () {
      final values = EngineLogLevelType.values.map((final e) => e.value).toSet();
      expect(values.length, equals(EngineLogLevelType.values.length));
    });

    test('should have unique names', () {
      final names = EngineLogLevelType.values.map((final e) => e.name).toSet();
      expect(names.length, equals(EngineLogLevelType.values.length));
    });
  });
}
