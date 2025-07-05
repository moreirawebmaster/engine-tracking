# Engine Tracking

<div align="center">
  <img src="assets/images/logo.png" alt="Engine Tracking Logo" width="300" />
</div>

## 📋 Sobre o Projeto

[![pub.dev](https://img.shields.io/pub/v/engine_tracking.svg)](https://pub.dev/packages/engine_tracking)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.32.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)

Uma biblioteca Flutter completa para **tracking de analytics** e **bug reporting**, oferecendo integração com Firebase Analytics, Firebase Crashlytics, Microsoft Clarity, Grafana Faro, Splunk e Google Cloud Logging.

### 📱 Plataformas Suportadas
- ✅ iOS
- ✅ Android

---

## 🚀 Principais Características

- 📊 **Analytics Múltiplo**: Firebase Analytics, Microsoft Clarity, Grafana Faro, Splunk e Google Cloud Logging
- 🐛 **Bug Tracking Avançado**: Firebase Crashlytics, Grafana Faro e Google Cloud Logging para monitoramento completo
- 🌐 **HTTP Tracking**: Monitoramento automático de requisições HTTPS com métricas detalhadas
- 👁️ **View Tracking**: Sistema automático de tracking de telas com `EngineStatelessWidget` e `EngineStatefulWidget`
- ⚙️ **Configuração Flexível**: Ative/desative serviços individualmente através de configurações
- 📝 **Logging Estruturado**: Sistema de logs com diferentes níveis e contextos
- 🆔 **Session ID Automático**: UUID v4 único por abertura do app para correlação de logs e analytics
- 🔒 **Tipo-seguro**: Implementação completamente tipada em Dart
- 🛡️ **Confiável**: Implementação robusta e estável para aplicações empresariais
- 🏗️ **Arquitetura Consistente**: Padrão unificado entre Analytics e Bug Tracking
- 🎯 **Inicialização Condicional**: Serviços são inicializados apenas se habilitados na configuração
- 📦 **Export Unificado**: Todos os imports através de `package:engine_tracking/engine_tracking.dart`
- 🚀 **Exemplos Completos**: Apps de demonstração com casos de uso reais (HTTP + View Tracking)

---

## 🗺️ Arquitetura da Solução

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
    
    U["Correlação de Logs"] --> V["Mesmo session_id"]
    V --> W["Jornada Completa do Usuário"]
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
    
    N --> T["Firebase Crashlytics"]
    N --> U["Grafana Faro Bug Tracking"]
    
    K -->|Sim| V{{"level == error || fatal?"}}
    V -->|Sim| W["EngineBugTracking.recordError()"]
    V -->|Não| X["Apenas log normal"]
    
    W --> Y["Crash Reporting"]
    Y --> T
    Y --> U
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
    I --> M["Google Logging Config"]
    
    D --> O["Adapters"]
    E --> O
    F --> O
    G --> O
    H --> O
    
    O --> P["EngineFirebaseAnalyticsAdapter"]
    O --> Q["EngineFaroAnalyticsAdapter"]
    O --> R["EngineSplunkAnalyticsAdapter"]
    O --> S["EngineGoogleLoggingAnalyticsAdapter"]
    
    P --> T["Firebase Analytics SDK"]
    Q --> U["Grafana Faro SDK"]
    R --> V["Splunk SDK"]
    S --> W["Google Cloud Logging API"]
    
    T --> X["Google Analytics Dashboard"]
    U --> Y["Grafana Dashboard"]
    V --> Z["Splunk Dashboard"]
    W --> AA["Google Cloud Console"]
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
    J --> M["Google Logging Config"]
    
    D --> N["Adapters"]
    E --> N
    F --> N
    G --> N
    H --> N
    I --> N
    
    N --> O["EngineCrashlyticsAdapter"]
    N --> P["EngineFaroBugTrackingAdapter"]
    N --> Q["EngineGoogleLoggingBugTrackingAdapter"]
    
    O --> R["Firebase Crashlytics SDK"]
    P --> S["Grafana Faro SDK"]
    Q --> T["Google Cloud Logging API"]
    
    R --> U["Firebase Console"]
    S --> V["Grafana Dashboard"]
    T --> W["Google Cloud Console"]
    
    X["Flutter Error Handler"] --> F
    Y["Platform Error Handler"] --> E
    
    Z["Custom Errors"] --> E
    AA["Logging Events"] --> D
```

---

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.4.0
```

Execute:

```bash
flutter pub get
```

---

## 🚀 Exemplos de Uso

### 📱 Exemplos Inclusos

O pacote inclui exemplos completos demonstrando todas as funcionalidades:

```bash
cd example && flutter run
```

- **📱 Exemplo Principal**: Inicialização, tracking de eventos, propriedades de usuário e navegação
- **🌐 Exemplo HTTP Tracking**: Requisições com PokéAPI e JSONPlaceholder
- **👁️ Exemplo View Tracking**: Sistema automático de tracking de telas

### 🚀 Inicialização Centralizada (Recomendado)

**Novo!** Use o `EngineTrackingInitialize` para inicializar Analytics e Bug Tracking de uma só vez:

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Ambos os serviços
await EngineTrackingInitialize.initWithModels(
  analyticsModel: EngineAnalyticsModel(/* configs */),
  bugTrackingModel: EngineBugTrackingModel(/* configs */),
);

// Apenas Analytics
await EngineTrackingInitialize.initWithModels(
  analyticsModel: EngineAnalyticsModel(/* configs */),
  bugTrackingModel: null,
);

// Apenas Bug Tracking
await EngineTrackingInitialize.initWithModels(
  analyticsModel: null,
  bugTrackingModel: EngineBugTrackingModel(/* configs */),
);

// Com Adapters (controle granular)
await EngineTrackingInitialize.initWithAdapters(
  analyticsAdapters: [EngineFirebaseAnalyticsAdapter(/* config */)],
  bugTrackingAdapters: null, // Skip bug tracking
);

// Inicialização rápida (ambos desabilitados)
await EngineTrackingInitialize.initWithDefaults();

// Status
bool bothReady = EngineTrackingInitialize.isInitialized;
bool anyEnabled = EngineTrackingInitialize.isEnabled;

// Cleanup
await EngineTrackingInitialize.dispose();
```

### 🎯 Configuração Básica (Método Individual)

```dart
import 'package:engine_tracking/engine_tracking.dart';

Future<void> setupTracking() async {
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    clarityConfig: const EngineClarityConfig(
      enabled: true,
      projectId: 'seu-projeto-clarity',
    ),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'MeuApp',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'sua-chave-api-faro',
    ),
    googleLoggingConfig: const EngineGoogleLoggingConfig(
      enabled: true,
      projectId: 'seu-projeto-gcp',
      logName: 'engine-tracking',
      credentials: {
        "type": "service_account",
        "project_id": "seu-projeto-gcp",
        "private_key_id": "...",
        "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
        "client_email": "sua-service-account@seu-projeto-gcp.iam.gserviceaccount.com",
        // ... resto das credenciais
      },
      resource: {
        'type': 'global',
        'labels': {'project_id': 'seu-projeto-gcp'},
      },
    ),
    splunkConfig: const EngineSplunkConfig(enabled: false),
  );

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
    googleLoggingConfig: const EngineGoogleLoggingConfig(enabled: true, /* configs */),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
  await EngineBugTracking.initWithModel(bugTrackingModel);
}
```

### 📈 Tracking de Eventos

```dart
// Evento simples (Session ID incluído automaticamente)
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

// Com informações completas (para Faro/Clarity)
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

### 🐛 Bug Tracking

```dart
// Log estruturado
await EngineBugTracking.log('Usuário realizou compra', {
  'user_id': '12345',
  'product_id': 'abc-123',
  'amount': 29.99,
});

// Capturar erros
try {
  // código que pode falhar
} catch (error, stackTrace) {
  await EngineBugTracking.recordError(
    error,
    stackTrace,
    reason: 'Falha no processamento de pagamento',
  );
}

// Definir contexto do usuário
await EngineBugTracking.setUserIdentifier('user_12345');
await EngineBugTracking.setCustomKey('subscription_plan', 'premium');
```

### 📝 Sistema de Logging

```dart
// Diferentes níveis de log
EngineLog.debug('Debug information');
EngineLog.info('Informational message');
EngineLog.warning('Warning message');
EngineLog.error('Error occurred');
EngineLog.fatal('Fatal error');

// Com contexto adicional
EngineLog.info('User action', context: {
  'action': 'button_click',
  'screen': 'home',
  'user_id': '12345',
});

// Incluir em analytics (padrão: false para debug/info)
EngineLog.warning('Important warning', includeInAnalytics: true);
```

### 👁️ View Tracking com Widgets

```dart
class HomePage extends EngineStatelessWidget {
  HomePage({super.key});

  @override
  String get screenName => 'home';

  @override
  Map<String, dynamic>? get screenParameters => {
    'user_type': 'premium',
    'version': '1.0.0',
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ElevatedButton(
        onPressed: () {
          logUserAction('cta_clicked', parameters: {
            'button_type': 'primary',
            'location': 'header',
          });
        },
        child: const Text('Click Me'),
      ),
    );
  }
}
```

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

---

## 🤝 Como Contribuir

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### 📋 Diretrizes de Contribuição

- Siga o padrão de código existente
- Documente novas funcionalidades
- Valide em Android e iOS
- Atualize o CHANGELOG.md

### 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

---

## 🏢 Sobre a STMR

Desenvolvido pela **STMR** - Especialistas em soluções móveis.

A STMR é uma empresa focada no desenvolvimento de soluções tecnológicas inovadoras para dispositivos móveis, especializando-se em arquiteturas robustas, performance otimizada e experiências de usuário excepcionais.

### 🎯 Nossa Missão
Fornecer ferramentas e bibliotecas Flutter de alta qualidade que aceleram o desenvolvimento de aplicações móveis enterprise, mantendo os mais altos padrões de segurança, performance e usabilidade.

---

**💡 Dica v1.4.0**: Para máxima eficiência, configure apenas os serviços que você realmente utiliza. A biblioteca é otimizada para funcionar com qualquer combinação de serviços habilitados ou desabilitados. Com **Session ID automático**, você agora tem correlação completa de logs e centralização avançada! 🆔🔥