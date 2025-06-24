# Engine Tracking

[![pub.dev](https://img.shields.io/pub/v/engine_tracking.svg)](https://pub.dev/packages/engine_tracking)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.32.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)

Uma biblioteca Flutter completa para **tracking de analytics** e **bug reporting**, oferecendo integração com Firebase Analytics, Firebase Crashlytics e Grafana Faro.

## 🚀 Características Principais

- 📊 **Analytics Dual**: Suporte simultâneo para Firebase Analytics e Grafana Faro
- 🐛 **Bug Tracking Avançado**: Integração com Firebase Crashlytics e Grafana Faro para monitoramento de erros
- ⚙️ **Configuração Flexível**: Ative/desative serviços individualmente através de configurações
- 📝 **Logging Estruturado**: Sistema de logs com diferentes níveis e contextos
- 🔒 **Tipo-seguro**: Implementação completamente tipada em Dart
- 🧪 **Testável**: Cobertura de testes superior a 95% para componentes testáveis
- 🏗️ **Arquitetura Consistente**: Padrão unificado entre Analytics e Bug Tracking
- 🎯 **Inicialização Condicional**: Serviços são inicializados apenas se habilitados na configuração
- 📦 **Export Unificado**: Todos os imports podem ser feitos através de `package:engine_tracking/engine_tracking.dart`

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.0.0
```

Execute:

```bash
flutter pub get
```

## 📊 Analytics

O `EngineAnalytics` oferece integração com Firebase Analytics e Grafana Faro para tracking completo de eventos e comportamento do usuário.

### 🎯 Configuração Básica

```dart
import 'package:engine_tracking/engine_tracking.dart';

Future<void> setupAnalytics() async {
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
}
```

### 📈 Logging de Eventos

```dart
// Evento simples
await EngineAnalytics.logEvent('button_clicked');

// Evento com parâmetros
await EngineAnalytics.logEvent('purchase_completed', {
  'item_id': 'premium_plan',
  'value': 29.99,
  'currency': 'BRL',
  'category': 'subscription',
});

// Evento de abertura do app
await EngineAnalytics.logAppOpen();
```

### 👤 Gerenciamento de Usuário

```dart
// Definir ID do usuário
await EngineAnalytics.setUserId('user_12345');

// Com informações completas (para Faro)
await EngineAnalytics.setUserId(
  'user_12345',
  'usuario@exemplo.com',
  'João Silva',
);

// Propriedades do usuário
await EngineAnalytics.setUserProperty('user_type', 'premium');
await EngineAnalytics.setUserProperty('plan', 'monthly');
```

### 🧭 Navegação de Telas

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

### ✅ Verificação de Status

```dart
// Verificar se analytics está habilitado
if (EngineAnalytics.isEnabled) {
  print('✅ Analytics está ativo');
}

// Verificar serviços específicos
if (EngineAnalytics.isFirebaseAnalyticsEnabled) {
  print('🔥 Firebase Analytics ativo');
}

if (EngineAnalytics.isFaroEnabled) {
  print('📊 Faro Analytics ativo');
}
```

## 🐛 Bug Tracking

O `EngineBugTracking` oferece captura e logging de erros usando Firebase Crashlytics e Grafana Faro.

### ⚙️ Configuração Básica

```dart
import 'package:engine_tracking/engine_tracking.dart';

Future<void> setupBugTracking() async {
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
}
```

### 📝 Logging Estruturado

```dart
// Log simples
await EngineBugTracking.log('Usuário fez login');

// Log com contexto detalhado
await EngineBugTracking.log(
  'Erro no processamento de pagamento',
  level: 'error',
  attributes: {
    'user_id': 'user_12345',
    'payment_method': 'credit_card',
    'amount': 29.99,
    'transaction_id': 'txn_abc123',
  },
  stackTrace: StackTrace.current,
);
```

### 👤 Gerenciamento de Usuário

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
await EngineBugTracking.setCustomKey('device_type', 'mobile');
```

### 🚨 Tratamento de Erros

```dart
// Captura manual de erro
try {
  await riskyOperation();
} catch (error, stackTrace) {
  await EngineBugTracking.recordError(
    error,
    stackTrace,
    reason: 'Falha na operação crítica',
    information: ['Contexto adicional', 'Dados do usuário'],
    isFatal: false,
    data: {
      'operation_id': '12345',
      'user_id': 'user_123',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

// Tratamento global de erros Flutter
FlutterError.onError = EngineBugTracking.recordFlutterError;
```

### 🧪 Teste de Crash (Debug)

```dart
// Apenas em modo debug para testar integração
#if DEBUG
await EngineBugTracking.testCrash();
#endif
```

## 📋 Logging do Sistema

O `EngineLog` oferece sistema de logging estruturado com diferentes níveis.

### 📊 Níveis de Log

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Debug
await EngineLog.debug('Debug message', data: {'key': 'value'});

// Info
await EngineLog.info('Info message', data: {'status': 'success'});

// Warning
await EngineLog.warning('Warning message', error: exception);

// Error
await EngineLog.error('Error message', error: exception, stackTrace: stackTrace);

// Fatal
await EngineLog.fatal('Fatal error', error: exception, stackTrace: stackTrace);
```

### 🏷️ Níveis Disponíveis

| Nível | Valor | Uso Recomendado |
|-------|-------|-----------------|
| `debug` | 100 | Informações de desenvolvimento |
| `info` | 800 | Informações gerais |
| `warning` | 900 | Avisos e situações inesperadas |
| `error` | 1000 | Erros recuperáveis |
| `fatal` | 1200 | Erros críticos do sistema |

## 🔧 Configuração Avançada

### 🏗️ Configuração por Ambiente

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

  static EngineBugTrackingModel getBugTrackingConfig(String environment) {
    final isProduction = environment == 'production';
    
    return EngineBugTrackingModel(
      crashlyticsConfig: EngineCrashlyticsConfig(enabled: isProduction),
      faroConfig: EngineFaroConfig(
        enabled: true, // Faro sempre ativo para debugging
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

### 🎛️ Configuração Padrão

```dart
// Analytics com configuração padrão (tudo desabilitado)
final defaultAnalytics = EngineAnalyticsModelDefault();
await EngineAnalytics.init(defaultAnalytics);

// Bug tracking com configuração padrão (tudo desabilitado)
final defaultBugTracking = EngineBugTrackingModelDefault();
await EngineBugTracking.init(defaultBugTracking);
```

## 📊 Modelos de Dados

### EngineAnalyticsModel

```dart
class EngineAnalyticsModel {
  final EngineFirebaseAnalyticsConfig firebaseAnalyticsConfig;
  final EngineFaroConfig faroConfig;
  
  EngineAnalyticsModel({
    required this.firebaseAnalyticsConfig,
    required this.faroConfig,
  });
}

class EngineAnalyticsModelDefault implements EngineAnalyticsModel {
  // Implementação com valores padrão desabilitados
}
```

### EngineBugTrackingModel

```dart
class EngineBugTrackingModel {
  final EngineCrashlyticsConfig crashlyticsConfig;
  final EngineFaroConfig faroConfig;
  
  EngineBugTrackingModel({
    required this.crashlyticsConfig,
    required this.faroConfig,
  });
}

class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  // Implementação com valores padrão desabilitados
}
```

### Configurações de Serviços

```dart
// Firebase Analytics
class EngineFirebaseAnalyticsConfig {
  final bool enabled;
  
  const EngineFirebaseAnalyticsConfig({required this.enabled});
}

// Firebase Crashlytics
class EngineCrashlyticsConfig {
  final bool enabled;
  
  const EngineCrashlyticsConfig({required this.enabled});
}

// Grafana Faro (Compartilhado)
class EngineFaroConfig {
  final bool enabled;
  final String endpoint;
  final String appName;
  final String appVersion;
  final String environment;
  final String apiKey;
  
  const EngineFaroConfig({
    required this.enabled,
    required this.endpoint,
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.apiKey,
  });
}
```

### EngineLogLevelType

```dart
enum EngineLogLevelType {
  debug('DEBUG', 100),
  info('INFO', 800),
  warning('WARNING', 900),
  error('ERROR', 1000),
  fatal('FATAL', 1200);

  final String name;
  final int value;
  
  const EngineLogLevelType(this.name, this.value);
}
```

## 📱 Exemplo Completo

Execute o exemplo interativo:

```bash
cd example
flutter run
```

### 🏗️ Implementação Completa

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
  
  // Configurar tratamento global de erros
  FlutterError.onError = EngineBugTracking.recordFlutterError;
  
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
    // Registrar evento de analytics
    await EngineAnalytics.logEvent('button_pressed', {
      'button_name': 'home_action',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'user_journey_step': 'main_interaction',
    });
    
    // Log para debugging
    await EngineBugTracking.log(
      'Botão pressionado na tela inicial',
      level: 'info',
      attributes: {'screen': 'home', 'action': 'button_press'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Engine Tracking Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onButtonPressed,
              child: Text('Testar Tracking'),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Status dos Serviços:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
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
    return Row(
      children: [
        Icon(
          isEnabled ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isEnabled ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Text('$service: ${isEnabled ? 'Enabled' : 'Disabled'}'),
      ],
    );
  }
}
```

## 🏗️ Estrutura do Projeto

### 📁 Organização de Diretórios e Arquivos

```
engine-tracking/
├── .github/                     # 🔧 Automação e Templates GitHub
│   ├── workflows/               # 🔄 GitHub Actions Pipelines
│   │   ├── ci.yml              # Pipeline principal CI/CD
│   │   ├── publish.yml         # Publicação automática pub.dev
│   │   └── quality.yml         # Auditorias semanais de qualidade
│   ├── ISSUE_TEMPLATE/         # 📝 Templates de Issues
│   │   ├── bug_report.md       # Template para reportar bugs
│   │   └── feature_request.md  # Template para solicitar funcionalidades
│   ├── pull_request_template.md # Template para Pull Requests
│   └── README.md               # Documentação da infraestrutura CI/CD
├── lib/                        # 📚 Código fonte principal
│   ├── engine_tracking.dart    # 🚪 Ponto de entrada principal
│   └── src/                    # 📦 Implementações internas
│       ├── src.dart            # Export barrel centralizado
│       ├── analytics/          # 📊 Sistema de Analytics
│       │   ├── analytics.dart  # Export barrel do módulo
│       │   └── engine_analytics.dart # Implementação principal
│       ├── bug_tracking/       # 🐛 Sistema de Bug Tracking
│       │   ├── bug_tracking.dart # Export barrel do módulo
│       │   └── engine_bug_tracking.dart # Implementação principal
│       ├── config/             # ⚙️ Configurações dos serviços
│       │   ├── config.dart     # Export barrel das configurações
│       │   ├── engine_firebase_analytics_config.dart
│       │   ├── engine_crashlytics_config.dart
│       │   └── engine_faro_config.dart
│       ├── models/             # 🏗️ Modelos de dados
│       │   ├── models.dart     # Export barrel dos modelos
│       │   ├── engine_analytics_model.dart
│       │   └── engine_bug_tracking_model.dart
│       ├── enums/              # 🏷️ Enumerações
│       │   ├── enums.dart      # Export barrel das enumerações
│       │   └── engine_log_level_type.dart
│       ├── logging/            # 📝 Sistema de logging
│       │   ├── logging.dart    # Export barrel do logging
│       │   └── engine_log.dart # Implementação de logs
│       └── observers/          # 👁️ Observadores Flutter
│           ├── observers.dart  # Export barrel dos observadores
│           └── engine_navigator_observer.dart
├── test/                       # 🧪 Testes unitários e de integração
│   ├── analytics/              # Testes do sistema de analytics
│   ├── bug_tracking/           # Testes do sistema de bug tracking
│   ├── config/                 # Testes das configurações
│   ├── models/                 # Testes dos modelos de dados
│   ├── logging/                # Testes do sistema de logging
│   └── test_coverage.dart      # Suite completa de testes
├── example/                    # 📱 Aplicação de exemplo
│   ├── lib/main.dart          # App Flutter demonstrativo
│   ├── pubspec.yaml           # Dependências do exemplo
│   └── README.md              # Documentação do exemplo
├── scripts/                    # 🛠️ Scripts de desenvolvimento
│   ├── test_coverage.sh       # Script de cobertura de testes
│   └── pana_analysis.sh       # Script de análise de qualidade
├── codecov.yml                # 📊 Configuração Codecov
├── pana_config.yaml          # 🔍 Configuração Pana
├── pubspec.yaml              # 📦 Configuração do pacote
├── CHANGELOG.md              # 📝 Histórico de mudanças
├── LICENSE                   # ⚖️ Licença MIT
├── README.md                 # 📖 Documentação principal
└── analysis_options.yaml    # 🔬 Configuração do Dart Analyzer
```

#### ⚙️ Arquivos de Configuração

##### 📊 `codecov.yml` - Cobertura de Código
- Meta de cobertura: 45% (ajustada para dependências externas)
- Exclusões: Arquivos gerados, testes, exemplos
- Integração com PRs para comentários automáticos

##### 🔍 `pana_config.yaml` - Análise de Qualidade
- Padrão de excelência: 160/160 pontos
- Verificações completas habilitadas
- Exclusão de arquivos de desenvolvimento

##### 📦 `pubspec.yaml` - Configuração do Pacote
- Dependências otimizadas
- Metadados completos para pub.dev
- Compatibilidade com Flutter >=3.32.0 e Dart >=3.8.0

### 🎯 Arquitetura e Padrões

#### 🏗️ Padrões Arquiteturais
- **Construtor Privado**: Previne instanciação desnecessária
- **API Estática**: Métodos estáticos para facilidade de uso
- **Inicialização Condicional**: Serviços inicializam apenas se habilitados
- **Export Unificado**: Import único para todo o pacote

#### 🔒 Princípios de Qualidade
- **Tipo-seguro**: Implementação completamente tipada
- **Testável**: Arquitetura focada em testabilidade
- **Configurável**: Flexibilidade total na configuração
- **Performático**: Inicialização sob demanda

## 🔧 Desenvolvimento

### 📁 Estrutura Técnica

```
lib/
├── engine_tracking.dart           # Ponto de entrada principal
└── src/
    ├── src.dart                    # Exportações centralizadas
    ├── analytics/                  # Sistema de analytics
    │   ├── analytics.dart          # Export barrel
    │   └── engine_analytics.dart   # Implementação principal
    ├── bug_tracking/               # Sistema de bug tracking
    │   ├── bug_tracking.dart       # Export barrel
    │   └── engine_bug_tracking.dart # Implementação principal
    ├── config/                     # Configurações dos serviços
    │   ├── config.dart             # Export barrel
    │   ├── engine_firebase_analytics_config.dart
    │   ├── engine_crashlytics_config.dart
    │   └── engine_faro_config.dart
    ├── models/                     # Modelos de dados
    │   ├── models.dart             # Export barrel
    │   ├── engine_analytics_model.dart
    │   └── engine_bug_tracking_model.dart
    ├── enums/                      # Enumerações
    │   ├── enums.dart              # Export barrel
    │   └── engine_log_level_type.dart
    ├── logging/                    # Sistema de logging
    │   ├── logging.dart            # Export barrel
    │   └── engine_log.dart         # Implementação de logging
    └── observers/                  # Observadores Flutter
        ├── observers.dart          # Export barrel
        └── engine_navigator_observer.dart

test/
├── analytics/                      # Testes de analytics
├── bug_tracking/                   # Testes de bug tracking
├── config/                         # Testes de configuração
├── models/                         # Testes de modelos
├── logging/                        # Testes de logging
└── test_coverage.dart              # Suite completa de testes

example/                            # App de demonstração
├── lib/main.dart                   # Implementação de exemplo
├── pubspec.yaml                    # Dependências do exemplo
└── README.md                       # Documentação do exemplo
```

# Sistema de Tracking de Views

Este sistema fornece funcionalidades automáticas de tracking para widgets StatelessWidget e StatefulWidget, permitindo monitorar o comportamento do usuário passo a passo.

## 🎯 Widget Tracking

O Engine Tracking oferece um sistema avançado de tracking automático para widgets, permitindo monitoramento transparente de navegação, ações do usuário e ciclo de vida de telas.

### Características dos Widgets

- 📊 **Tracking Automático**: Visualizações de tela registradas automaticamente
- 🔄 **Ciclo de Vida**: Monitoramento de init/dispose em StatefulWidgets  
- 👆 **Ações do Usuário**: Métodos integrados para logging de interações
- 📝 **Eventos Customizados**: Sistema flexível para eventos específicos
- 🐛 **Tratamento de Erros**: Captura contextualizada de erros por tela
- ⚙️ **Configurável**: Controle granular sobre tracking automático

### Implementações Disponíveis

#### 1. Classes Base (Recomendado)

As classes base oferecem implementação completa com tracking automático integrado.

##### StatelessWidget Base

```dart
import 'package:engine_tracking/engine_tracking.dart';

class HomePage extends EngineStatelessWidgetBase {
  const HomePage({super.key});

  @override
  String get screenName => 'home_page';

  @override
  Map<String, dynamic>? get screenParameters => {
    'version': '1.0.0',
    'source': 'main_menu',
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              logUserAction('button_pressed', parameters: {
                'button_type': 'primary',
                'action': 'navigate_to_settings',
              });
            },
            child: const Text('Configurações'),
          ),
          ElevatedButton(
            onPressed: () {
              logCustomEvent('feature_accessed', parameters: {
                'feature': 'premium_content',
              });
            },
            child: const Text('Conteúdo Premium'),
          ),
        ],
      ),
    );
  }
}
```

##### StatefulWidget Base

```dart
import 'package:engine_tracking/engine_tracking.dart';

class ProfilePage extends EngineStatefulWidget {
  const ProfilePage({super.key});

  @override
  EngineStatefulWidgetState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends EngineStatefulWidgetState<ProfilePage> {
  String _userName = '';
  
  @override
  String get screenName => 'profile_page';

  @override
  Map<String, dynamic>? get screenParameters => {
    'user_type': 'premium',
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                _userName = value;
              });
              
              logStateChange('username_changed', additionalData: {
                'character_count': value.length,
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              logUserAction('profile_updated', parameters: {
                'field': 'username',
                'new_length': _userName.length,
              });
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
```

### Exemplo Completo com Classes Base

```dart
import 'package:engine_tracking/engine_tracking.dart';

class SettingsPage extends EngineStatelessWidgetBase {
  const SettingsPage({super.key});

  @override
  String get screenName => 'settings_page';

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notificações'),
            onTap: () => logUserAction('settings_item_tapped', 
              parameters: {'item': 'notifications'}),
          ),
          ListTile(
            title: const Text('Privacidade'),
            onTap: () => logUserAction('settings_item_tapped', 
              parameters: {'item': 'privacy'}),
          ),
        ],
      ),
    );
  }
}
```

```dart
import 'package:engine_tracking/engine_tracking.dart';

class LoginPage extends EngineStatefulWidget {
  const LoginPage({super.key});

  @override
  EngineStatefulWidgetState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends EngineStatefulWidgetState<LoginPage> {
  bool _isLoading = false;

  @override
  String get screenName => 'login_page';

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Email'),
            onSubmitted: (value) {
              logUserAction('field_completed', parameters: {
                'field': 'email',
                'has_value': value.isNotEmpty,
              });
            },
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : () async {
              setState(() {
                _isLoading = true;
              });
              
              logStateChange('login_started');
              
              try {
                await Future.delayed(const Duration(seconds: 2));
                logUserAction('login_success');
              } catch (e) {
                logScreenError('Login falhou', 
                  exception: e, 
                  additionalData: {'retry_count': 1});
              }
              
              setState(() {
                _isLoading = false;
              });
            },
            child: _isLoading 
              ? const CircularProgressIndicator() 
              : const Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
```

## Métodos Disponíveis

### Tracking Automático
- `_trackScreenView()`: Registra visualização da tela automaticamente
- **Ciclo de vida**: initState/dispose tracking (apenas StatefulWidget)

### Métodos de Logging
- `logUserAction(action, {parameters})`: Registra ações do usuário
- `logCustomEvent(eventName, {parameters})`: Registra eventos customizados
- `logScreenError(error, {exception, stackTrace, additionalData})`: Registra erros
- `logStateChange(description, {additionalData})`: Registra mudanças de estado (StatefulWidget)

### Configurações
- `screenName`: Nome da tela (padrão: nome da classe)
- `screenParameters`: Parâmetros adicionais da tela
- `enableAutoTracking`: Ativa/desativa tracking automático
- `enableLifecycleTracking`: Ativa/desativa tracking de ciclo de vida (StatefulWidget)

## Dados Coletados

### Visualização de Tela
```json
{
  "screen_name": "home_page",
  "screen_type": "StatelessWidget",
  "timestamp": "2023-12-01T10:30:00.000Z",
  "parameters": {"version": "1.0.0"}
}
```

### Ação do Usuário
```json
{
  "screen_name": "home_page",
  "action": "button_pressed",
  "widget_type": "StatelessWidget",
  "button_type": "primary"
}
```

### Fechamento de Tela (StatefulWidget)
```json
{
  "screen_name": "profile_page",
  "widget_type": "StatefulWidget",
  "time_spent_seconds": 45,
  "time_spent_minutes": 0
}
```

## Integração com Analytics

Todos os eventos são automaticamente enviados para:
- **Firebase Analytics** (se configurado)
- **Grafana Faro** (se configurado)
- **Splunk** (se configurado)
- **Engine Log** para debugging

## Melhores Práticas

1. **Use nomes descritivos** para telas e ações
2. **Inclua parâmetros relevantes** sem dados sensíveis
3. **Monitore erros** com contexto apropriado
4. **Use classes base** para funcionalidade completa
5. **Personalize screenName** para identificação clara
6. **Agrupe ações relacionadas** com prefixos consistentes

## Desabilitando Tracking

```dart
class MyPage extends EngineStatelessWidgetBase {
  const MyPage({super.key});
  
  @override
  bool get enableAutoTracking => false; // Desabilita tracking automático
  
  @override
  Widget buildWithTracking(BuildContext context) {
    // ... resto da implementação
  }
}
```

## Exemplo de Uso Avançado

```dart
class ShoppingCartPage extends StatefulWidget {
  final List<Product> initialProducts;
  
  const ShoppingCartPage({super.key, required this.initialProducts});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends EngineStatefulWidgetState<ShoppingCartPage> {
  
  late List<Product> _products;
  
  @override
  void initState() {
    super.initState();
    _products = List.from(widget.initialProducts);
  }
  
  @override
  String get screenName => 'shopping_cart';

  @override
  Map<String, dynamic>? get screenParameters => {
    'initial_product_count': widget.initialProducts.length,
    'cart_value': _calculateTotal(),
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  _products.removeAt(index);
                });
                
                logUserAction('product_removed', parameters: {
                  'product_id': product.id,
                  'product_name': product.name,
                  'remaining_count': _products.length,
                });
                
                logStateChange('cart_updated', additionalData: {
                  'action': 'removal',
                  'new_total': _calculateTotal(),
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logUserAction('checkout_initiated', parameters: {
            'product_count': _products.length,
            'total_value': _calculateTotal(),
          });
        },
        child: const Icon(Icons.shopping_cart_checkout),
      ),
    );
  }
  
  double _calculateTotal() {
    return _products.fold(0.0, (sum, product) => sum + product.price);
  }
}
```

### 🧪 Scripts de Desenvolvimento

```bash
# Executar todos os testes
flutter test

# Testes com cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Análise estática
dart analyze

# Formatação de código
dart format .

# Publicar (dry-run)
dart pub publish --dry-run
```

### 📊 Comandos de Qualidade

```bash
# Verificar cobertura
dart pub global activate test_coverage
dart pub global run test_coverage --min-coverage=95

# Análise Pana
dart pub global activate pana
dart pub global run pana

# Verificar dependências
dart pub outdated

# Atualizar dependências
dart pub upgrade
```

## 🧪 Testes

Execute os testes:

```bash
flutter test
```

**Status dos Testes:**
- ✅ **83 testes passando** (100% dos testes implementados)
- ✅ **Testes otimizados** para integração Firebase/Faro (evitam dependências externas)
- ✅ **100% de cobertura** nos arquivos de configuração e modelos
- ✅ **Testes completos** para sistema de logging

**Observações:**
- Testes de inicialização com Firebase/Faro são mocados para evitar dependências reais
- Todos os testes de lógica de negócio e configuração passam corretamente
- Cobertura focada em componentes testáveis sem dependências externas

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

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### 📋 Diretrizes de Contribuição

- Mantenha 95%+ de cobertura de testes
- Siga o padrão de código existente
- Documente novas funcionalidades
- Teste em Android e iOS
- Atualize o CHANGELOG.md

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

## 🏢 Sobre a STMR

Desenvolvido pela STMR - Especialistas em soluções móveis.

---

**💡 Dica**: Para máxima eficiência, configure apenas os serviços que você realmente utiliza. A biblioteca é otimizada para funcionar com qualquer combinação de serviços habilitados ou desabilitados. 