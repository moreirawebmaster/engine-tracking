import 'package:flutter/material.dart';
import 'package:engine_tracking/engine_tracking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Tracking Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Engine Tracking Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _analyticsInitialized = false;
  String _status = 'Analytics não inicializado';

  @override
  void initState() {
    super.initState();
    _initializeAnalytics();
  }

  Future<void> _initializeAnalytics() async {
    try {
      // Exemplo de inicialização com múltiplos adapters
      final adapters = [
        EngineFirebaseAnalyticsAdapter(
          const EngineFirebaseAnalyticsConfig(enabled: false), // Desabilitado para demo
        ),
        EngineFaroAnalyticsAdapter(
          const EngineFaroConfig(
            enabled: false, // Desabilitado para demo
            endpoint: 'https://faro-demo.grafana.net/collect',
            appName: 'demo-app',
            appVersion: '1.0.0',
            environment: 'development',
            apiKey: 'demo-key',
          ),
        ),
        EngineSplunkAnalyticsAdapter(
          const EngineSplunkConfig(
            enabled: false, // Desabilitado para demo
            endpoint: 'https://splunk-hec.example.com:8088/services/collector',
            token: 'demo-token',
            source: 'mobile-app',
            sourcetype: 'json',
            index: 'main',
          ),
        ),
      ];

      await EngineAnalytics.init(adapters);

      setState(() {
        _analyticsInitialized = EngineAnalytics.isInitialized;
        _status = _analyticsInitialized
            ? 'Analytics inicializado com sucesso!'
            : 'Analytics não habilitado (configs disabled)';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao inicializar analytics: $e';
      });
    }
  }

  Future<void> _logCustomEvent() async {
    await EngineAnalytics.logEvent('button_pressed', {
      'button_name': 'demo_button',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento customizado enviado!')),
    );
  }

  Future<void> _setUserInfo() async {
    await EngineAnalytics.setUserId(
      'demo_user_123',
      'user@example.com',
      'Demo User',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Informações do usuário definidas!')),
    );
  }

  Future<void> _trackPageView() async {
    await EngineAnalytics.setPage(
      'demo_page',
      'home_page',
      {
        'screen_class': 'DemoScreen',
        'feature_enabled': true,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visualização de página rastreada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Demo do Engine Tracking - Padrão Adapter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _analyticsInitialized ? Colors.green[100] : Colors.orange[100],
                border: Border.all(
                  color: _analyticsInitialized ? Colors.green : Colors.orange,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    _analyticsInitialized ? Icons.check_circle : Icons.info,
                    color: _analyticsInitialized ? Colors.green : Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: $_status',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicializado: ${EngineAnalytics.isInitialized}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Habilitado: ${EngineAnalytics.isEnabled}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Testar Funcionalidades:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _logCustomEvent,
              icon: const Icon(Icons.analytics),
              label: const Text('Enviar Evento Customizado'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _setUserInfo,
              icon: const Icon(Icons.person),
              label: const Text('Definir Informações do Usuário'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _trackPageView,
              icon: const Icon(Icons.pageview),
              label: const Text('Rastrear Visualização de Página'),
            ),
            const SizedBox(height: 30),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 Arquitetura Adapter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Firebase Analytics Adapter\n'
                      '• Grafana Faro Adapter\n'
                      '• Splunk Analytics Adapter\n'
                      '• Fácil adição de novos adapters',
                      style: TextStyle(fontSize: 12),
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
}

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
