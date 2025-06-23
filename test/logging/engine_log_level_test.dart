import 'package:engine_tracking/src/logging/engine_log_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineLogLevel', () {
    test('should have correct values', () {
      expect(EngineLogLevel.debug.value, equals(500));
      expect(EngineLogLevel.info.value, equals(800));
      expect(EngineLogLevel.warning.value, equals(900));
      expect(EngineLogLevel.error.value, equals(1000));
      expect(EngineLogLevel.fatal.value, equals(1200));
    });

    test('should have correct names', () {
      expect(EngineLogLevel.debug.name, equals('DEBUG'));
      expect(EngineLogLevel.info.name, equals('INFO'));
      expect(EngineLogLevel.warning.name, equals('WARNING'));
      expect(EngineLogLevel.error.name, equals('ERROR'));
      expect(EngineLogLevel.fatal.name, equals('FATAL'));
    });

    test('should have correct string representations', () {
      expect(EngineLogLevel.debug.toString(), contains('debug'));
      expect(EngineLogLevel.info.toString(), contains('info'));
      expect(EngineLogLevel.warning.toString(), contains('warning'));
      expect(EngineLogLevel.error.toString(), contains('error'));
      expect(EngineLogLevel.fatal.toString(), contains('fatal'));
    });

    test('should have correct hierarchy', () {
      expect(EngineLogLevel.debug.value < EngineLogLevel.info.value, isTrue);
      expect(EngineLogLevel.info.value < EngineLogLevel.warning.value, isTrue);
      expect(EngineLogLevel.warning.value < EngineLogLevel.error.value, isTrue);
      expect(EngineLogLevel.error.value < EngineLogLevel.fatal.value, isTrue);
    });

    test('should be enumerable', () {
      const levels = EngineLogLevel.values;
      expect(levels.length, equals(5));
      expect(levels, contains(EngineLogLevel.debug));
      expect(levels, contains(EngineLogLevel.info));
      expect(levels, contains(EngineLogLevel.warning));
      expect(levels, contains(EngineLogLevel.error));
      expect(levels, contains(EngineLogLevel.fatal));
    });

    test('should be comparable', () {
      expect(EngineLogLevel.debug == EngineLogLevel.debug, isTrue);
      expect(EngineLogLevel.debug == EngineLogLevel.info, isFalse);
      expect(EngineLogLevel.debug != EngineLogLevel.info, isTrue);
    });

    test('should have unique values', () {
      final values = EngineLogLevel.values.map((final e) => e.value).toSet();
      expect(values.length, equals(EngineLogLevel.values.length));
    });

    test('should have unique names', () {
      final names = EngineLogLevel.values.map((final e) => e.name).toSet();
      expect(names.length, equals(EngineLogLevel.values.length));
    });
  });
}
