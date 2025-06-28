# Engine Tracking

[![pub.dev](https://img.shields.io/pub/v/engine_tracking.svg)](https://pub.dev/packages/engine_tracking)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.32.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)

Uma biblioteca Flutter completa para **tracking de analytics** e **bug reporting**, oferecendo integração com Firebase Analytics, Firebase Crashlytics, Grafana Faro e Google Cloud Logging.

## 🚀 Características Principais

- 📊 **Analytics Múltiplo**: Suporte simultâneo para Firebase Analytics, Grafana Faro e Google Cloud Logging
- 🐛 **Bug Tracking Avançado**: Integração com Firebase Crashlytics, Grafana Faro e Google Cloud Logging para monitoramento completo
- 🌐 **HTTP Tracking**: Monitoramento automático de requisições HTTPS com métricas detalhadas
- 👁️ **View Tracking**: Sistema automático de tracking de telas com `EngineStatelessWidget` e `EngineStatefulWidget`
- ⚙️ **Configuração Flexível**: Ative/desative serviços individualmente através de configurações
- 📝 **Logging Estruturado**: Sistema de logs com diferentes níveis e contextos
- 🆔 **Session ID Automático**: UUID v4 único por abertura do app para correlação de logs e analytics
- 🔒 **Tipo-seguro**: Implementação completamente tipada em Dart
- 🧪 **Testável**: Cobertura de testes superior a 95% para componentes testáveis
- 🏗️ **Arquitetura Consistente**: Padrão unificado entre Analytics e Bug Tracking
- 🎯 **Inicialização Condicional**: Serviços são inicializados apenas se habilitados na configuração
- 📦 **Export Unificado**: Todos os imports podem ser feitos através de `package:engine_tracking/engine_tracking.dart`
- 🚀 **Exemplos Completos**: Apps de demonstração com casos de uso reais (HTTP + View Tracking)

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.3.0
```

Execute:

```bash
flutter pub get
```
  
## 🏗️ Arquitetura da Solução

### 🆔 Sistema de Session ID (Correlação Automática)

```mermaid
graph TD
    A["App Initialization"] --> B["EngineSession.instance"]
    B --> C["Generate UUID v4"]
    C --> D["xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"]
    
    D --> E["Session ID em Memória"]
    E --> F["Auto-inject Automático"]
    
    G["EngineAnalytics.logEvent()"] --> F
    H["EngineBugTracking.log()"] --> F
    I["EngineLog.info()"] --> F
    J["Firebase Analytics"] --> F
    K["Google Cloud Logging"] --> F
    L["Crashlytics"] --> F
    
    F --> M["Enrich Data"]
    M --> N["session_id: UUID v4"]
    
    N --> O["Firebase Analytics"]
    N --> P["Google Cloud Logging"] 
    N --> Q["Grafana Faro"]
    N --> R["Splunk"]
    N --> S["Crashlytics"]
    
    T["Correlação de Logs"] --> U["Mesmo session_id"]
    U --> V["Jornada Completa do Usuário"]
    
    style B fill:#e1f5fe
    style F fill:#f3e5f5
    style N fill:#e8f5e8
    style V fill:#fff3e0
```

### 📱 Widgets Stateless e Stateful com Tracking Automático

```mermaid
graph TD
    A["App"] --> B["EngineStatelessWidget"]
    A --> C["EngineStatefulWidget"]
    
    B --> D["buildWithTracking()"]
    C --> E["buildWithTracking()"]
    
    B --> F["Métodos Executáveis"]
    C --> G["Métodos Executáveis"]
    
    F --> H["logUserAction()"]
    F --> I["logCustomEvent()"]
    F --> J["logScreenError()"]
    
    G --> K["logUserAction()"]
    G --> L["logCustomEvent()"]
    G --> M["logScreenError()"]
    G --> N["logStateChange()"]
    
    H --> O["EngineLog.debug()"]
    I --> O
    J --> P["EngineLog.error()"]
    K --> O
    L --> O
    M --> P
    N --> O
    
    B --> Q["Lifecycle Tracking"]
    C --> R["Lifecycle Tracking"]
    
    Q --> S["screen_initialized"]
    Q --> T["screen_viewed"]
    Q --> U["screen_closed"]
    
    R --> V["screen_initialized"]
    R --> W["screen_viewed"]
    R --> X["screen_closed"]
    
    S --> O
    T --> O
    U --> O
    V --> O
    W --> O
    X --> O
```

### 📝 Sistema de Logging (EngineLog)

```mermaid
graph TD
    A["Aplicação"] --> B["EngineLog"]
    
    B --> C["debug()"]
    B --> D["info()"]
    B --> E["warning()"]
    B --> F["error()"]
    B --> G["fatal()"]
    
    C --> H["_logWithLevel()"]
    D --> H
    E --> H
    F --> H
    G --> H
    
    H --> I["developer.log()"]
    H --> J{{"EngineAnalytics.isEnabled && includeInAnalytics?"}}
    H --> K{{"EngineBugTracking.isEnabled?"}}
    
    J -->|Sim| L["EngineAnalytics.logEvent()"]
    J -->|Não| M["Skip Analytics"]
    
    K -->|Sim| N["EngineBugTracking.log()"]
    K -->|Não| O["Skip Bug Tracking"]
    
    L --> P["Firebase Analytics"]
    L --> Q["Grafana Faro"]
    L --> R["Splunk"]
    
    N --> S["Firebase Crashlytics"]
    N --> T["Grafana Faro Bug Tracking"]
    
    K -->|Sim| U{{"level == error || fatal?"}}
    U -->|Sim| V["EngineBugTracking.recordError()"]
    U -->|Não| W["Apenas log normal"]
    
    V --> X["Crash Reporting"]
    X --> S
    X --> T
    
    style J fill:#f9f,stroke:#333,stroke-width:2px
    style K fill:#f9f,stroke:#333,stroke-width:2px
    style U fill:#faa,stroke:#333,stroke-width:2px
    style V fill:#faa,stroke:#333,stroke-width:2px
```

### 📊 Sistema de Analytics (EngineAnalytics)

```mermaid
graph TD
    A["Aplicação"] --> B["EngineAnalytics"]
    
    B --> C["init()"]
    B --> D["logEvent()"]
    B --> E["setUserId()"]
    B --> F["setUserProperty()"]
    B --> G["setPage()"]
    B --> H["logAppOpen()"]
    
    C --> I["EngineAnalyticsModel"]
    I --> J["Firebase Analytics Config"]
    I --> K["Faro Config"]
    I --> L["Splunk Config"]
    
    D --> M["Adapters"]
    E --> M
    F --> M
    G --> M
    H --> M
    
    M --> N["EngineFirebaseAnalyticsAdapter"]
    M --> O["EngineFaroAnalyticsAdapter"]
    M --> P["EngineSplunkAnalyticsAdapter"]
    
    N --> Q["Firebase Analytics SDK"]
    O --> R["Grafana Faro SDK"]
    P --> S["Splunk SDK"]
    
    Q --> T["Google Analytics Dashboard"]
    R --> U["Grafana Dashboard"]
    S --> V["Splunk Dashboard"]
```

### 🐛 Sistema de Bug Tracking (EngineBugTracking)

```mermaid
graph TD
    A["Aplicação"] --> B["EngineBugTracking"]
    
    B --> C["init()"]
    B --> D["log()"]
    B --> E["recordError()"]
    B --> F["recordFlutterError()"]
    B --> G["setCustomKey()"]
    B --> H["setUserIdentifier()"]
    B --> I["testCrash()"]
    
    C --> J["EngineBugTrackingModel"]
    J --> K["Crashlytics Config"]
    J --> L["Faro Config"]
    
    D --> M["Adapters"]
    E --> M
    F --> M
    G --> M
    H --> M
    I --> M
    
    M --> N["EngineCrashlyticsAdapter"]
    M --> O["EngineFaroBugTrackingAdapter"]
    
    N --> P["Firebase Crashlytics SDK"]
    O --> Q["Grafana Faro SDK"]
    
    P --> R["Firebase Console"]
    Q --> S["Grafana Dashboard"]
    
    T["Flutter Error Handler"] --> F
    U["Platform Error Handler"] --> E
    
    V["Custom Errors"] --> E
    W["Logging Events"] --> D
```

## 🚀 Exemplos de Uso

O pacote inclui exemplos completos demonstrando todas as funcionalidades:

### 📱 Exemplo Principal
Demonstra inicialização, tracking de eventos, propriedades de usuário e navegação:
```bash
cd example && flutter run
```

### 🌐 Exemplo HTTP Tracking
Novo exemplo demonstrando tracking de requisições HTTPS com APIs públicas:
- **PokéAPI**: Requisições GET para dados de pokémons
- **JSONPlaceholder**: GET de posts/usuários e POST para criação
- **Tracking completo**: Tempo de resposta, códigos de status, tratamento de erros

Para acessar: Execute o app e toque em **"HTTP Tracking"**

### 👁️ Exemplo View Tracking
Sistema completo de tracking automático de telas com `EngineStatelessWidget` e `EngineStatefulWidget`:
- Tracking automático de visualizações
- Logging de ações do usuário
- Monitoramento de ciclo de vida

Para acessar: Execute o app e toque em **"View Tracking"**

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
    googleLoggingConfig: const  EngineGoogleLoggingConfig(
    enabled: true,
    projectId: 'seu-projeto-gcp',
    logName: 'engine-tracking',
    credentials: {
      // Conteúdo completo do arquivo JSON da Service Account
      "type": "service_account",
      "project_id": "seu-projeto-gcp",
      "private_key_id": "...",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      "client_email": "sua-service-account@seu-projeto-gcp.iam.gserviceaccount.com",
      "client_id": "...",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "...",
    },
    resource: {
      'type': 'global',
      'labels': {'project_id': 'seu-projeto-gcp'},
      },
    ),
    splunkConfig: const EngineSplunkConfig(enabled: false, /* outros campos */),
    );

  await EngineAnalytics.init(analyticsModel);
}
```

### 📈 Logging de Eventos

```dart
// Evento simples (Session ID incluído automaticamente)
await EngineAnalytics.logEvent('button_clicked');
// Output: {
//   "event_name": "button_clicked",
//   "session_id": "818c22c7-bcab-4e37-a12e-cd42a49547c6"
// }

// Evento com parâmetros
await EngineAnalytics.logEvent('purchase_completed', {
  'item_id': 'premium_plan',
  'value': 29.99,
  'currency': 'BRL',
  'category': 'subscription',
});
// Output: {
//   "event_name": "purchase_completed",
//   "session_id": "818c22c7-bcab-4e37-a12e-cd42a49547c6",
//   "item_id": "premium_plan",
//   "value": 29.99,
//   "currency": "BRL",
//   "category": "subscription"
// }

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

if (EngineAnalytics.isGoogleLoggingInitialized) {
  print('☁️ Google Cloud Logging ativo');
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
    googleLoggingConfig: const  EngineGoogleLoggingConfig(
    enabled: true,
    projectId: 'seu-projeto-gcp',
    logName: 'engine-tracking',
    credentials: {
      // Conteúdo completo do arquivo JSON da Service Account
      "type": "service_account",
      "project_id": "seu-projeto-gcp",
      "private_key_id": "...",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      "client_email": "sua-service-account@seu-projeto-gcp.iam.gserviceaccount.com",
      "client_id": "...",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "...",
    },
    resource: {
      'type': 'global',
      'labels': {'project_id': 'seu-projeto-gcp'},
    },
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

## 🆔 Session ID (Correlação Automática)

O `EngineSession` oferece sistema de correlação de logs e analytics através de UUID v4 único por sessão do app.

### 🎯 Características Principais

- ✨ **Zero Configuração**: Session ID gerado automaticamente na primeira chamada
- 🔗 **Correlação Automática**: UUID v4 incluído automaticamente em todos os eventos
- 🆔 **Padrão RFC 4122**: Compatible com qualquer sistema que use UUID v4
- 🔄 **Singleton Pattern**: Mesma instância de sessão durante toda a vida do app
- 🧪 **Testável**: Método `resetForTesting()` para cenários de teste

### 🚀 Uso Automático

O Session ID é incluído automaticamente em todos os eventos sem configuração adicional:

```dart
// Zero configuração necessária!
await EngineAnalytics.logEvent('button_clicked', {'action': 'submit'});
// Resultado: 
// {
//   "event_name": "button_clicked",
//   "session_id": "818c22c7-bcab-4e37-a12e-cd42a49547c6",
//   "action": "submit"
// }

await EngineLog.info('User action completed');
// Resultado no Google Cloud Logging:
// {
//   "message": "User action completed",
//   "session_id": "818c22c7-bcab-4e37-a12e-cd42a49547c6",
//   "level": "info"
// }
```

### 🔍 Acesso Direto (Opcional)

Se precisar acessar o Session ID diretamente:

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Obter Session ID atual
String sessionId = EngineSession.instance.sessionId;
print('Current Session: $sessionId');

// Verificar formato UUID v4
bool isValidUUID = EngineSession.instance.isValidUUIDv4(sessionId);
print('Valid UUID v4: $isValidUUID'); // true

// Para testes unitários (reseta session ID)
EngineSession.instance.resetForTesting();
```

### 🎯 Formato UUID v4

O Session ID gerado segue o padrão UUID v4 (RFC 4122):

```
Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
Exemplo: 818c22c7-bcab-4e37-a12e-cd42a49547c6

Características:
- 32 caracteres hexadecimais (0-9a-f)
- 5 grupos separados por hífen
- 13º caractere sempre "4" (versão)
- 17º caractere sempre "8", "9", "a" ou "b" (variant)
```

### 📊 Correlação nos Painéis

Com o Session ID, você pode:

- **Firebase Analytics**: Filtrar eventos por `session_id` para ver jornada completa
- **Google Cloud Logging**: Usar `session_id` para correlacionar logs da mesma sessão
- **Grafana Faro**: Agrupar eventos por sessão para análise de performance
- **Splunk**: Criar dashboards de jornada do usuário baseados no `session_id`

```bash
# Exemplo de query no Google Cloud Logging
jsonPayload.session_id="818c22c7-bcab-4e37-a12e-cd42a49547c6"

# Exemplo de filtro no Firebase Analytics
session_id == "818c22c7-bcab-4e37-a12e-cd42a49547c6"
```

## 📋 Logging do Sistema

O `EngineLog` oferece sistema de logging estruturado com diferentes níveis.

### 📊 Níveis de Log

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Debug (Session ID incluído automaticamente)
await EngineLog.debug('Debug message', data: {'key': 'value'});
// Output: {
//   "message": "Debug message",
//   "session_id": "818c22c7-bcab-4e37-a12e-cd42a49547c6",
//   "key": "value"
// }

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
                    _buildStatusRow('Google Cloud Logging', EngineAnalytics.isGoogleLoggingInitialized),
                    _buildStatusRow('Bug Tracking', EngineBugTracking.isEnabled),
                    _buildStatusRow('Crashlytics', EngineBugTracking.isCrashlyticsEnabled),
                    _buildStatusRow('Faro Logging', EngineBugTracking.isFaroEnabled),
                    _buildStatusRow('GCP Bug Tracking', EngineBugTracking.isGoogleLoggingInitialized),
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
    │   ├── engine_faro_config.dart
    │   └── engine_google_logging_config.dart
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

## Sistema de Tracking de Views

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

#### 1. Classes Engine (Recomendado)

As classes Engine oferecem implementação completa com tracking automático integrado.

##### EngineStatelessWidget

```dart
import 'package:engine_tracking/engine_tracking.dart';

class HomePage extends EngineStatelessWidget {
  HomePage({super.key});

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

##### EngineStatefulWidget

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

### Exemplo Completo com Classes Engine

```dart
import 'package:engine_tracking/engine_tracking.dart';

class SettingsPage extends EngineStatelessWidget {
  SettingsPage({super.key});

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
- **Google Cloud Logging** (se configurado)
- **Engine Log** para debugging

## Melhores Práticas

1. **Use nomes descritivos** para telas e ações
2. **Inclua parâmetros relevantes** sem dados sensíveis
3. **Monitore erros** com contexto apropriado
4. **Use classes Engine** para funcionalidade completa
5. **Personalize screenName** para identificação clara
6. **Agrupe ações relacionadas** com prefixos consistentes

## Desabilitando Tracking

```dart
class MyPage extends EngineStatelessWidget {
  MyPage({super.key});
  
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
- ✅ **96 testes passando** (100% dos testes implementados)
- ✅ **Testes otimizados** para integrações Firebase/Faro/Google Cloud (evitam dependências externas)
- ✅ **100% de cobertura** nos arquivos de configuração e modelos
- ✅ **Testes completos** para sistema de logging e Google Cloud Logging
- ✅ **Testes completos** para Session ID com validação UUID v4 RFC 4122

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

## 🤖 Integração MCP (Model Context Protocol)

O Engine Tracking v1.3.0 inclui suporte completo ao **Model Context Protocol (MCP)**, permitindo que assistentes de IA (como Claude, GPT-4, etc.) acessem dados do projeto em tempo real.

### 🔧 Configuração Rápida

O projeto inclui configuração automática para os principais serviços:

```bash
# Ver documentação completa
docs/MCP_CONFIGURATION.md
docs/MCP_QUICK_SETUP.md
```

### 🛠️ Serviços Suportados

| Serviço | Funcionalidades | Status |
|---------|----------------|--------|
| **GitHub** | Repos, Issues, PRs, Code Search | ✅ Configurado |
| **Firebase** | Projetos, Deploy, Firestore, Functions | ✅ Configurado |
| **Supabase** | Tabelas, SQL, Schema, Projetos | ⚙️ Requer tokens |
| **TaskMaster** | Tarefas, Status, Subtarefas | ✅ Configurado |

### 📋 Ferramentas Incluídas

```bash
# Testar configurações MCP
node scripts/test_mcp_connections.js

# Configurar tokens interativamente
node scripts/setup_mcp_tokens.js

# Ver status atual
node scripts/setup_mcp_tokens.js --status
```

### 💡 Capacidades

Com MCP configurado, sua IA pode:
- 🔍 **Acessar repositórios** GitHub em tempo real
- 🔥 **Gerenciar projetos** Firebase
- 🗄️ **Consultar bancos** Supabase
- 📊 **Monitorar tarefas** TaskMaster
- 📝 **Analisar código** e estrutura do projeto

### 🚀 Exemplo de Uso

```
Pergunta à IA: "Mostre o status dos adaptadores Google Cloud Logging"
Resposta: Lista arquivos, testes e documentação automaticamente

Pergunta: "Quais tarefas estão pendentes no TaskMaster?"
Resposta: Acessa e mostra tarefas em tempo real
```

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

**💡 Dica v1.3.0**: Para máxima eficiência, configure apenas os serviços que você realmente utiliza. A biblioteca é otimizada para funcionar com qualquer combinação de serviços habilitados ou desabilitados. Com **Session ID automático**, **Google Cloud Logging** e **MCP**, você agora tem correlação completa de logs, centralização avançada e integração perfeita com assistentes de IA! 🆔🔥 