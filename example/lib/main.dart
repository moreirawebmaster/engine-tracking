import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

import 'view_tracking_example.dart';
import 'http_tracking_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeTracking();
  runApp(const MyApp());
}

Future<void> initializeTracking() async {
  final faroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect/54d9b2d4c4e2a550c890876a914a3525',
    appName: 'engine-tracking',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: '54d9b2d4c4e2a550c890876a914a3525',
    namespace: 'engine.stmr.tech',
    platform: Platform.isAndroid ? 'android' : 'ios',
  );
  // Configure Analytics
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
    faroConfig: faroConfig,
    splunkConfig: const EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
  );

  // Configure Bug Tracking
  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
    faroConfig: faroConfig,
  );

  try {
    // Initialize services
    await Future.wait([
      EngineAnalytics.initWithModel(analyticsModel),
      EngineBugTracking.initWithModel(bugTrackingModel),
    ]);

    // Set user information
    await Future.wait([
      EngineAnalytics.setUserId('demo_user_123', 'demo@example.com', 'Demo User'),
      EngineBugTracking.setUserIdentifier('demo_user_123', 'demo@example.com', 'Demo User'),
    ]);

    // Log app initialization
    await EngineAnalytics.logAppOpen();
    await EngineBugTracking.log('App initialized successfully', level: 'info');
  } catch (e, stackTrace) {
    // Log initialization errors
    await EngineBugTracking.recordError(
      e,
      stackTrace,
      reason: 'Failed to initialize tracking services',
      isFatal: false,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Tracking Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
      navigatorObservers: [EngineNavigationObserver()],
    );
  }
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
    // Track page view
    EngineAnalytics.setPage('HomePage');
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // Track button click event
    await EngineAnalytics.logEvent('button_clicked', {
      'button_name': 'increment_counter',
      'counter_value': _counter,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Log the action
    await EngineBugTracking.log(
      'Counter incremented',
      level: 'info',
      attributes: {'counter_value': _counter, 'user_action': 'button_tap'},
    );
  }

  void _simulateError() async {
    try {
      // Simulate an error for demonstration
      throw Exception('This is a simulated error for testing purposes');
    } catch (error, stackTrace) {
      // Record the error
      await EngineBugTracking.recordError(
        error,
        stackTrace,
        reason: 'User triggered test error',
        information: ['Error simulation', 'User interaction'],
        isFatal: false,
        data: {'counter_value': _counter, 'error_type': 'simulated'},
      );

      // Show snackbar to user
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error recorded and logged!'), backgroundColor: Colors.orange));
      }
    }
  }

  void _setUserProperty() async {
    await EngineAnalytics.setUserProperty('user_level', 'beginner');
    await EngineBugTracking.setCustomKey('user_engagement', 'active');

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User properties updated!'), backgroundColor: Colors.green));
    }
  }

  void _navigateToSecondPage() async {
    await EngineAnalytics.logEvent('navigation', {'from_page': 'HomePage', 'to_page': 'SecondPage'});

    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
    }
  }

  void _navigateToViewTrackingExample() async {
    await EngineAnalytics.logEvent('navigation', {'from_page': 'HomePage', 'to_page': 'ViewTrackingExample'});

    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewTrackingExample()));
    }
  }

  void _navigateToHttpTrackingExample() async {
    await EngineAnalytics.logEvent('navigation', {'from_page': 'HomePage', 'to_page': 'HttpTrackingExample'});

    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HttpTrackingExample()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Text('Engine Tracking Demo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('You have pushed the button this many times:', style: Theme.of(context).textTheme.bodyLarge),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 40),

            // Service Status
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Service Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildStatusRow('Analytics', EngineAnalytics.isEnabled),
                    _buildStatusRow('Bug Tracking', EngineBugTracking.isEnabled),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToHttpTrackingExample,
                  icon: const Icon(Icons.http),
                  label: const Text('HTTP Tracking'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
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
  }

  Widget _buildStatusRow(String service, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(isEnabled ? Icons.check_circle : Icons.cancel, color: isEnabled ? Colors.green : Colors.red, size: 20),
          const SizedBox(width: 8),
          Text('$service: ${isEnabled ? "Enabled" : "Disabled"}'),
        ],
      ),
    );
  }
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
    // Track page view with previous screen
    EngineAnalytics.setPage('SecondPage', 'HomePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text('Second Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('This navigation was tracked!', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
