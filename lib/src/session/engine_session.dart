import 'dart:math';

/// Session management for Engine Tracking
///
/// This class provides session management functionality including
/// session ID generation and enrichment of data with session information.
class EngineSession {
  EngineSession._();

  /// Singleton instance of EngineSession
  static EngineSession? _i;

  /// Returns the singleton instance of EngineSession
  static EngineSession get instance => _i ??= EngineSession._();

  /// Current session ID
  String? _sessionId;

  /// Returns the current session ID, generating a new one if needed
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

  /// Enriches data with the current session ID
  ///
  /// This method adds the current session ID to the provided data map,
  /// creating a new map if the input is null.
  ///
  /// [data] The data map to enrich with session ID
  /// Returns a new map containing the original data plus session ID
  Map<String, dynamic>? enrichWithSessionId(final Map<String, dynamic>? data) {
    final enriched = <String, dynamic>{...?data};
    enriched['session_id'] = sessionId;
    return enriched;
  }

  /// Resets the singleton instance for testing purposes
  static void resetForTesting() {
    _i = null;
  }
}
