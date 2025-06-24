import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AdaptersExampleApp());
}

class AdaptersExampleApp extends StatelessWidget {
  const AdaptersExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Tracking Adapters Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const AdaptersExamplePage(title: 'Adapters Pattern Demo'),
    );
  }
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
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _initializeAnalytics();
    await _initializeBugTracking();
  }

  // Configurações compartilhadas - Boa prática de reaproveitamento
  static const _sharedFaroConfig = EngineFaroConfig(
    enabled: true, // Desabilitado para demo
    endpoint: 'https://faro-collector-prod-sa-east-1.grafana.net/collect',
    appName: 'stmr',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'd447b8aa9e6c8fdae9cf8c28701ede4e', // Mesma chave compartilhada
  );

  static const _firebaseAnalyticsConfig = EngineFirebaseAnalyticsConfig(enabled: false);
  static const _crashlyticsConfig = EngineCrashlyticsConfig(enabled: false);
  static const _splunkConfig = EngineSplunkConfig(
    enabled: false,
    endpoint: 'https://splunk.example.com:8088/services/collector',
    token: 'demo-token',
    source: 'mobile-app',
    sourcetype: 'json',
    index: 'main',
  );

  Future<void> _initializeAnalytics() async {
    try {
      // Exemplo 1: Inicialização direta com adapters
      final analyticsAdapters = [
        EngineFirebaseAnalyticsAdapter(_firebaseAnalyticsConfig),
        EngineFaroAnalyticsAdapter(_sharedFaroConfig), // Config compartilhada
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
      // Exemplo 2: Inicialização com modelo tradicional reutilizando configs
      final bugTrackingModel = EngineBugTrackingModel(
        crashlyticsConfig: _crashlyticsConfig,
        faroConfig: _sharedFaroConfig, // Mesma config do analytics!
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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

            // Analytics Status
            _buildStatusCard(
              title: '📊 Analytics Adapters',
              status: _analyticsStatus,
              isInitialized: _analyticsInitialized,
              adapters: [
                'Firebase Analytics Adapter',
                'Grafana Faro Analytics Adapter',
                'Splunk Analytics Adapter',
              ],
            ),

            const SizedBox(height: 16),

            // Bug Tracking Status
            _buildStatusCard(
              title: '🐛 Bug Tracking Adapters',
              status: _bugTrackingStatus,
              isInitialized: _bugTrackingInitialized,
              adapters: [
                'Firebase Crashlytics Adapter',
                'Grafana Faro Bug Tracking Adapter',
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              '🚀 Teste as Funcionalidades:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Analytics Actions
            _buildActionSection(
              title: 'Analytics Actions',
              actions: [
                _buildActionButton(
                  'Enviar Evento Personalizado',
                  Icons.analytics,
                  Colors.blue,
                  _sendAnalyticsEvent,
                ),
                _buildActionButton(
                  'Definir Propriedade do Usuário',
                  Icons.person_add,
                  Colors.green,
                  _setUserProperty,
                ),
                _buildActionButton(
                  'Rastrear Tela',
                  Icons.pageview,
                  Colors.orange,
                  _trackScreen,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bug Tracking Actions
            _buildActionSection(
              title: 'Bug Tracking Actions',
              actions: [
                _buildActionButton(
                  'Log de Informação',
                  Icons.info,
                  Colors.cyan,
                  _logInfo,
                ),
                _buildActionButton(
                  'Simular Erro',
                  Icons.error,
                  Colors.red,
                  _simulateError,
                ),
                _buildActionButton(
                  'Definir Chave Personalizada',
                  Icons.key,
                  Colors.purple,
                  _setCustomKey,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Advantages Card
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ Vantagens do Padrão Adapter',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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

            // Config Sharing Example Card
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
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required bool isInitialized,
    required List<String> adapters,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isInitialized ? Colors.green[50] : Colors.orange[50],
                border: Border.all(
                  color: isInitialized ? Colors.green : Colors.orange,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isInitialized ? Icons.check_circle : Icons.info,
                    color: isInitialized ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Adapters disponíveis:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            ...adapters.map(
              (adapter) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: Text(
                  '• $adapter',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection({
    required String title,
    required List<Widget> actions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...actions.map(
          (action) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: action,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
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
  }

  Future<void> _sendAnalyticsEvent() async {
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
    await EngineBugTracking.log(
      'Demonstração do adapter de bug tracking',
      level: 'info',
      attributes: {'demo': 'true'},
    );

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

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

void adaptersFlexibleExample() async {
  // Exemplo 1: Usando apenas Firebase Analytics
  final firebaseAnalyticsAdapter = EngineFirebaseAnalyticsAdapter(
    const EngineFirebaseAnalyticsConfig(enabled: true),
  );

  await EngineAnalytics.init([firebaseAnalyticsAdapter]);

  // Exemplo 2: Configurações compartilhadas entre Analytics e Bug Tracking
  // Esta é uma prática recomendada para reaproveitar configurações
  const sharedFaroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.grafana.net/collect',
    appName: 'MyApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'your-shared-faro-api-key', // Mesma chave para analytics e bug tracking
  );

  const firebaseAnalyticsConfig = EngineFirebaseAnalyticsConfig(enabled: true);
  const crashlyticsConfig = EngineCrashlyticsConfig(enabled: true);
  const splunkConfig = EngineSplunkConfig(
    enabled: true,
    endpoint: 'https://splunk-hec.example.com:8088/services/collector',
    token: 'your-hec-token',
    source: 'mobile-app',
    sourcetype: 'json',
    index: 'main',
  );

  // Analytics adapters usando configurações compartilhadas
  final analyticsAdapters = [
    EngineFirebaseAnalyticsAdapter(firebaseAnalyticsConfig),
    EngineFaroAnalyticsAdapter(sharedFaroConfig), // Reutilizando config
    EngineSplunkAnalyticsAdapter(splunkConfig),
  ];

  // Bug tracking adapters reutilizando a mesma config do Faro
  final bugTrackingAdapters = [
    EngineCrashlyticsAdapter(crashlyticsConfig),
    EngineFaroBugTrackingAdapter(sharedFaroConfig), // Mesma config reutilizada!
  ];

  // Inicialização simultânea dos serviços
  await Future.wait([
    EngineAnalytics.init(analyticsAdapters),
    EngineBugTracking.init(bugTrackingAdapters),
  ]);

  // Exemplo 3: Usando modelos tradicionais com configurações compartilhadas
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: firebaseAnalyticsConfig,
    faroConfig: sharedFaroConfig, // Reutilizando mesma config
    splunkConfig: splunkConfig,
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: crashlyticsConfig,
    faroConfig: sharedFaroConfig, // Mesma config compartilhada
  );

  // Reinicialização usando modelos (demonstra flexibilidade)
  await EngineAnalytics.dispose();
  await EngineBugTracking.dispose();

  await Future.wait([
    EngineAnalytics.initWithModel(analyticsModel),
    EngineBugTracking.initWithModel(bugTrackingModel),
  ]);

  // Exemplo de uso após inicialização
  await EngineAnalytics.logEvent('adapter_demo', {'demo': 'true'});
  await EngineBugTracking.log('Demo app started');
}

class CustomAnalyticsAdapter implements IEngineAnalyticsAdapter {
  final bool _enabled;
  bool _isInitialized = false;

  CustomAnalyticsAdapter({required bool enabled}) : _enabled = enabled;

  @override
  String get adapterName => 'Custom Analytics';

  @override
  bool get isEnabled => _enabled;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) return;

    print('Inicializando Custom Analytics Adapter...');
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    print('Finalizando Custom Analytics Adapter...');
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - Evento: $name, Parâmetros: $parameters');
  }

  @override
  Future<void> setUserId(String? userId, [String? email, String? name]) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - Usuário: $userId, Email: $email, Nome: $name');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - Propriedade: $name = $value');
  }

  @override
  Future<void> setPage(String screenName, [String? previousScreen, Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - Página: $screenName');
  }

  @override
  Future<void> logAppOpen([Map<String, dynamic>? parameters]) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - App aberto');
  }

  @override
  Future<void> reset() async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Analytics - Reset');
  }
}

class CustomBugTrackingAdapter implements IEngineBugTrackingAdapter {
  final bool _enabled;
  bool _isInitialized = false;

  CustomBugTrackingAdapter({required bool enabled}) : _enabled = enabled;

  @override
  String get adapterName => 'Custom Bug Tracking';

  @override
  bool get isEnabled => _enabled;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (!isEnabled || _isInitialized) return;

    print('Inicializando Custom Bug Tracking Adapter...');
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    print('Finalizando Custom Bug Tracking Adapter...');
    _isInitialized = false;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Chave personalizada: $key = $value');
  }

  @override
  Future<void> setUserIdentifier(String id, String email, String name) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Usuário: $id, Email: $email, Nome: $name');
  }

  @override
  Future<void> log(
    String message, {
    String? level,
    Map<String, dynamic>? attributes,
    StackTrace? stackTrace,
  }) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Log: $message [Level: $level]');
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object> information = const [],
    bool isFatal = false,
    Map<String, dynamic>? data,
  }) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Erro: $exception [Fatal: $isFatal]');
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails errorDetails) async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Flutter Error: ${errorDetails.exception}');
  }

  @override
  Future<void> testCrash() async {
    if (!isEnabled || !_isInitialized) return;

    print('Custom Bug Tracking - Test Crash');
  }
}

void customAdaptersExample() async {
  // Exemplo de adapters personalizados
  final customAnalyticsAdapter = CustomAnalyticsAdapter(enabled: true);
  final customBugTrackingAdapter = CustomBugTrackingAdapter(enabled: true);

  await EngineAnalytics.init([customAnalyticsAdapter]);
  await EngineBugTracking.init([customBugTrackingAdapter]);

  await EngineAnalytics.logEvent('custom_event', {'custom_param': 'value'});
  await EngineBugTracking.log('Custom log message');

  await EngineAnalytics.dispose();
  await EngineBugTracking.dispose();
}

void mixedInitializationExample() async {
  // Exemplo mostrando diferentes métodos de inicialização
  // e reaproveitamento de configurações

  // Configuração compartilhada do Faro
  const sharedFaroConfig = EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro.example.com/collect',
    appName: 'MixedApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'shared-faro-key',
  );

  // Método 1: Analytics com adapters diretos
  await EngineAnalytics.init([
    EngineFirebaseAnalyticsAdapter(
      const EngineFirebaseAnalyticsConfig(enabled: true),
    ),
    EngineFaroAnalyticsAdapter(sharedFaroConfig), // Config compartilhada
  ]);

  // Método 2: Bug tracking com modelo tradicional reutilizando config
  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
    faroConfig: sharedFaroConfig, // Mesma config reutilizada!
  );

  await EngineBugTracking.initWithModel(bugTrackingModel);

  // Uso demonstrando que ambos estão funcionando
  await EngineAnalytics.logEvent('mixed_init_demo', {'method': 'adapters'});
  await EngineBugTracking.log('Mixed initialization demo', attributes: {'method': 'model'});
}
