import 'dart:io';

import 'package:engine_tracking/src/http/engine_http_client_request.dart';

/// Internal HTTP client wrapper that handles the actual logging
class EngineHttpClient implements HttpClient {
  EngineHttpClient(
    this._inner, {
    required this.enableRequestLogging,
    required this.enableResponseLogging,
    required this.enableTimingLogging,
    required this.enableHeaderLogging,
    required this.enableBodyLogging,
    required this.maxBodyLogLength,
    required this.logName,
    required this.ignoreDomains,
  });

  final HttpClient _inner;
  final bool enableRequestLogging;
  final bool enableResponseLogging;
  final bool enableTimingLogging;
  final bool enableHeaderLogging;
  final bool enableBodyLogging;
  final int maxBodyLogLength;
  final String logName;
  final List<String> ignoreDomains;

  @override
  Future<HttpClientRequest> open(final String method, final String host, final int port, final String path) async {
    final request = await _inner.open(method, host, port, path);
    return _wrapRequest(request, method, Uri(scheme: 'https', host: host, port: port, path: path));
  }

  @override
  Future<HttpClientRequest> openUrl(final String method, final Uri url) async {
    final request = await _inner.openUrl(method, url);
    return _wrapRequest(request, method, url);
  }

  @override
  Future<HttpClientRequest> get(final String host, final int port, final String path) => open('GET', host, port, path);

  @override
  Future<HttpClientRequest> getUrl(final Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> post(final String host, final int port, final String path) =>
      open('POST', host, port, path);

  @override
  Future<HttpClientRequest> postUrl(final Uri url) => openUrl('POST', url);

  @override
  Future<HttpClientRequest> put(final String host, final int port, final String path) => open('PUT', host, port, path);

  @override
  Future<HttpClientRequest> putUrl(final Uri url) => openUrl('PUT', url);

  @override
  Future<HttpClientRequest> delete(final String host, final int port, final String path) =>
      open('DELETE', host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(final Uri url) => openUrl('DELETE', url);

  @override
  Future<HttpClientRequest> patch(final String host, final int port, final String path) =>
      open('PATCH', host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(final Uri url) => openUrl('PATCH', url);

  @override
  Future<HttpClientRequest> head(final String host, final int port, final String path) =>
      open('HEAD', host, port, path);

  @override
  Future<HttpClientRequest> headUrl(final Uri url) => openUrl('HEAD', url);

  HttpClientRequest _wrapRequest(final HttpClientRequest request, final String method, final Uri uri) =>
      EngineHttpClientRequest(
        request,
        method: method,
        uri: uri,
        enableRequestLogging: enableRequestLogging,
        enableResponseLogging: enableResponseLogging,
        enableTimingLogging: enableTimingLogging,
        enableHeaderLogging: enableHeaderLogging,
        enableBodyLogging: enableBodyLogging,
        maxBodyLogLength: maxBodyLogLength,
        logName: logName,
        ignoreDomains: ignoreDomains,
      );

  // Delegate all other properties and methods to the inner client
  @override
  Duration? get connectionTimeout => _inner.connectionTimeout;

  @override
  set connectionTimeout(final Duration? value) => _inner.connectionTimeout = value;

  @override
  Duration get idleTimeout => _inner.idleTimeout;

  @override
  set idleTimeout(final Duration value) => _inner.idleTimeout = value;

  @override
  int? get maxConnectionsPerHost => _inner.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(final int? value) => _inner.maxConnectionsPerHost = value;

  @override
  bool get autoUncompress => _inner.autoUncompress;

  @override
  set autoUncompress(final bool value) => _inner.autoUncompress = value;

  @override
  String? get userAgent => _inner.userAgent;

  @override
  set userAgent(final String? value) => _inner.userAgent = value;

  @override
  void addCredentials(final Uri url, final String realm, final HttpClientCredentials credentials) =>
      _inner.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(
    final String host,
    final int port,
    final String realm,
    final HttpClientCredentials credentials,
  ) => _inner.addProxyCredentials(host, port, realm, credentials);

  @override
  set authenticate(final Future<bool> Function(Uri url, String scheme, String? realm)? f) => _inner.authenticate = f;

  @override
  set authenticateProxy(final Future<bool> Function(String host, int port, String scheme, String? realm)? f) =>
      _inner.authenticateProxy = f;

  @override
  set badCertificateCallback(final bool Function(X509Certificate cert, String host, int port)? callback) =>
      _inner.badCertificateCallback = callback;

  @override
  set connectionFactory(final Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) =>
      _inner.connectionFactory = f;

  @override
  set keyLog(final void Function(String line)? callback) => _inner.keyLog = callback;

  @override
  void close({final bool force = false}) => _inner.close(force: force);

  @override
  set findProxy(final String Function(Uri url)? f) => _inner.findProxy = f;
}
