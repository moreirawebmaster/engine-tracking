import 'package:engine_tracking/src/logging/engine_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineLog', () {
    group('Debug Level', () {
      test('should log debug message', () async {
        expect(() => EngineLog.debug('Debug message'), returnsNormally);
      });

      test('should log debug message with data', () async {
        expect(() => EngineLog.debug('Debug message', data: {'key': 'value'}), returnsNormally);
      });

      test('should log debug message with error', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(() => EngineLog.debug('Debug message', error: error, stackTrace: stackTrace), returnsNormally);
      });

      test('should log debug message with all parameters', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(
          () => EngineLog.debug('Debug message', data: {'key': 'value'}, error: error, stackTrace: stackTrace),
          returnsNormally,
        );
      });
    });

    group('Info Level', () {
      test('should log info message', () async {
        expect(() => EngineLog.info('Info message'), returnsNormally);
      });

      test('should log info message with data', () async {
        expect(() => EngineLog.info('Info message', data: {'key': 'value'}), returnsNormally);
      });

      test('should log info message with error', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(() => EngineLog.info('Info message', error: error, stackTrace: stackTrace), returnsNormally);
      });

      test('should log info message with all parameters', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(
          () => EngineLog.info('Info message', data: {'key': 'value'}, error: error, stackTrace: stackTrace),
          returnsNormally,
        );
      });
    });

    group('Warning Level', () {
      test('should log warning message', () async {
        expect(() => EngineLog.warning('Warning message'), returnsNormally);
      });

      test('should log warning message with data', () async {
        expect(() => EngineLog.warning('Warning message', data: {'key': 'value'}), returnsNormally);
      });

      test('should log warning message with error', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(() => EngineLog.warning('Warning message', error: error, stackTrace: stackTrace), returnsNormally);
      });

      test('should log warning message with all parameters', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(
          () => EngineLog.warning('Warning message', data: {'key': 'value'}, error: error, stackTrace: stackTrace),
          returnsNormally,
        );
      });
    });

    group('Error Level', () {
      test('should log error message', () async {
        expect(() => EngineLog.error('Error message'), returnsNormally);
      });

      test('should log error message with data', () async {
        expect(() => EngineLog.error('Error message', data: {'key': 'value'}), returnsNormally);
      });

      test('should log error message with error', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(() => EngineLog.error('Error message', error: error, stackTrace: stackTrace), returnsNormally);
      });

      test('should log error message with all parameters', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(
          () => EngineLog.error('Error message', data: {'key': 'value'}, error: error, stackTrace: stackTrace),
          returnsNormally,
        );
      });
    });

    group('Fatal Level', () {
      test('should log fatal message', () async {
        expect(() => EngineLog.fatal('Fatal message'), returnsNormally);
      });

      test('should log fatal message with data', () async {
        expect(() => EngineLog.fatal('Fatal message', data: {'key': 'value'}), returnsNormally);
      });

      test('should log fatal message with error', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(() => EngineLog.fatal('Fatal message', error: error, stackTrace: stackTrace), returnsNormally);
      });

      test('should log fatal message with all parameters', () async {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        expect(
          () => EngineLog.fatal('Fatal message', data: {'key': 'value'}, error: error, stackTrace: stackTrace),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle empty message', () async {
        expect(() => EngineLog.info(''), returnsNormally);
      });

      test('should handle empty data map', () async {
        expect(() => EngineLog.info('Message', data: {}), returnsNormally);
      });

      test('should handle complex data structures', () async {
        final complexData = {
          'string': 'value',
          'number': 42,
          'boolean': true,
          'list': [1, 2, 3],
          'nested': {'key': 'value'},
        };
        expect(() => EngineLog.info('Message', data: complexData), returnsNormally);
      });

      test('should handle very long messages', () async {
        final longMessage = 'A' * 1000;
        expect(() => EngineLog.info(longMessage), returnsNormally);
      });

      test('should handle log name parameter', () async {
        expect(() => EngineLog.info('Message', logName: 'CUSTOM_LOG'), returnsNormally);
      });
    });
  });
}
