import 'dart:async';
import 'dart:io';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AdaptersExampleApp());
}

class AdaptersExampleApp extends StatelessWidget {
  const AdaptersExampleApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Engine Tracking Adapters Demo',
    theme: ThemeData(primarySwatch: Colors.purple),
    home: const AdaptersExamplePage(title: 'Adapters Pattern Demo'),
  );
}

class AdaptersExamplePage extends StatefulWidget {
  const AdaptersExamplePage({super.key, required this.title});

  final String title;

  @override
  State<AdaptersExamplePage> createState() => _AdaptersExamplePageState();
}

class _AdaptersExamplePageState extends State<AdaptersExamplePage> {
  bool _analyticsInitialized = false;
  bool _bugTrackingInitialized = false;
  String _analyticsStatus = 'Analytics não inicializado';
  String _bugTrackingStatus = 'Bug tracking não inicializado';

  @override
  void initState() {
    super.initState();
    unawaited(_initializeServices());
  }

  Future<void> _initializeServices() async {
    await _initializeAnalytics();
    await _initializeBugTracking();
  }

  static final _sharedFaroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect',
    appName: 'stmr',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'd447b8aa9e6c8fdae9cf8c28701ede4e',
    namespace: 'exemple',
    platform: Platform.isAndroid ? 'android' : 'ios',
  );

  static final _firebaseAnalyticsConfig = EngineFirebaseAnalyticsConfig(enabled: false);
  static final _crashlyticsConfig = EngineCrashlyticsConfig(enabled: false);
  static final _splunkConfig = EngineSplunkConfig(
    enabled: false,
    endpoint: 'https://splunk.example.com:8088/services/collector',
    token: 'demo-token',
    source: 'mobile-app',
    sourcetype: 'json',
    index: 'main',
  );

  Future<void> _initializeAnalytics() async {
    try {
      final analyticsAdapters = <IEngineAnalyticsAdapter>[
        EngineFirebaseAnalyticsAdapter(_firebaseAnalyticsConfig),
        EngineFaroAnalyticsAdapter(_sharedFaroConfig),
        EngineSplunkAnalyticsAdapter(_splunkConfig),
      ];

      await EngineAnalytics.init(analyticsAdapters);

      setState(() {
        _analyticsInitialized = EngineAnalytics.isInitialized;
        _analyticsStatus = _analyticsInitialized
            ? 'Analytics inicializado com adapters!'
            : 'Analytics não habilitado (configs disabled)';
      });
    } catch (e) {
      setState(() {
        _analyticsStatus = 'Erro ao inicializar analytics: $e';
      });
    }
  }

  Future<void> _initializeBugTracking() async {
    try {
      final bugTrackingModel = EngineBugTrackingModel(
        crashlyticsConfig: _crashlyticsConfig,
        faroConfig: _sharedFaroConfig,
      );

      await EngineBugTracking.initWithModel(bugTrackingModel);

      setState(() {
        _bugTrackingInitialized = EngineBugTracking.isInitialized;
        _bugTrackingStatus = _bugTrackingInitialized
            ? 'Bug tracking inicializado com modelo!'
            : 'Bug tracking não habilitado (configs disabled)';
      });
    } catch (e) {
      setState(() {
        _bugTrackingStatus = 'Erro ao inicializar bug tracking: $e';
      });
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🎯 Demo do Padrão Adapter',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          _buildStatusCard(
            title: '📊 Analytics Adapters',
            status: _analyticsStatus,
            isInitialized: _analyticsInitialized,
            adapters: ['Firebase Analytics Adapter', 'Grafana Faro Analytics Adapter', 'Splunk Analytics Adapter'],
          ),

          const SizedBox(height: 16),

          _buildStatusCard(
            title: '🐛 Bug Tracking Adapters',
            status: _bugTrackingStatus,
            isInitialized: _bugTrackingInitialized,
            adapters: ['Firebase Crashlytics Adapter', 'Grafana Faro Bug Tracking Adapter'],
          ),

          const SizedBox(height: 30),

          const Text('🚀 Teste as Funcionalidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          _buildActionSection(
            title: 'Analytics Actions',
            actions: [
              _buildActionButton(
                'Enviar Evento Personalizado',
                Icons.analytics,
                Colors.blue,
                _includeInAnalyticsEvent,
              ),
              _buildActionButton('Definir Propriedade do Usuário', Icons.person_add, Colors.green, _setUserProperty),
              _buildActionButton('Rastrear Tela', Icons.pageview, Colors.orange, _trackScreen),
            ],
          ),

          const SizedBox(height: 20),

          _buildActionSection(
            title: 'Bug Tracking Actions',
            actions: [
              _buildActionButton('Log de Informação', Icons.info, Colors.cyan, _logInfo),
              _buildActionButton('Simular Erro', Icons.error, Colors.red, _simulateError),
              _buildActionButton('Definir Chave Personalizada', Icons.key, Colors.purple, _setCustomKey),
            ],
          ),

          const SizedBox(height: 30),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✨ Vantagens do Padrão Adapter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  Text(
                    '• Flexibilidade total na escolha de provedores\n'
                    '• Inicialização independente de cada adapter\n'
                    '• Fácil adição de novos sistemas de tracking\n'
                    '• Código SOLID e extensível\n'
                    '• Interface consistente para todos os adapters\n'
                    '• Reaproveitamento de configurações (ex: Faro)\n'
                    '• Dois métodos de inicialização: adapters direto ou modelos',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Card(
            color: Color(0xFFF3E5F5),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔄 Reaproveitamento de Configurações',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Demonstração:\n'
                    '• Analytics: Inicializado com adapters diretos\n'
                    '• Bug Tracking: Inicializado com modelo tradicional\n'
                    '• Ambos compartilham a mesma config do Faro\n'
                    '• Economia de configuração e consistência',
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

  Widget _buildStatusCard({
    required final String title,
    required final String status,
    required final bool isInitialized,
    required final List<String> adapters,
  }) => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isInitialized ? Colors.green[50] : Colors.orange[50],
              border: Border.all(color: isInitialized ? Colors.green : Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isInitialized ? Icons.check_circle : Icons.info,
                  color: isInitialized ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(status, style: const TextStyle(fontSize: 14))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Adapters disponíveis:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          ...adapters.map(
            (final adapter) => Padding(
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: Text('• $adapter', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildActionSection({required final String title, required final List<Widget> actions}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      ...actions.map((final action) => Padding(padding: const EdgeInsets.only(bottom: 8), child: action)),
    ],
  );

  Widget _buildActionButton(final String label, final IconData icon, final Color color, final VoidCallback onPressed) =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );

  Future<void> _includeInAnalyticsEvent() async {
    await EngineAnalytics.logEvent('adapter_demo_event', {
      'demo_type': 'analytics',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _showSnackBar('Evento de analytics enviado!', Colors.blue);
  }

  Future<void> _setUserProperty() async {
    await EngineAnalytics.setUserProperty('demo_user_type', 'adapter_tester');

    _showSnackBar('Propriedade do usuário definida!', Colors.green);
  }

  Future<void> _trackScreen() async {
    await EngineAnalytics.setPage('adapters_demo_screen', 'main_screen');

    _showSnackBar('Tela rastreada!', Colors.orange);
  }

  Future<void> _logInfo() async {
    await EngineBugTracking.log('Demonstração do adapter de bug tracking', level: 'info', attributes: {'demo': 'true'});

    _showSnackBar('Log de informação registrado!', Colors.cyan);
  }

  Future<void> _simulateError() async {
    try {
      throw Exception('Erro simulado para demonstração dos adapters');
    } catch (e, stackTrace) {
      await EngineBugTracking.recordError(
        e,
        stackTrace,
        reason: 'Demo adapter error',
        isFatal: false,
        data: {'adapter_demo': 'true'},
      );

      _showSnackBar('Erro simulado e registrado!', Colors.red);
    }
  }

  Future<void> _setCustomKey() async {
    await EngineBugTracking.setCustomKey('adapter_demo', 'bug_tracking_test');

    _showSnackBar('Chave personalizada definida!', Colors.purple);
  }

  void _showSnackBar(final String message, final Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)));
  }
}

Future<void> adaptersFlexibleExample() async {
  final firebaseAnalyticsAdapter = EngineFirebaseAnalyticsAdapter(EngineFirebaseAnalyticsConfig(enabled: true));

  await EngineAnalytics.init([firebaseAnalyticsAdapter]);

  final sharedFaroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.grafana.net/collect',
    appName: 'MyApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'your-shared-faro-api-key',
    namespace: 'exemple',
    platform: Platform.isAndroid ? 'android' : 'ios',
  );

  final firebaseAnalyticsConfig = EngineFirebaseAnalyticsConfig(enabled: true);
  final crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
  final splunkConfig = EngineSplunkConfig(
    enabled: true,
    endpoint: 'https://splunk-hec.example.com:8088/services/collector',
    token: 'your-hec-token',
    source: 'mobile-app',
    sourcetype: 'json',
    index: 'main',
  );

  final analyticsAdapters = <IEngineAnalyticsAdapter>[
    EngineFirebaseAnalyticsAdapter(firebaseAnalyticsConfig),
    EngineFaroAnalyticsAdapter(sharedFaroConfig),
    EngineSplunkAnalyticsAdapter(splunkConfig),
  ];

  final bugTrackingAdapters = <IEngineBugTrackingAdapter>[
    EngineCrashlyticsAdapter(crashlyticsConfig),
    EngineFaroBugTrackingAdapter(sharedFaroConfig),
  ];

  await Future.wait([
    EngineAnalytics.init(analyticsAdapters),
    EngineBugTracking.init(bugTrackingAdapters),
  ]);

  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: firebaseAnalyticsConfig,
    faroConfig: sharedFaroConfig,
    splunkConfig: splunkConfig,
    clarityConfig: null,
    googleLoggingConfig: null,
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: crashlyticsConfig,
    faroConfig: sharedFaroConfig,
  );

  await EngineAnalytics.dispose();
  await EngineBugTracking.dispose();

  await Future.wait([EngineAnalytics.initWithModel(analyticsModel), EngineBugTracking.initWithModel(bugTrackingModel)]);

  await EngineAnalytics.logEvent('adapter_demo', {'demo': 'true'});
  await EngineBugTracking.log('Demo app started');
}

class CustomAnalyticsAdapter implements IEngineAnalyticsAdapter<IEngineConfig> {
  final bool _enabled;
  bool _isInitialized = false;

  CustomAnalyticsAdapter({required final bool enabled}) : _enabled = enabled;

  @override
  String get adapterName => 'Custom Analytics';

  @override
  bool get isEnabled => _enabled;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) return;

    debugPrint('Inicializando Custom Analytics Adapter...');
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    debugPrint('Finalizando Custom Analytics Adapter...');
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(final String name, [final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - Evento: $name, Parâmetros: $parameters');
  }

  @override
  Future<void> setUserId(final String? userId, [final String? email, final String? name]) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - Usuário: $userId, Email: $email, Nome: $name');
  }

  @override
  Future<void> setUserProperty(final String name, final String? value) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - Propriedade: $name = $value');
  }

  @override
  Future<void> setPage(
    final String screenName, [
    final String? previousScreen,
    final Map<String, dynamic>? parameters,
  ]) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - Página: $screenName');
  }

  @override
  Future<void> logAppOpen([final Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - App aberto');
  }

  @override
  Future<void> reset() async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Analytics - Reset');
  }

  @override
  IEngineConfig get config => throw UnimplementedError();
}

class CustomBugTrackingAdapter implements IEngineBugTrackingAdapter<IEngineConfig> {
  final bool _enabled;
  bool _isInitialized = false;

  CustomBugTrackingAdapter({required final bool enabled}) : _enabled = enabled;

  @override
  String get adapterName => 'Custom Bug Tracking';

  @override
  bool get isEnabled => _enabled;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) return;

    debugPrint('Inicializando Custom Bug Tracking Adapter...');
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    debugPrint('Finalizando Custom Bug Tracking Adapter...');
    _isInitialized = false;
  }

  @override
  Future<void> setCustomKey(final String key, final Object value) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Chave personalizada: $key = $value');
  }

  @override
  Future<void> setUserIdentifier(final String id, final String email, final String name) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Usuário: $id, Email: $email, Nome: $name');
  }

  @override
  Future<void> log(
    final String message, {
    final String? level,
    final Map<String, dynamic>? attributes,
    final StackTrace? stackTrace,
  }) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Log: $message [Level: $level]');
  }

  @override
  Future<void> recordError(
    final dynamic exception,
    final StackTrace? stackTrace, {
    final String? reason,
    final Iterable<Object> information = const [],
    final bool isFatal = false,
    final Map<String, dynamic>? data,
  }) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Erro: $exception [Fatal: $isFatal]');
  }

  @override
  Future<void> recordFlutterError(final FlutterErrorDetails errorDetails) async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Flutter Error: ${errorDetails.exception}');
  }

  @override
  Future<void> testCrash() async {
    if (!isEnabled || !_isInitialized) return;

    debugPrint('Custom Bug Tracking - Test Crash');
  }

  @override
  IEngineConfig get config => throw UnimplementedError();
}

Future<void> customAdaptersExample() async {
  final customAnalyticsAdapter = CustomAnalyticsAdapter(enabled: true);
  final customBugTrackingAdapter = CustomBugTrackingAdapter(enabled: true);

  await EngineAnalytics.init([customAnalyticsAdapter]);
  await EngineBugTracking.init([customBugTrackingAdapter]);

  await EngineAnalytics.logEvent('custom_event', {'custom_param': 'value'});
  await EngineBugTracking.log('Custom log message');

  await EngineAnalytics.dispose();
  await EngineBugTracking.dispose();
}

Future<void> mixedInitializationExample() async {
  final sharedFaroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro.example.com/collect',
    appName: 'MixedApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'shared-faro-key',
    namespace: 'exemple',
    platform: Platform.isAndroid ? 'android' : 'ios',
  );

  await EngineAnalytics.init([
    EngineFirebaseAnalyticsAdapter(EngineFirebaseAnalyticsConfig(enabled: true)),
    EngineFaroAnalyticsAdapter(sharedFaroConfig),
  ]);

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: EngineCrashlyticsConfig(enabled: true),
    faroConfig: sharedFaroConfig,
  );

  await EngineBugTracking.initWithModel(bugTrackingModel);

  await EngineAnalytics.logEvent('mixed_init_demo', {'method': 'adapters'});
  await EngineBugTracking.log('Mixed initialization demo', attributes: {'method': 'model'});
}
