import 'dart:math';

class EngineSession {
  static EngineSession? _instance;
  static EngineSession get instance => _instance ??= EngineSession._();

  EngineSession._();

  String? _sessionId;

  String get sessionId => _sessionId ??= _generateUUID();

  String _generateHex(final int length) {
    final random = Random();
    const chars = '0123456789abcdef';
    return List.generate(length, (final index) => chars[random.nextInt(chars.length)]).join();
  }

  String _generateUUID() {
    final random = Random();

    final part1 = _generateHex(8);
    final part2 = _generateHex(4);
    final part3 = '4${_generateHex(3)}';

    const variantChars = '89ab';
    final variantChar = variantChars[random.nextInt(variantChars.length)];
    final part4 = '$variantChar${_generateHex(3)}';

    final part5 = _generateHex(12);

    return '$part1-$part2-$part3-$part4-$part5';
  }

  Map<String, dynamic>? enrichWithSessionId(final Map<String, dynamic>? data) {
    final enriched = <String, dynamic>{...?data};
    enriched['session_id'] = sessionId;
    return enriched;
  }

  static void resetForTesting() {
    _instance = null;
  }
}
