import 'dart:async';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:engine_tracking_example/http_tracking_example.dart';
import 'package:engine_tracking_example/view_tracking_example.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeTracking();

  runApp(const EngineWidget(app: MyApp()));
}

Future<(EngineAnalyticsModel analyticsModel, EngineBugTrackingModel bugTrackingModel)> initializeTracking() async {
  final faroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect/54d9b2d4c4e2a550c890876a914a3525',
    appName: 'engine-tracking',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: '54d9b2d4c4e2a550c890876a914a3525',
    namespace: 'engine.stmr.tech',
    platform: Platform.isAndroid ? 'android' : 'ios',
    httpTrackingEnable: true,
  );

  final clarityConfig = EngineClarityConfig(
    enabled: true,
    projectId: 's8nukxh19i',
  );

  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(
      enabled: false,
    ),
    faroConfig: faroConfig,
    splunkConfig: EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
    clarityConfig: clarityConfig,
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: EngineCrashlyticsConfig(enabled: false),
    faroConfig: faroConfig,
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  try {
    await Future.wait([
      EngineAnalytics.initWithModel(analyticsModel),
      EngineBugTracking.initWithModel(bugTrackingModel),
    ]);

    const httpTrackingModel = EngineHttpTrackingModel(
      enabled: true,
      httpTrackingConfig: EngineHttpTrackingConfig(
        enableRequestLogging: true,
        enableResponseLogging: true,
        enableTimingLogging: true,
        enableHeaderLogging: true,
        enableBodyLogging: true,
        maxBodyLogLength: 2000,
        logName: 'ENGINE_EXAMPLE_HTTP',
      ),
    );

    EngineHttpTracking.initWithModel(httpTrackingModel);

    await Future.wait([
      EngineAnalytics.setUserId(
        'demo_user_123',
        'demo@example.com',
        'Demo User',
      ),
      EngineBugTracking.setUserIdentifier(
        'demo_user_123',
        'demo@example.com',
        'Demo User',
      ),
    ]);

    await EngineAnalytics.logAppOpen();
    await EngineBugTracking.log('App initialized successfully', level: 'info');
    await EngineHttpTracking.logCustomEvent(
      'HTTP tracking initialized for example app',
    );

    return (analyticsModel, bugTrackingModel);
  } catch (e, stackTrace) {
    await EngineBugTracking.recordError(
      e,
      stackTrace,
      reason: 'Failed to initialize tracking services',
      isFatal: false,
    );

    return (EngineAnalyticsModelDefault(), EngineBugTrackingModelDefault());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Engine Tracking Example',
    theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    home: const HomePage(),
    navigatorObservers: [EngineNavigationObserver()],
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    unawaited(EngineAnalytics.setPage('HomePage'));
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    await EngineAnalytics.logEvent('button_clicked', {
      'button_name': 'increment_counter',
      'counter_value': _counter,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await EngineBugTracking.log(
      'Counter incremented',
      level: 'info',
      attributes: {'counter_value': _counter, 'user_action': 'button_tap'},
    );
  }

  Future<void> _simulateError() async {
    try {
      throw Exception('This is a simulated error for testing purposes');
    } catch (error, stackTrace) {
      await EngineBugTracking.recordError(
        error,
        stackTrace,
        reason: 'User triggered test error',
        information: ['Error simulation', 'User interaction'],
        isFatal: false,
        data: {'counter_value': _counter, 'error_type': 'simulated'},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error recorded and logged!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _setUserProperty() async {
    await EngineAnalytics.setUserProperty('user_level', 'beginner');
    await EngineBugTracking.setCustomKey('user_engagement', 'active');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User properties updated!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _navigateToSecondPage() async {
    if (mounted) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(builder: (final context) => const SecondPage()),
        ),
      );
    }
  }

  Future<void> _navigateToViewTrackingExample() async {
    if (mounted) {
      unawaited(Navigator.push(context, MaterialPageRoute(builder: (final context) => const ViewTrackingExample())));
    }
  }

  Future<void> _navigateToHttpTrackingExample() async {
    if (mounted) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(builder: (final context) => const HttpTrackingExample()),
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Engine Tracking Example'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.analytics, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Engine Tracking Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'You have pushed the button this many times:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Status:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusRow('Analytics', EngineAnalytics.isEnabled),
                  _buildStatusRow(
                    'Bug Tracking',
                    EngineBugTracking.isEnabled,
                  ),
                  _buildStatusRow(
                    'HTTP Tracking',
                    EngineHttpTracking.isEnabled,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _setUserProperty,
                icon: const Icon(Icons.person),
                label: const Text('Set User Property'),
              ),
              ElevatedButton.icon(
                onPressed: _simulateError,
                icon: const Icon(Icons.error_outline),
                label: const Text('Simulate Error'),
              ),
              ElevatedButton.icon(
                onPressed: _navigateToSecondPage,
                icon: const Icon(Icons.navigate_next),
                label: const Text('Navigate'),
              ),
              ElevatedButton.icon(
                onPressed: _navigateToViewTrackingExample,
                icon: const Icon(Icons.visibility),
                label: const Text('View Tracking'),
              ),
              ElevatedButton.icon(
                onPressed: _navigateToHttpTrackingExample,
                icon: const Icon(Icons.http),
                label: const Text('HTTP Tracking'),
              ),
            ],
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );

  Widget _buildStatusRow(final String service, final bool isEnabled) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(
          isEnabled ? Icons.check_circle : Icons.cancel,
          color: isEnabled ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text('$service: ${isEnabled ? "Enabled" : "Disabled"}'),
      ],
    ),
  );
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();
    unawaited(EngineAnalytics.setPage('SecondPage', 'HomePage'));
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Second Page'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, size: 100, color: Colors.amber),
          SizedBox(height: 20),
          Text(
            'Second Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'This navigation was tracked!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
