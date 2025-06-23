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

## 🔧 Desenvolvimento

### 📁 Estrutura do Projeto

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