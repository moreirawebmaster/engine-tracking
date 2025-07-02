import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineSession', () {
    setUp(EngineSession.resetForTesting);

    test('should generate unique session IDs', () {
      final session1 = EngineSession.instance.sessionId;

      // Reset instance para simular nova abertura
      EngineSession.resetForTesting();

      final session2 = EngineSession.instance.sessionId;
      expect(session1, isNot(equals(session2)));
    });

    test('should generate valid UUID v4 format', () {
      final sessionId = EngineSession.instance.sessionId;

      // Deve ter formato UUID v4: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
      final uuidv4Regex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
      expect(uuidv4Regex.hasMatch(sessionId), isTrue);

      final parts = sessionId.split('-');
      expect(parts.length, equals(5));

      // Verificar partes específicas do UUID v4
      expect(parts[0].length, equals(8)); // xxxxxxxx
      expect(parts[1].length, equals(4)); // xxxx
      expect(parts[2].length, equals(4)); // 4xxx
      expect(parts[3].length, equals(4)); // yxxx
      expect(parts[4].length, equals(12)); // xxxxxxxxxxxx

      // Verificar versão 4
      expect(parts[2][0], equals('4'));

      // Verificar variant (primeiro caractere da parte 4 deve ser 8, 9, a ou b)
      expect(['8', '9', 'a', 'b'].contains(parts[3][0]), isTrue);
    });

    test('should use only hexadecimal characters', () {
      final sessionId = EngineSession.instance.sessionId;

      // Remove hífens e verifica se todos os caracteres são hexadecimais
      final hexOnly = sessionId.replaceAll('-', '');
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(hexOnly), isTrue);
      expect(hexOnly.length, equals(32)); // UUID v4 tem 32 caracteres hex
    });

    test('should return same session ID for same instance', () {
      final session1 = EngineSession.instance.sessionId;
      final session2 = EngineSession.instance.sessionId;

      expect(session1, equals(session2));
    });

    test('enrichWithSessionId should add session_id to data', () {
      final originalData = {'test': 'value', 'number': 42};
      final enriched = EngineSession.instance.enrichWithSessionId(originalData);

      expect(enriched!['session_id'], isNotNull);
      expect(enriched['test'], equals('value'));
      expect(enriched['number'], equals(42));
    });

    test('enrichWithSessionId should work with null data', () {
      final enriched = EngineSession.instance.enrichWithSessionId(null);

      expect(enriched!['session_id'], isNotNull);
      expect(enriched.length, equals(1));
    });

    test('enrichWithSessionId should not override existing session_id', () {
      final originalData = {'session_id': 'existing-id', 'test': 'value'};
      final enriched = EngineSession.instance.enrichWithSessionId(originalData);

      // Deve manter o session_id gerado automaticamente
      expect(enriched!['session_id'], isNot(equals('existing-id')));
      expect(enriched['test'], equals('value'));
    });

    test('should generate multiple unique UUID v4s', () {
      final sessionIds = <String>{};

      for (var i = 0; i < 100; i++) {
        EngineSession.resetForTesting();
        final sessionId = EngineSession.instance.sessionId;
        sessionIds.add(sessionId);

        // Verificar formato UUID v4 para cada um
        final uuidv4Regex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
        expect(uuidv4Regex.hasMatch(sessionId), isTrue);
      }

      // Todos devem ser únicos
      expect(sessionIds.length, equals(100));
    });

    test('should have correct UUID v4 structure', () {
      final sessionId = EngineSession.instance.sessionId;
      final parts = sessionId.split('-');

      // Verificar estrutura específica do UUID v4
      expect(parts.length, equals(5));

      // Parte 1: 8 caracteres hex
      expect(RegExp(r'^[0-9a-f]{8}$').hasMatch(parts[0]), isTrue);

      // Parte 2: 4 caracteres hex
      expect(RegExp(r'^[0-9a-f]{4}$').hasMatch(parts[1]), isTrue);

      // Parte 3: 4 caracteres hex começando com "4"
      expect(RegExp(r'^4[0-9a-f]{3}$').hasMatch(parts[2]), isTrue);

      // Parte 4: 4 caracteres hex começando com 8, 9, a ou b
      expect(RegExp(r'^[89ab][0-9a-f]{3}$').hasMatch(parts[3]), isTrue);

      // Parte 5: 12 caracteres hex
      expect(RegExp(r'^[0-9a-f]{12}$').hasMatch(parts[4]), isTrue);
    });
  });
}
