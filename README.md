# Engine Tracking

Uma biblioteca Flutter completa para tracking de analytics e bug reporting, oferecendo integração com Firebase Analytics, Firebase Crashlytics e Grafana Faro.

## 🚀 Características

- **Analytics Dual**: Suporte simultâneo para Firebase Analytics e Grafana Faro
- **Bug Tracking Avançado**: Integração com Firebase Crashlytics e Grafana Faro para monitoramento de erros
- **Configuração Flexível**: Ative/desative serviços individualmente através de configurações
- **Logging Estruturado**: Sistema de logs com diferentes níveis e contextos
- **Tipo-seguro**: Implementação completamente tipada em Dart
- **Arquitetura Consistente**: Padrão unificado entre Analytics e Bug Tracking

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.0.0
```

## 🛠️ Configuração

### Analytics

#### 1. Configuração Básica

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Configuração apenas com Firebase Analytics
final analyticsModel = EngineAnalyticsModel(
  firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
  faroConfig: const EngineFaroConfig(
    enabled: false,
    endpoint: '',
    appName: '',
    appVersion: '',
    environment: '',
    apiKey: '',
  ),
);

await EngineAnalytics.init(analyticsModel);
```

#### 2. Configuração Completa (Firebase + Faro)

```dart
final analyticsModel = EngineAnalyticsModel(
  firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
  faroConfig: const EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.grafana.net/collect',
    appName: 'MeuApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'sua-chave-api-faro',
  ),
);

await EngineAnalytics.init(analyticsModel);
```

### Bug Tracking

#### 1. Configuração Básica

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Configuração apenas com Crashlytics
final bugTrackingModel = EngineBugTrackingModel(
  crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
  faroConfig: const EngineFaroConfig(
    enabled: false,
    endpoint: '',
    appName: '',
    appVersion: '',
    environment: '',
    apiKey: '',
  ),
);

await EngineBugTracking.init(bugTrackingModel);
```

#### 2. Configuração Completa (Crashlytics + Faro)

```dart
final bugTrackingModel = EngineBugTrackingModel(
  crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
  faroConfig: const EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.grafana.net/collect',
    appName: 'MeuApp',
    appVersion: '1.0.0',
    environment: 'production',
    apiKey: 'sua-chave-api-faro',
  ),
);

await EngineBugTracking.init(bugTrackingModel);
```

## 📊 Uso - Analytics

### Logging de Eventos

```dart
// Evento simples
await EngineAnalytics.logEvent('button_clicked');

// Evento com parâmetros
await EngineAnalytics.logEvent('purchase_completed', {
  'item_id': 'premium_plan',
  'value': 29.99,
  'currency': 'BRL',
});

// Abrir app
await EngineAnalytics.logAppOpen();
```

### Gerenciamento de Usuário

```dart
// Definir ID do usuário
await EngineAnalytics.setUserId('user_12345');

// Com informações adicionais (para Faro)
await EngineAnalytics.setUserId(
  'user_12345',
  'usuario@exemplo.com',
  'João Silva',
);

// Propriedade do usuário
await EngineAnalytics.setUserProperty('user_type', 'premium');
```

### Navegação de Telas

```dart
// Tela simples
await EngineAnalytics.setPage('HomeScreen');

// Com contexto completo
await EngineAnalytics.setPage(
  'ProductScreen',      // Tela atual
  'HomeScreen',        // Tela anterior
  'ECommerceApp',      // Classe da tela
);
```

### Verificação de Status

```dart
// Verificar se analytics está habilitado
if (EngineAnalytics.isEnabled) {
  print('Analytics está ativo');
}

// Verificar serviços específicos
if (EngineAnalytics.isFirebaseAnalyticsEnabled) {
  print('Firebase Analytics ativo');
}

if (EngineAnalytics.isFaroEnabled) {
  print('Faro Analytics ativo');
}
```

## 🐛 Uso - Bug Tracking

### Logging Estruturado

```dart
// Log simples
await EngineBugTracking.log('Usuário fez login');

// Log com contexto
await EngineBugTracking.log(
  'Erro no processamento de pagamento',
  level: 'error',
  attributes: {
    'user_id': 'user_12345',
    'payment_method': 'credit_card',
    'amount': 29.99,
  },
  stackTrace: StackTrace.current,
);
```

### Gerenciamento de Usuário

```dart
// Definir informações do usuário
await EngineBugTracking.setUserIdentifier(
  'user_12345',
  'usuario@exemplo.com',
  'João Silva',
);

// Chaves customizadas
await EngineBugTracking.setCustomKey('plan_type', 'premium');
await EngineBugTracking.setCustomKey('last_login', DateTime.now().toString());
```

### Tratamento de Erros

```dart
// Captura manual de erro
try {
  await riskyOperation();
} catch (error, stackTrace) {
  await EngineBugTracking.recordError(
    error,
    stackTrace,
    reason: 'Falha na operação crítica',
    information: ['Contexto adicional'],
    isFatal: false,
    data: {'operation_id': '12345'},
  );
}

// Tratamento de erros Flutter
FlutterError.onError = EngineBugTracking.recordFlutterError;
```

### Teste de Crash (Debug)

```dart
// Apenas em modo debug
await EngineBugTracking.testCrash();
```

## 🏗️ Exemplo Completo de Inicialização

```dart
import 'package:flutter/material.dart';
import 'package:engine_tracking/engine_tracking.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar Analytics
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'MeuApp',
      appVersion: '1.2.3',
      environment: 'production',
      apiKey: 'faro-api-key',
    ),
  );
  
  // Configurar Bug Tracking
  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'MeuApp',
      appVersion: '1.2.3',
      environment: 'production',
      apiKey: 'faro-api-key',
    ),
  );
  
  // Inicializar serviços
  await Future.wait([
    EngineAnalytics.init(analyticsModel),
    EngineBugTracking.init(bugTrackingModel),
  ]);
  
  // Configurar usuário
  await Future.wait([
    EngineAnalytics.setUserId('user_12345', 'user@exemplo.com', 'João Silva'),
    EngineBugTracking.setUserIdentifier('user_12345', 'user@exemplo.com', 'João Silva'),
  ]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Tracking Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Registrar visualização da tela
    EngineAnalytics.setPage('HomeScreen');
  }

  void _onButtonPressed() async {
    // Registrar evento
    await EngineAnalytics.logEvent('button_pressed', {
      'button_name': 'home_action',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    // Log personalizado
    await EngineBugTracking.log(
      'Botão pressionado na tela inicial',
      level: 'info',
      attributes: {'screen': 'home'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Engine Tracking Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _onButtonPressed,
          child: Text('Testar Tracking'),
        ),
      ),
    );
  }
}
```

## 🏗️ Arquitetura do Projeto

### Estrutura Interna

O projeto segue uma arquitetura consistente e bem organizada:

```
lib/
├── src/
│   ├── analytics/
│   │   ├── engine_analytics.dart        # Serviço principal de analytics
│   │   └── analytics.dart              # Export barrel
│   ├── bug_tracking/
│   │   ├── engine_bug_tracking.dart    # Serviço principal de bug tracking
│   │   └── bug_tracking.dart           # Export barrel
│   ├── config/                         # Configurações dos serviços
│   │   ├── engine_firebase_analytics_config.dart
│   │   ├── engine_crashlytics_config.dart
│   │   └── engine_faro_config.dart
│   ├── models/                         # Modelos de dados
│   │   ├── engine_analytics_model.dart
│   │   └── engine_bug_tracking_model.dart
│   ├── enums/                          # Enumerações
│   │   └── engine_log_level_type.dart
│   ├── logging/                        # Sistema de logging
│   │   └── engine_log.dart
│   └── observers/                      # Observadores Flutter
└── engine_tracking.dart                # Export principal
```

### Padrões Arquiteturais

- **Construtor Privado**: Classes principais (`EngineAnalytics`, `EngineBugTracking`) usam construtores privados
- **Métodos Estáticos**: Todas as funcionalidades públicas são estáticas
- **Inicialização Condicional**: Serviços são inicializados apenas se habilitados na configuração
- **Export Unificado**: Todos os imports podem ser feitos através de `package:engine_tracking/engine_tracking.dart`
- **Configuração Tipada**: Uso de classes específicas para cada tipo de configuração

## 🔧 Configurações Avançadas

### Configuração Padrão

Use as implementações padrão para desenvolvimento:

```dart
// Analytics com configuração padrão (tudo desabilitado)
final defaultAnalytics = EngineAnalyticsModelDefault();
await EngineAnalytics.init(defaultAnalytics);

// Bug tracking com configuração padrão (tudo desabilitado)
final defaultBugTracking = EngineBugTrackingModelDefault();
await EngineBugTracking.init(defaultBugTracking);
```

### Configuração por Ambiente

```dart
class TrackingConfig {
  static EngineAnalyticsModel getAnalyticsConfig(String environment) {
    final isProduction = environment == 'production';
    
    return EngineAnalyticsModel(
      firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(enabled: isProduction),
      faroConfig: EngineFaroConfig(
        enabled: isProduction,
        endpoint: isProduction 
          ? 'https://faro-prod.grafana.net/collect'
          : 'https://faro-dev.grafana.net/collect',
        appName: 'MeuApp',
        appVersion: '1.0.0',
        environment: environment,
        apiKey: isProduction ? 'prod-key' : 'dev-key',
      ),
    );
  }
}
```

## 🧪 Testes

Execute os testes:

```bash
flutter test
```

Para cobertura de testes:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📱 Plataformas Suportadas

- ✅ iOS
- ✅ Android


## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🔗 Links Úteis

- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
- [Grafana Faro](https://grafana.com/docs/faro/)
- [Flutter](https://flutter.dev/)


## 📞 Suporte

Para suporte, envie um email para support@tech.stmr ou abra uma issue no GitHub.

---

Desenvolvido com ❤️ pela equipe STMR 