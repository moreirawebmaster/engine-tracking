import 'package:engine_tracking/engine_tracking.dart';

void analyticsFlexibleExample() async {
  // Exemplo 1: Usando apenas Firebase Analytics
  final firebaseAdapter = EngineFirebaseAnalyticsAdapter(
    const EngineFirebaseAnalyticsConfig(enabled: true),
  );

  await EngineAnalytics.init([firebaseAdapter]);

  // Exemplo 2: Usando múltiplos adapters
  final adapters = [
    EngineFirebaseAnalyticsAdapter(
      const EngineFirebaseAnalyticsConfig(enabled: true),
    ),
    EngineFaroAnalyticsAdapter(
      const EngineFaroConfig(
        enabled: true,
        endpoint: 'https://faro-collector.grafana.net/collect',
        appName: 'MyApp',
        appVersion: '1.0.0',
        environment: 'production',
        apiKey: 'your-api-key',
      ),
    ),
    EngineSplunkAnalyticsAdapter(
      const EngineSplunkConfig(
        enabled: true,
        endpoint: 'https://splunk-hec.example.com:8088/services/collector',
        token: 'your-hec-token',
        source: 'mobile-app',
        sourcetype: 'json',
        index: 'main',
      ),
    ),
  ];

  await EngineAnalytics.init(adapters);

  // Exemplo 3: Usando o modelo tradicional (compatibilidade)
  final model = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'MyApp',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'your-api-key',
    ),
    splunkConfig: const EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
  );

  await EngineAnalytics.initWithModel(model);

  // Verificar status
  print('Analytics habilitado: ${EngineAnalytics.isEnabled}');
  print('Analytics inicializado: ${EngineAnalytics.isInitialized}');

  // Usar normalmente - todos os providers ativos receberão os eventos
  await EngineAnalytics.logEvent('user_action', {'type': 'button_click'});
  await EngineAnalytics.setUserId('user123', 'user@example.com', 'João Silva');

  // Eventos customizados seguindo padrão Firebase
  await EngineAnalytics.logEvent('purchase', {
    'transaction_id': 'txn_123',
    'currency': 'BRL',
    'value': 99.99,
    'items': [
      {'item_id': 'product_1', 'item_name': 'Product 1', 'price': 99.99},
    ],
  });

  await EngineAnalytics.logEvent('login', {'method': 'google'});
  await EngineAnalytics.logEvent('sign_up', {'method': 'email'});

  // Navegação
  await EngineAnalytics.setPage('home_screen', 'welcome_screen', {
    'screen_class': 'MainNavigator',
    'feature_enabled': true,
  });

  // App lifecycle
  await EngineAnalytics.logAppOpen({'campaign': 'push_notification'});

  // Limpar recursos
  await EngineAnalytics.dispose();
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

void customAdapterExample() async {
  // Exemplo de adapter personalizado
  final customAdapter = CustomAnalyticsAdapter(enabled: true);

  await EngineAnalytics.init([customAdapter]);

  await EngineAnalytics.logEvent('custom_event', {'custom_param': 'value'});

  await EngineAnalytics.dispose();
}
