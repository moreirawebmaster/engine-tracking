import 'dart:math';

class EngineSession {
  static EngineSession? _instance;
  static EngineSession get instance => _instance ??= EngineSession._();

  EngineSession._();

  String? _sessionId;

  // Getter público - único ponto de acesso
  String get sessionId => _sessionId ??= _generateUUID();

  // Gerador de string hexadecimal privado
  String _generateHex(final int length) {
    final random = Random();
    const chars = '0123456789abcdef';
    return List.generate(length, (final index) => chars[random.nextInt(chars.length)]).join();
  }

  // Gerador UUID v4 padrão
  String _generateUUID() {
    final random = Random();

    // UUID v4 formato: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    // Onde:
    // - 13º caractere é sempre "4" (versão)
    // - 17º caractere é sempre "8", "9", "a" ou "b" (variant)

    final part1 = _generateHex(8);
    final part2 = _generateHex(4);
    final part3 = '4${_generateHex(3)}'; // Versão 4

    // Para a parte 4, primeiro caractere deve ser 8, 9, a ou b
    const variantChars = '89ab';
    final variantChar = variantChars[random.nextInt(variantChars.length)];
    final part4 = '$variantChar${_generateHex(3)}';

    final part5 = _generateHex(12);

    return '$part1-$part2-$part3-$part4-$part5';
  }

  // Método para enriquecer eventos automaticamente
  Map<String, dynamic>? enrichWithSessionId(final Map<String, dynamic>? data) {
    final enriched = <String, dynamic>{...?data};
    enriched['session_id'] = sessionId;
    return enriched;
  }

  // Método para reset - usado apenas em testes
  static void resetForTesting() {
    _instance = null;
  }
}
