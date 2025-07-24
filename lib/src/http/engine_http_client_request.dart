import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';

/// Internal HTTP request wrapper that handles logging
class EngineHttpClientRequest implements HttpClientRequest {
  EngineHttpClientRequest(
    this._inner, {
    required this.method,
    required this.uri,
    required this.enableRequestLogging,
    required this.enableResponseLogging,
    required this.enableTimingLogging,
    required this.enableHeaderLogging,
    required this.enableBodyLogging,
    required this.maxBodyLogLength,
    required this.logName,
    required this.ignoreDomains,
  }) {
    _startTime = DateTime.now();
    unawaited(_logRequest());
  }

  final HttpClientRequest _inner;
  @override
  final String method;
  @override
  final Uri uri;
  final bool enableRequestLogging;
  final bool enableResponseLogging;
  final bool enableTimingLogging;
  final bool enableHeaderLogging;
  final bool enableBodyLogging;
  final int maxBodyLogLength;
  final String logName;
  final List<String> ignoreDomains;

  late final DateTime _startTime;
  final List<int> _requestBody = [];

  Future<void> _logRequest() async {
    if (!enableRequestLogging) return;

    if (ignoreDomains.any((final item) => uri.host.contains(item))) return;

    final requestData = <String, dynamic>{
      'method': method,
      'url': uri.toString(),
      'host': uri.host,
      'path': uri.path,
      'timestamp': _startTime.toIso8601String(),
    };

    if (enableHeaderLogging) {
      final headersMap = <String, String>{};
      _inner.headers.forEach((final String name, final List<String> values) {
        headersMap[name] = values.join(', ');
      });
      requestData['headers'] = headersMap;
    }

    await EngineLog.debug('HTTP Request Started', logName: logName, data: requestData);
  }

  Future<void> _logResponse(final HttpClientResponse response) async {
    if (!enableResponseLogging) return;

    if (ignoreDomains.any((final item) => uri.host.contains(item))) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);

    final responseData = <String, dynamic>{
      'method': method,
      'url': uri.toString(),
      'status_code': response.statusCode,
      'reason_phrase': response.reasonPhrase,
      'content_length': response.contentLength,
      'timestamp': endTime.toIso8601String(),
    };

    if (enableTimingLogging) {
      responseData['duration_ms'] = duration.inMilliseconds;
      responseData['start_time'] = _startTime.toIso8601String();
      responseData['end_time'] = endTime.toIso8601String();
    }

    if (enableHeaderLogging) {
      final responseHeadersMap = <String, String>{};
      response.headers.forEach((final String name, final List<String> values) {
        responseHeadersMap[name] = values.join(', ');
      });
      responseData['response_headers'] = responseHeadersMap;
    }

    if (enableBodyLogging && _requestBody.isNotEmpty) {
      final bodyString = String.fromCharCodes(_requestBody);
      responseData['request_body'] = bodyString.length > maxBodyLogLength
          ? '${bodyString.substring(0, maxBodyLogLength)}...[truncated]'
          : bodyString;
    }

    final message = response.statusCode >= 400 ? 'HTTP Request Failed' : 'HTTP Request Completed';

    if (response.statusCode >= 400) {
      await EngineLog.error(message, logName: logName, data: responseData);
    } else {
      await EngineLog.debug(message, logName: logName, data: responseData);
    }
  }

  @override
  Future<HttpClientResponse> close() async {
    final response = await _inner.close();
    await _logResponse(response);
    return response;
  }

  @override
  void add(final List<int> data) {
    if (enableBodyLogging) {
      _requestBody.addAll(data);
    }
    _inner.add(data);
  }

  @override
  void addError(final Object error, [final StackTrace? stackTrace]) {
    unawaited(
      EngineLog.error(
        'HTTP Request Error',
        logName: logName,
        error: error,
        stackTrace: stackTrace,
        data: {'method': method, 'url': uri.toString(), 'timestamp': DateTime.now().toIso8601String()},
      ),
    );
    _inner.addError(error, stackTrace);
  }

  // Delegate all other properties and methods to the inner request
  @override
  Encoding get encoding => _inner.encoding;

  @override
  set encoding(final Encoding value) => _inner.encoding = value;

  @override
  HttpHeaders get headers => _inner.headers;

  @override
  HttpConnectionInfo? get connectionInfo => _inner.connectionInfo;

  @override
  List<Cookie> get cookies => _inner.cookies;

  @override
  Future<HttpClientResponse> get done => _inner.done;

  @override
  bool get followRedirects => _inner.followRedirects;

  @override
  set followRedirects(final bool value) => _inner.followRedirects = value;

  @override
  int get maxRedirects => _inner.maxRedirects;

  @override
  set maxRedirects(final int value) => _inner.maxRedirects = value;

  @override
  bool get persistentConnection => _inner.persistentConnection;

  @override
  set persistentConnection(final bool value) => _inner.persistentConnection = value;

  @override
  Future<void> flush() => _inner.flush();

  @override
  void write(final Object? object) => _inner.write(object);

  @override
  void writeAll(final Iterable<Object?> objects, [final String separator = '']) => _inner.writeAll(objects, separator);

  @override
  void writeCharCode(final int charCode) => _inner.writeCharCode(charCode);

  @override
  void writeln([final Object? object = '']) => _inner.writeln(object);

  @override
  bool get bufferOutput => _inner.bufferOutput;

  @override
  set bufferOutput(final bool value) => _inner.bufferOutput = value;

  @override
  int get contentLength => _inner.contentLength;

  @override
  set contentLength(final int value) => _inner.contentLength = value;

  @override
  void abort([final Object? exception, final StackTrace? stackTrace]) => _inner.abort(exception, stackTrace);

  @override
  Future addStream(final Stream<List<int>> stream) => _inner.addStream(stream);
}
