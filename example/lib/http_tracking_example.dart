// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LogEntry {
  final String message;
  final DateTime timestamp;
  final LogType type;
  final Map<String, dynamic>? data;

  LogEntry({
    required this.message,
    required this.timestamp,
    required this.type,
    this.data,
  });

  String get formattedTime =>
      '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')}';
}

enum LogType { info, success, warning, error }

class HttpTrackingExample extends StatefulWidget {
  const HttpTrackingExample({super.key});

  @override
  State<HttpTrackingExample> createState() => _HttpTrackingExampleState();
}

class _HttpTrackingExampleState extends State<HttpTrackingExample> {
  String _status = 'Ready';
  final List<LogEntry> _logs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeHttpTracking());
  }

  Future<void> _initializeHttpTracking() async {
    try {
      if (!mounted) return;

      _addLog('🔄 Initializing HTTP tracking...', LogType.info);

      setState(() {
        _status = 'HTTP Tracking initialized';
        _logs.add(
          LogEntry(
            message: '✅ HTTP tracking enabled',
            timestamp: DateTime.now(),
            type: LogType.success,
          ),
        );
      });

      _addLog('🌐 Testing network connectivity...', LogType.info);

      try {
        final testResponse = await http
            .get(
              Uri.parse('https://httpbin.org/get'),
            )
            .timeout(const Duration(seconds: 5));

        if (testResponse.statusCode == 200) {
          _addLog('✅ Network connectivity confirmed', LogType.success);
        } else {
          _addLog('⚠️ Network connectivity issue: ${testResponse.statusCode}', LogType.warning);
        }
      } catch (e) {
        _addLog('⚠️ Network connectivity test failed: $e', LogType.warning);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Failed to initialize HTTP tracking';
        _logs.add(
          LogEntry(
            message: '❌ Failed to initialize: $e',
            timestamp: DateTime.now(),
            type: LogType.error,
          ),
        );
      });
    }
  }

  void _addLog(final String message, final LogType type, [final Map<String, dynamic>? data]) {
    if (!mounted) return;

    setState(() {
      _logs.add(
        LogEntry(
          message: message,
          timestamp: DateTime.now(),
          type: type,
          data: data,
        ),
      );
    });
  }

  Future<void> _makeGetRequest() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _status = 'Making GET request...';
    });

    _addLog('🔄 Starting GET request to JSONPlaceholder', LogType.info);

    try {
      final stopwatch = Stopwatch()..start();

      final response = await http
          .get(
            Uri.parse('https://httpbin.org/get'),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'EngineTracking-Example/1.0',
              'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          )
          .timeout(const Duration(seconds: 10));

      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _status = 'GET request successful';
          });
        }
        _addLog(
          '✅ GET request completed: ${response.statusCode}',
          LogType.success,
          {
            'duration_ms': stopwatch.elapsedMilliseconds,
            'content_length': response.contentLength,
            'response_headers': response.headers.length,
          },
        );
        _addLog('📄 Response origin: ${data['origin']}', LogType.info);
      } else {
        if (mounted) {
          setState(() {
            _status = 'GET request failed';
          });
        }
        _addLog('❌ GET request failed: ${response.statusCode}', LogType.error, {
          'status_code': response.statusCode,
          'reason_phrase': response.reasonPhrase,
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _status = 'GET request timeout';
        });
      }
      _addLog('⏰ GET request timeout after 10 seconds', LogType.error);
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'GET request error';
        });
      }
      _addLog('💥 GET request error: $e', LogType.error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _makePostRequest() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _status = 'Making POST request...';
    });

    _addLog('🔄 Starting POST request to httpbin.org', LogType.info);

    try {
      final requestBody = {
        'title': 'Engine Tracking Test',
        'body': 'This is a test post from Engine Tracking HTTP example',
        'userId': 1,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final stopwatch = Stopwatch()..start();
      final response = await http
          .post(
            Uri.parse('https://httpbin.org/post'),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'EngineTracking-Example/1.0',
              'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
            },
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _status = 'POST request successful';
          });
        }
        _addLog(
          '✅ POST request completed: ${response.statusCode}',
          LogType.success,
          {
            'duration_ms': stopwatch.elapsedMilliseconds,
            'content_length': response.contentLength,
            'response_headers': response.headers.length,
          },
        );
        _addLog('📄 Response origin: ${data['origin']}', LogType.info);
      } else {
        if (mounted) {
          setState(() {
            _status = 'POST request failed';
          });
        }
        _addLog('❌ POST request failed: ${response.statusCode}', LogType.error, {
          'status_code': response.statusCode,
          'reason_phrase': response.reasonPhrase,
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _status = 'POST request timeout';
        });
      }
      _addLog('⏰ POST request timeout after 10 seconds', LogType.error);
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'POST request error';
        });
      }
      _addLog('💥 POST request error: $e', LogType.error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _makeErrorRequest() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _status = 'Making request that will fail...';
    });

    _addLog('🔄 Starting request to error endpoint', LogType.warning);

    try {
      final stopwatch = Stopwatch()..start();
      final response = await http
          .get(
            Uri.parse('https://httpbin.org/status/404'),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'EngineTracking-Example/1.0',
              'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          )
          .timeout(const Duration(seconds: 10));
      stopwatch.stop();

      if (mounted) {
        setState(() {
          _status = 'Error request completed';
        });
      }
      _addLog(
        '❌ Error request completed: ${response.statusCode}',
        LogType.error,
        {
          'duration_ms': stopwatch.elapsedMilliseconds,
          'status_code': response.statusCode,
          'reason_phrase': response.reasonPhrase,
        },
      );
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _status = 'Error request timeout';
        });
      }
      _addLog('⏰ Error request timeout after 10 seconds', LogType.error);
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Error request failed';
        });
      }
      _addLog('💥 Error request failed: $e', LogType.error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testDifferentConfigs() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _status = 'Testing different configurations...';
    });

    _addLog('🔧 Testing minimal logging config', LogType.info);

    try {
      await EngineHttpTracking.withConfig(
        EngineHttpTrackingConfig(
          enabled: true,
          enableRequestLogging: true,
          enableResponseLogging: true,
          enableTimingLogging: true,
          enableHeaderLogging: false,
          enableBodyLogging: false,
          maxBodyLogLength: 500,
          logName: 'HTTP_MINIMAL_TEST',
        ),
        () async {
          await http
              .get(
                Uri.parse('https://httpbin.org/get'),
              )
              .timeout(const Duration(seconds: 10));
        },
      );

      _addLog('✅ Minimal logging config test completed', LogType.success);
      _addLog('🔧 Testing errors-only config', LogType.info);

      await EngineHttpTracking.withConfig(
        EngineHttpTrackingConfig(
          enabled: true,
          enableRequestLogging: false,
          enableResponseLogging: true,
          enableTimingLogging: true,
          enableHeaderLogging: false,
          enableBodyLogging: false,
          maxBodyLogLength: 0,
          logName: 'HTTP_ERRORS_TEST',
        ),
        () async {
          await http
              .get(
                Uri.parse('https://httpbin.org/get'),
              )
              .timeout(const Duration(seconds: 10));

          await http
              .get(
                Uri.parse('https://httpbin.org/status/500'),
              )
              .timeout(const Duration(seconds: 10));
        },
      );

      if (mounted) {
        setState(() {
          _status = 'Configuration tests completed';
        });
      }
      _addLog('✅ Errors-only config test completed', LogType.success);
    } catch (e) {
      _addLog('💥 Configuration test failed: $e', LogType.error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testMultipleRequests() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _status = 'Making multiple concurrent requests...';
    });

    _addLog('🔄 Starting 5 concurrent requests', LogType.info);

    try {
      final futures = List.generate(
        5,
        (final index) async => http
            .get(
              Uri.parse('https://httpbin.org/delay/${index + 1}'),
              headers: {
                'User-Agent': 'EngineTracking-Example/1.0',
                'X-Request-ID': 'batch_${DateTime.now().millisecondsSinceEpoch}_$index',
              },
            )
            .timeout(const Duration(seconds: 15)),
      );

      final stopwatch = Stopwatch()..start();
      final responses = await Future.wait(futures);
      stopwatch.stop();

      final successCount = responses.where((final r) => r.statusCode == 200).length;

      if (mounted) {
        setState(() {
          _status = 'Multiple requests completed';
        });
      }

      _addLog(
        '✅ Completed $successCount/5 requests successfully',
        LogType.success,
        {
          'total_duration_ms': stopwatch.elapsedMilliseconds,
          'success_rate': '${(successCount / 5 * 100).toStringAsFixed(1)}%',
        },
      );
    } catch (e) {
      _addLog('💥 Multiple requests failed: $e', LogType.error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearLogs() {
    if (!mounted) return;

    setState(() {
      _logs.clear();
      _status = 'Logs cleared';
    });
  }

  Future<void> _copyLog(final LogEntry log) async {
    final logText = _formatLogForCopy(log);
    await Clipboard.setData(ClipboardData(text: logText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log entry copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _copyAllLogs() async {
    if (_logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No logs to copy'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final allLogsText = _logs.map(_formatLogForCopy).join('\n\n');
    await Clipboard.setData(ClipboardData(text: allLogsText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_logs.length} log entries copied to clipboard'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatLogForCopy(final LogEntry log) {
    final timestamp = log.timestamp.toIso8601String();
    final type = log.type.name.toUpperCase();
    final message = log.message;

    String result = '[$timestamp] [$type] $message';

    if (log.data != null && log.data!.isNotEmpty) {
      result += '\nData: ${json.encode(log.data)}';
    }

    return result;
  }

  void _showTrackingStats() {
    final stats = EngineHttpTracking.getStats();
    unawaited(
      showDialog(
        context: context,
        builder: (final context) => AlertDialog(
          title: const Text('HTTP Tracking Stats'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...stats.entries.map(
                  (final e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            '${e.key}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${e.value}',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: stats.entries.map((final e) => '${e.key}: ${e.value}').join('\n'),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stats copied to clipboard')),
                );
              },
              child: const Text('Copy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLogColor(final LogType type) {
    switch (type) {
      case LogType.success:
        return Colors.green;
      case LogType.warning:
        return Colors.orange;
      case LogType.error:
        return Colors.red;
      case LogType.info:
        return Colors.blue;
    }
  }

  IconData _getLogIcon(final LogType type) {
    switch (type) {
      case LogType.success:
        return Icons.check_circle;
      case LogType.warning:
        return Icons.warning;
      case LogType.error:
        return Icons.error;
      case LogType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('HTTP Tracking Example'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _initializeHttpTracking,
          tooltip: 'Reinitialize HTTP Tracking',
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isLoading ? Icons.hourglass_empty : Icons.check_circle,
                        color: _isLoading ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Status: $_status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        EngineHttpTracking.isEnabled ? Icons.check_circle : Icons.cancel,
                        color: EngineHttpTracking.isEnabled ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'HTTP Tracking: ${EngineHttpTracking.isEnabled ? "Enabled" : "Disabled"}',
                        style: TextStyle(
                          color: EngineHttpTracking.isEnabled ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _makeGetRequest,
                icon: const Icon(Icons.download),
                label: const Text('GET Request'),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _makePostRequest,
                icon: const Icon(Icons.upload),
                label: const Text('POST Request'),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _makeErrorRequest,
                icon: const Icon(Icons.error),
                label: const Text('Error Request'),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testMultipleRequests,
                icon: const Icon(Icons.multiple_stop),
                label: const Text('Multiple Requests'),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testDifferentConfigs,
                icon: const Icon(Icons.settings),
                label: const Text('Test Configs'),
              ),
              ElevatedButton.icon(
                onPressed: _showTrackingStats,
                icon: const Icon(Icons.analytics),
                label: const Text('Show Stats'),
              ),
              ElevatedButton.icon(
                onPressed: _clearLogs,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Logs'),
              ),
              ElevatedButton.icon(
                onPressed: _logs.isNotEmpty ? _copyAllLogs : null,
                icon: const Icon(Icons.copy),
                label: const Text('Copy All Logs'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.list),
                        const SizedBox(width: 8),
                        Text(
                          'Activity Log (${_logs.length} entries)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (final context, final index) {
                          final log = _logs[_logs.length - 1 - index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    _getLogIcon(log.type),
                                    color: _getLogColor(log.type),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    log.formattedTime,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log.message,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        if (log.data != null && log.data!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              'Data: ${json.encode(log.data)}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'monospace',
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 16),
                                    onPressed: () => _copyLog(log),
                                    tooltip: 'Copy log entry',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 24,
                                      minHeight: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    EngineHttpTracking.disable();
    super.dispose();
  }
}
