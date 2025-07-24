// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

class GoogleLoggingExample extends StatefulWidget {
  const GoogleLoggingExample({super.key});

  @override
  State<GoogleLoggingExample> createState() => _GoogleLoggingExampleState();
}

class _GoogleLoggingExampleState extends State<GoogleLoggingExample> {
  final TextEditingController _projectIdController = TextEditingController();
  final TextEditingController _logNameController = TextEditingController();
  final TextEditingController _credentialsController = TextEditingController();
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _projectIdController.text = 'your-project-id';
    _logNameController.text = 'engine-tracking-logs';
    _credentialsController.text = '{}';
  }

  @override
  void dispose() {
    _projectIdController.dispose();
    _logNameController.dispose();
    _credentialsController.dispose();
    super.dispose();
  }

  Future<void> _initializeGoogleLogging() async {
    try {
      final credentials = Map<String, dynamic>.from(
        json.decode(_credentialsController.text) as Map<String, dynamic>,
      );

      final config = EngineGoogleLoggingConfig(
        enabled: true,
        projectId: _projectIdController.text,
        logName: _logNameController.text,
        credentials: credentials,
      );

      await EngineAnalytics.initWithModel(
        EngineAnalyticsModel(
          firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: false),
          faroConfig: EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
            namespace: '',
            platform: '',
          ),
          splunkConfig: EngineSplunkConfig(
            enabled: false,
            endpoint: '',
            token: '',
            source: '',
            sourcetype: '',
            index: '',
          ),
          clarityConfig: EngineClarityConfig(enabled: false, projectId: ''),
          googleLoggingConfig: config,
        ),
      );

      await EngineBugTracking.initWithModel(
        EngineBugTrackingModel(
          crashlyticsConfig: EngineCrashlyticsConfig(enabled: false),
          faroConfig: EngineFaroConfig(
            enabled: false,
            endpoint: '',
            appName: '',
            appVersion: '',
            environment: '',
            apiKey: '',
            namespace: '',
            platform: '',
          ),
          googleLoggingConfig: config,
        ),
      );

      setState(() {
        _isInitialized = true;
        _status = 'Google Logging initialized successfully';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Logging initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Failed to initialize: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testAnalytics() async {
    try {
      await EngineAnalytics.logEvent('test_event', {
        'source': 'google_logging_example',
        'timestamp': DateTime.now().toIso8601String(),
      });

      await EngineAnalytics.setUserId('test_user', 'test@example.com', 'Test User');
      await EngineAnalytics.setUserProperty('test_property', 'test_value');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analytics events sent to Google Logging!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send analytics: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testBugTracking() async {
    try {
      await EngineBugTracking.log('Test log message', level: 'info');
      await EngineBugTracking.setUserIdentifier('test_user', 'test@example.com', 'Test User');
      await EngineBugTracking.setCustomKey('test_key', 'test_value');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bug tracking events sent to Google Logging!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send bug tracking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _simulateError() async {
    try {
      await EngineBugTracking.recordError(
        Exception('Test error from Google Logging example'),
        StackTrace.current,
        reason: 'Demonstration error',
        isFatal: false,
        data: {'source': 'google_logging_example'},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error recorded in Google Logging!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to record error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Google Logging Example'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuration',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _projectIdController,
                    decoration: const InputDecoration(
                      labelText: 'Project ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _logNameController,
                    decoration: const InputDecoration(
                      labelText: 'Log Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _credentialsController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Service Account Credentials (JSON)',
                      border: OutlineInputBorder(),
                      helperText: 'Paste your service account JSON credentials here',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _isInitialized ? null : _initializeGoogleLogging,
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Initialize Google Logging'),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isInitialized ? Icons.check_circle : Icons.cancel,
                        color: _isInitialized ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status: $_status',
                        style: TextStyle(
                          color: _isInitialized ? Colors.green : Colors.red,
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
                onPressed: _isInitialized ? _testAnalytics : null,
                icon: const Icon(Icons.analytics),
                label: const Text('Test Analytics'),
              ),
              ElevatedButton.icon(
                onPressed: _isInitialized ? _testBugTracking : null,
                icon: const Icon(Icons.bug_report),
                label: const Text('Test Bug Tracking'),
              ),
              ElevatedButton.icon(
                onPressed: _isInitialized ? _simulateError : null,
                icon: const Icon(Icons.error),
                label: const Text('Simulate Error'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Create a Google Cloud project\n'
                    '2. Enable Cloud Logging API\n'
                    '3. Create a service account\n'
                    '4. Download the JSON credentials\n'
                    '5. Paste the credentials in the field above\n'
                    '6. Enter your project ID and log name\n'
                    '7. Click "Initialize Google Logging"\n'
                    '8. Test the functionality',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
