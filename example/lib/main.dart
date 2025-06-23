import 'package:flutter/material.dart';
import 'package:engine_tracking/engine_tracking.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeTracking();

  runApp(const MyApp());
}

Future<void> initializeTracking() async {
  // Configure Analytics
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.example.com/collect',
      appName: 'EngineTrackingExample',
      appVersion: '1.0.0',
      environment: 'development',
      apiKey: 'your-faro-api-key',
    ),
  );

  // Configure Bug Tracking
  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.example.com/collect',
      appName: 'EngineTrackingExample',
      appVersion: '1.0.0',
      environment: 'development',
      apiKey: 'your-faro-api-key',
    ),
  );

  try {
    // Initialize services
    await Future.wait([
      EngineAnalytics.init(analyticsModel),
      EngineBugTracking.init(bugTrackingModel),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
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
      attributes: {
        'counter_value': _counter,
        'user_action': 'button_tap',
      },
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
        data: {
          'counter_value': _counter,
          'error_type': 'simulated',
        },
      );

      // Show snackbar to user
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

  void _setUserProperty() async {
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

  void _navigateToSecondPage() async {
    await EngineAnalytics.logEvent('navigation', {
      'from_page': 'HomePage',
      'to_page': 'SecondPage',
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondPage()),
      );
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
            const Icon(
              Icons.analytics,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Engine Tracking Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment Counter'),
                ),
                ElevatedButton.icon(
                  onPressed: _simulateError,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Simulate Error'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _setUserProperty,
                  icon: const Icon(Icons.person),
                  label: const Text('Set User Property'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToSecondPage,
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow('Analytics', EngineAnalytics.isEnabled),
                    _buildStatusRow('Firebase Analytics', EngineAnalytics.isFirebaseAnalyticsEnabled),
                    _buildStatusRow('Faro Analytics', EngineAnalytics.isFaroEnabled),
                    _buildStatusRow('Bug Tracking', EngineBugTracking.isEnabled),
                    _buildStatusRow('Crashlytics', EngineBugTracking.isCrashlyticsEnabled),
                    _buildStatusRow('Faro Logging', EngineBugTracking.isFaroEnabled),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String service, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isEnabled ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text('$service: ${isEnabled ? 'Enabled' : 'Disabled'}'),
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
    // Track page view with context
    EngineAnalytics.setPage('SecondPage', 'HomePage', 'SecondPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.explore,
              size: 80,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Second Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This demonstrates page navigation tracking.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                await EngineAnalytics.logEvent('page_action', {
                  'action': 'special_button_clicked',
                  'page': 'SecondPage',
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Special action tracked!'),
                      backgroundColor: Colors.purple,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.star),
              label: const Text('Special Action'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
