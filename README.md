# Engine Tracking

<div align="center">
  <img src="assets/images/logo.png" alt="Engine Tracking Logo" width="300" />
</div>

[![pub.dev](https://img.shields.io/pub/v/engine_tracking.svg)](https://pub.dev/packages/engine_tracking)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.32.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)

A comprehensive Flutter library for analytics tracking and bug reporting with unified integration across multiple services including Firebase Analytics, Firebase Crashlytics, Microsoft Clarity, Grafana Faro, Splunk, and Google Cloud Logging.

**Supported Platforms:** iOS • Android

## Quick Start

Add to your `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.5.1
```

Initialize the library:

```dart
import 'package:engine_tracking/engine_tracking.dart';

// Initialize all tracking services
await EngineTrackingInitialize.initWithModels(
  analyticsModel: EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    clarityConfig: const EngineClarityConfig(enabled: true, projectId: 'your-project-id'),
    // Configure other services as needed
  ),
  bugTrackingModel: EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
    // Configure other services as needed
  ),
  httpTrackingModel: const EngineHttpTrackingModel(
    enabled: true,
    httpTrackingConfig: EngineHttpTrackingConfig(
      enableRequestLogging: true,
      enableResponseLogging: true,
      logName: 'HTTP_TRACKING',
    ),
  ),
);

// Start tracking events
await EngineAnalytics.logEvent('app_opened');
```

## Features

**Analytics Integration**
- Firebase Analytics for comprehensive user behavior tracking
- Microsoft Clarity with dual integration (adapter + widget) for session recordings, heatmaps, and custom events
- Grafana Faro for observability and monitoring
- Splunk for enterprise logging and analytics
- Google Cloud Logging for centralized log management

**Bug Tracking & Monitoring**
- Firebase Crashlytics for crash reporting
- Automatic Flutter error handling
- Custom error tracking with context
- Structured logging with multiple severity levels

**Developer Experience**
- Type-safe implementation with full null safety
- Automatic session ID correlation across all services
- Flexible service configuration (enable/disable individually)
- Custom widgets with built-in tracking capabilities
- HTTP request monitoring
- Single import entry point

## Architecture

Engine Tracking uses an adapter pattern to provide unified interfaces for multiple analytics and bug tracking services. Each service can be enabled or disabled independently through configuration.

### Session Management

```mermaid
graph LR
    A[App Start] --> B[Generate UUID]
    B --> C[Session ID]
    C --> D[Analytics Events]
    C --> E[Bug Reports]
    C --> F[Log Entries]
```

All tracking events automatically include a unique session ID for correlation across services.

### Analytics Flow

```mermaid
graph TD
    A[Your App] --> B[EngineAnalytics]
    B --> C[Adapters]
    C --> D[Firebase Analytics]
    C --> E[Microsoft Clarity]
    C --> F[Grafana Faro]
    C --> G[Splunk]
    C --> H[Google Cloud Logging]
```

### Bug Tracking Flow

```mermaid
graph TD
    A[Flutter Errors] --> B[EngineBugTracking]
    A2[Custom Errors] --> B
    B --> C[Adapters]
    C --> D[Firebase Crashlytics]
    C --> E[Grafana Faro]
    C --> F[Google Cloud Logging]
```

### EngineLog - Unified Logging System

`EngineLog` is the central logging system that automatically abstracts and unifies calls to both Analytics and Bug Tracking services. It's the recommended way to log events as it handles service routing automatically.

```mermaid
graph TD
    A[Your App] --> B[EngineLog]
    B --> C{Log Level}
    C -->|debug/info| D[Developer Console]
    C -->|warning/error/fatal| E[Developer Console + Services]
    E --> F[EngineAnalytics]
    E --> G[EngineBugTracking]
    F --> H[All Analytics Services]
    G --> I[All Bug Tracking Services]
```

**Key Benefits:**
- **Single API**: One method call routes to multiple services
- **Automatic Service Detection**: Only calls enabled services
- **Level-based Routing**: Different log levels go to appropriate services
- **Context Preservation**: Maintains session ID and metadata across all services
- **Performance Optimized**: No-op when services are disabled

### Widget Tracking System

Engine Tracking provides custom widgets that automatically track user interactions and screen lifecycle events.

```mermaid
graph TD
    A[EngineStatelessWidget] --> B[buildWithTracking]
    C[EngineStatefulWidget] --> D[buildWithTracking]
    B --> E[Automatic Screen Tracking]
    D --> E
    E --> F[screen_initialized]
    E --> G[screen_viewed]
    E --> H[screen_disposed]
    
    I[User Actions] --> J[logUserAction]
    K[State Changes] --> L[logStateChange]
    M[Custom Events] --> N[logCustomEvent]
    
    J --> O[EngineLog]
    L --> O
    N --> O
```

### Navigation Observer

Automatic navigation tracking with `EngineNavigationObserver`:

```mermaid
graph LR
    A[Navigator] --> B[EngineNavigationObserver]
    B --> C[Route Changes]
    C --> D[EngineAnalytics.setPage]
    D --> E[All Analytics Services]
```

### HTTP Tracking System

Engine Tracking provides comprehensive HTTP request/response logging through `EngineHttpOverride` and `EngineHttpTracking` using a model-based configuration approach.

```mermaid
graph TD
    A[HTTP Requests] --> B[EngineHttpOverride]
    B --> C[Request Logging]
    B --> D[Response Logging]
    B --> E[Error Logging]
    C --> F[EngineLog.debug]
    D --> F
    E --> G[EngineLog.error]
    F --> H[All Tracking Services]
    G --> H
```

**Key Features:**
- **Model-based Configuration**: Uses `EngineHttpTrackingModel` following the same pattern as analytics and bug tracking
- **Automatic HTTP Logging**: Intercepts all HTTP requests/responses
- **Configurable Logging**: Control what gets logged (headers, body, timing)
- **Error Tracking**: Automatic error logging for failed requests
- **Performance Metrics**: Request timing and performance data
- **Chain-friendly**: Works with existing HttpOverrides (like FaroHttpOverrides)
- **Unified Initialization**: Integrates with `EngineTrackingInitialize.initWithModels()`

**Model-based Configuration:**
```dart
// Development model (verbose logging)
const EngineHttpTrackingModel(
  enabled: true,
  httpTrackingConfig: EngineHttpTrackingConfig(
    enableRequestLogging: true,
    enableResponseLogging: true,
    enableTimingLogging: true,
    enableHeaderLogging: true,
    enableBodyLogging: true,
    maxBodyLogLength: 2000,
    logName: 'HTTP_TRACKING_DEV',
  ),
)

// Production model (minimal logging)
const EngineHttpTrackingModel(
  enabled: true,
  httpTrackingConfig: EngineHttpTrackingConfig(
    enableRequestLogging: true,
    enableResponseLogging: true,
    enableTimingLogging: true,
    enableHeaderLogging: false, // Be careful with sensitive data
    enableBodyLogging: false,   // Be careful with sensitive data
    maxBodyLogLength: 500,
    logName: 'HTTP_TRACKING_PROD',
  ),
)

// Disabled model
const EngineHttpTrackingModelDefault() // All tracking disabled
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  engine_tracking: ^1.5.1
```

Run:

```bash
flutter pub get
```

## Usage Examples

### Complete Examples

The package includes complete examples demonstrating all functionality:

```bash
cd example && flutter run
```

Available examples:
- **Main Example**: Initialization, event tracking, user properties, and navigation
- **HTTP Tracking**: Requests with PokéAPI and JSONPlaceholder
- **View Tracking**: Automatic screen tracking system

### Centralized Initialization (Recommended)

Use `EngineTrackingInitialize` to initialize both Analytics and Bug Tracking:

```dart
import 'package:engine_tracking/engine_tracking.dart';

// All services
await EngineTrackingInitialize.initWithModels(
  analyticsModel: EngineAnalyticsModel(/* configs */),
  bugTrackingModel: EngineBugTrackingModel(/* configs */),
  httpTrackingModel: EngineHttpTrackingModel(/* config */),
);

// Analytics and HTTP tracking only
await EngineTrackingInitialize.initWithModels(
  analyticsModel: EngineAnalyticsModel(/* configs */),
  bugTrackingModel: null,
  httpTrackingModel: EngineHttpTrackingModel(/* config */),
);

// Bug tracking only
await EngineTrackingInitialize.initWithModels(
  analyticsModel: null,
  bugTrackingModel: EngineBugTrackingModel(/* configs */),
  httpTrackingModel: null,
);

// With adapters (granular control)
await EngineTrackingInitialize.initWithAdapters(
  analyticsAdapters: [EngineFirebaseAnalyticsAdapter(/* config */)],
  bugTrackingAdapters: null, // Skip bug tracking
);

// Quick initialization (both disabled)
await EngineTrackingInitialize.initWithDefaults();

// Status
bool bothReady = EngineTrackingInitialize.isInitialized;
bool anyEnabled = EngineTrackingInitialize.isEnabled;

// Cleanup
await EngineTrackingInitialize.dispose();
```

### Microsoft Clarity Integration

Engine Tracking provides two ways to integrate with Microsoft Clarity:

#### 1. Adapter-based Integration (Recommended)

The `EngineClarityAdapter` integrates Clarity into the unified analytics system:

```dart
final analyticsModel = EngineAnalyticsModel(
  clarityConfig: const EngineClarityConfig(
    enabled: true,
    projectId: 'your-clarity-project-id',
  ),
  // ... other configs
);

await EngineAnalytics.initWithModel(analyticsModel);

// All analytics calls now include Clarity
await EngineAnalytics.logEvent('user_action');
await EngineAnalytics.setUserId('user_123');
await EngineAnalytics.setPage('home_screen');
```

#### 2. Widget-based Integration (For Session Recordings)

Use `EngineWidget` to automatically enable session recordings and heatmaps. The widget automatically detects if Clarity has been initialized through the analytics system - no manual configuration required:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize analytics with Clarity configuration
  final analyticsModel = EngineAnalyticsModel(
    clarityConfig: EngineClarityConfig(
      enabled: true,
      projectId: 'your-clarity-project-id',
    ),
    // ... other configurations
  );
  
  await EngineAnalytics.initWithModel(analyticsModel);
  
  // EngineWidget automatically detects and uses Clarity configuration
  // No need to pass clarityConfig manually!
  runApp(EngineWidget(app: MyApp()));
}
```

#### Combined Usage (Best Practice)

For complete Clarity integration, initialize analytics and use EngineWidget:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final clarityConfig = EngineClarityConfig(
    enabled: true,
    projectId: 'your-clarity-project-id',
  );
  
  // Initialize analytics with Clarity adapter
  await EngineAnalytics.initWithModel(
    EngineAnalyticsModel(
      clarityConfig: clarityConfig,
      // ... other configs
    ),
  );
  
  // EngineWidget automatically detects Clarity configuration
  // No manual configuration needed!
  runApp(EngineWidget(app: MyApp()));
}
```

### Individual Service Configuration

```dart
import 'package:engine_tracking/engine_tracking.dart';

Future<void> setupTracking() async {
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
    clarityConfig: const EngineClarityConfig(
      enabled: true,
      projectId: 'your-clarity-project-id',
    ),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'YourApp',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'your-faro-api-key',
    ),
    googleLoggingConfig: const EngineGoogleLoggingConfig(
      enabled: true,
      projectId: 'your-gcp-project',
      logName: 'engine-tracking',
      credentials: {
        "type": "service_account",
        "project_id": "your-gcp-project",
        "private_key_id": "...",
        "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
        "client_email": "your-service-account@your-gcp-project.iam.gserviceaccount.com",
        // ... rest of credentials
      },
      resource: {
        'type': 'global',
        'labels': {'project_id': 'your-gcp-project'},
      },
    ),
    splunkConfig: const EngineSplunkConfig(enabled: false),
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: true),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector.grafana.net/collect',
      appName: 'YourApp',
      appVersion: '1.0.0',
      environment: 'production',
      apiKey: 'your-faro-api-key',
    ),
    googleLoggingConfig: const EngineGoogleLoggingConfig(enabled: true, /* configs */),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
  await EngineBugTracking.initWithModel(bugTrackingModel);
}
```

### Event Tracking

```dart
// Simple event (Session ID included automatically)
await EngineAnalytics.logEvent('button_clicked');

// Event with parameters
await EngineAnalytics.logEvent('purchase_completed', {
  'item_id': 'premium_plan',
  'value': 29.99,
  'currency': 'USD',
  'category': 'subscription',
});

// App open event
await EngineAnalytics.logAppOpen();
```

### User Management

```dart
// Set user ID
await EngineAnalytics.setUserId('user_12345');

// With complete information (for Faro/Clarity)
await EngineAnalytics.setUserId(
  'user_12345',
  'user@example.com',
  'John Doe',
);

// User properties
await EngineAnalytics.setUserProperty('user_type', 'premium');
await EngineAnalytics.setUserProperty('plan', 'monthly');
```

### Screen Navigation

```dart
// Simple screen
await EngineAnalytics.setPage('HomeScreen');

// With complete context
await EngineAnalytics.setPage(
  'ProductScreen',      // Current screen
  'HomeScreen',        // Previous screen
  'ECommerceApp',      // Screen class
);
```

### Bug Tracking

```dart
// Structured logging
await EngineBugTracking.log('User completed purchase', {
  'user_id': '12345',
  'product_id': 'abc-123',
  'amount': 29.99,
});

// Capture errors
try {
  // code that might fail
} catch (error, stackTrace) {
  await EngineBugTracking.recordError(
    error,
    stackTrace,
    reason: 'Payment processing failure',
  );
}

// Set user context
await EngineBugTracking.setUserIdentifier('user_12345', 'user@example.com', 'John Doe');
await EngineBugTracking.setCustomKey('subscription_plan', 'premium');
```

### Logging System

```dart
// Different log levels
await EngineLog.debug('Debug information');
await EngineLog.info('Informational message');
await EngineLog.warning('Warning message');
await EngineLog.error('Error occurred');
await EngineLog.fatal('Fatal error');

// With additional data
await EngineLog.info('User action', data: {
  'action': 'button_click',
  'screen': 'home',
  'user_id': '12345',
});

// Custom log name and include in analytics
await EngineLog.warning('Important warning', 
  logName: 'USER_ACTION',
  includeInAnalytics: true,
);

// Error logging with exception and stack trace
try {
  // risky operation
} catch (error, stackTrace) {
  await EngineLog.error('Operation failed',
    error: error,
    stackTrace: stackTrace,
    data: {'operation': 'user_registration'},
  );
}

// Fatal error with complete context
await EngineLog.fatal('Critical system failure',
  logName: 'SYSTEM',
  error: exception,
  stackTrace: stackTrace,
  data: {
    'component': 'payment_processor',
    'user_id': 'user_123',
    'transaction_id': 'tx_456',
  },
);
```

### View Tracking with Widgets

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
      appBar: AppBar(title: const Text('Shopping Cart')),
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

### Custom Widgets

Engine Tracking provides several specialized widgets for enhanced tracking capabilities:

#### EngineWidget - Root App Wrapper

Automatically wraps your app to enable Microsoft Clarity session recordings when Clarity is initialized. The widget intelligently detects if Clarity has been configured through the analytics system and automatically enables session recordings without requiring manual configuration:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize analytics with Clarity configuration
  await EngineAnalytics.initWithModel(
    EngineAnalyticsModel(
      clarityConfig: EngineClarityConfig(
        enabled: true,
        projectId: 'your-clarity-project-id',
      ),
      firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
      // ... other configs
    ),
  );

  // EngineWidget automatically detects and enables Clarity session recordings
  // No manual clarityConfig parameter needed!
  runApp(EngineWidget(app: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      navigatorObservers: [EngineNavigationObserver()],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // This event goes to all analytics services including Clarity
              await EngineAnalytics.logEvent('button_clicked', {
                'button_type': 'primary',
                'screen': 'home',
              });
            },
            child: Text('Track Event'),
          ),
          
          // Mask sensitive content in Clarity recordings
          EngineMaskWidget(
            child: Text('Sensitive user data'),
          ),
        ],
      ),
    );
  }
}
```

#### EngineMaskWidget - Privacy Protection

Masks sensitive content in session recordings:

```dart
class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Order Summary'),
          
          // Mask sensitive payment information
          EngineMaskWidget(
            child: Column(
              children: [
                Text('Credit Card: **** **** **** 1234'),
                Text('CVV: 123'),
                
                // Unmask non-sensitive info within masked area
                EngineUnmaskWidget(
                  child: Text('Expires: 12/25'),
                ),
              ],
            ),
          ),
          
          ElevatedButton(
            onPressed: () => processPayment(),
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
```

#### EngineStatelessWidget - Enhanced Stateless Widgets

Provides automatic screen tracking and user action logging:

```dart
class ProductListPage extends EngineStatelessWidget {
  ProductListPage({super.key});

  @override
  String get screenName => 'product_list';

  @override
  Map<String, dynamic>? get screenParameters => {
    'category': 'electronics',
    'sort_by': 'price',
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Product $index'),
            onTap: () {
              // Automatically tracked user action
              logUserAction('product_selected', parameters: {
                'product_id': index,
                'product_name': 'Product $index',
              });
              
              // Navigate to product details
              Navigator.push(context, 
                MaterialPageRoute(builder: (_) => ProductDetailPage()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Log custom events
          logCustomEvent('filter_opened');
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
```

#### EngineStatefulWidget - Enhanced Stateful Widgets

Includes state change tracking in addition to all EngineStatelessWidget features:

```dart
class ShoppingCartPage extends StatefulWidget {
  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends EngineStatefulWidgetState<ShoppingCartPage> {
  List<CartItem> _items = [];
  
  @override
  String get screenName => 'shopping_cart';

  @override
  Map<String, dynamic>? get screenParameters => {
    'initial_item_count': _items.length,
    'cart_value': _calculateTotal(),
  };

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index].name),
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => _removeItem(index),
            ),
          );
        },
      ),
    );
  }
  
  void _removeItem(int index) {
    final removedItem = _items[index];
    
    setState(() {
      _items.removeAt(index);
    });
    
    // Track user action
    logUserAction('item_removed', parameters: {
      'item_id': removedItem.id,
      'remaining_items': _items.length,
    });
    
    // Track state change
    logStateChange('cart_updated', additionalData: {
      'action': 'item_removal',
      'new_total': _calculateTotal(),
    });
  }
  
  double _calculateTotal() {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }
}
```

### Navigation Observer

Automatic navigation tracking with `EngineNavigationObserver`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // Add the navigation observer for automatic screen tracking
      navigatorObservers: [
        EngineNavigationObserver(),
      ],
      home: HomePage(),
      routes: {
        '/products': (context) => ProductListPage(),
        '/cart': (context) => ShoppingCartPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
```

The `EngineNavigationObserver` automatically:
- Tracks route changes and screen transitions
- Calls `EngineAnalytics.setPage()` with screen names
- Provides navigation context for analytics
- Works seamlessly with both named routes and direct navigation

### HTTP Request Tracking

Engine Tracking provides comprehensive HTTP request/response logging using a model-based approach:

```dart
import 'package:engine_tracking/engine_tracking.dart';
import 'package:http/http.dart' as http;

void main() async {
  // Initialize Engine Tracking with HTTP tracking model
  await EngineTrackingInitialize.initWithModels(
    analyticsModel: myAnalyticsModel,
    bugTrackingModel: myBugTrackingModel,
    // Add HTTP tracking model
    httpTrackingModel: const EngineHttpTrackingModel(
      enabled: true,
      httpTrackingConfig: EngineHttpTrackingConfig(
        enableRequestLogging: true,
        enableResponseLogging: true,
        enableTimingLogging: true,
        enableHeaderLogging: true,
        enableBodyLogging: true,
        maxBodyLogLength: 2000,
        logName: 'HTTP_TRACKING_DEV',
      ),
    ),
  );
  
  runApp(MyApp());
}

// HTTP requests are now automatically logged
class ApiService {
  Future<User> getUser(String userId) async {
    // This request will be automatically logged with:
    // - Request details (method, URL, headers, timing)
    // - Response details (status, headers, timing)
    // - Error details (if request fails)
    final response = await http.get(
      Uri.parse('https://api.example.com/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw ApiException('Failed to load user');
    }
  }
  
  Future<void> updateUser(User user) async {
    // POST requests are also automatically tracked
    final response = await http.post(
      Uri.parse('https://api.example.com/users/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(user.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw ApiException('Failed to update user');
    }
  }
}
```

**Model Configuration Examples:**

```dart
// Development model: Full logging with headers and body
const devModel = EngineHttpTrackingModel(
  enabled: true,
  httpTrackingConfig: EngineHttpTrackingConfig(
    enableRequestLogging: true,
    enableResponseLogging: true,
    enableTimingLogging: true,
    enableHeaderLogging: true,
    enableBodyLogging: true,
    maxBodyLogLength: 2000,
    logName: 'API_DEV',
  ),
);

// Production model: Minimal logging, no sensitive data
const prodModel = EngineHttpTrackingModel(
  enabled: true,
  httpTrackingConfig: EngineHttpTrackingConfig(
    enableRequestLogging: true,
    enableResponseLogging: true,
    enableTimingLogging: true,
    enableHeaderLogging: false, // Disable for security
    enableBodyLogging: false,   // Disable for security
    maxBodyLogLength: 500,
    logName: 'API_PROD',
  ),
);

// Disabled model
const disabledModel = EngineHttpTrackingModelDefault();
```

**Advanced Usage:**

```dart
// Initialize directly with model
EngineHttpTracking.initWithModel(devModel);

// Update model at runtime
EngineHttpTracking.updateModel(prodModel);

// Update model at runtime
EngineHttpTracking.updateModel(prodModel);

// Log custom HTTP-related events
await EngineHttpTracking.logCustomEvent(
  'API rate limit reached',
  data: {
    'endpoint': '/api/users',
    'retry_after': 60,
    'request_count': 100,
  },
);

// Get HTTP tracking statistics
final stats = EngineHttpTracking.getStats();
print('HTTP Tracking enabled: ${stats['is_enabled']}');
```

**Backward Compatibility:**

```dart
// Legacy configuration method (deprecated but still supported)
@Deprecated('Use EngineHttpTrackingModel instead')
EngineHttpTracking.initialize(config);
```

### Status Verification

```dart
// Check if analytics is enabled
if (EngineAnalytics.isEnabled) {
  print('✅ Analytics is active');
}

// Check specific services
if (EngineAnalytics.isFirebaseInitialized) {
  print('🔥 Firebase Analytics active');
}

if (EngineAnalytics.isClarityInitialized) {
  print('👁️ Microsoft Clarity active');
}

if (EngineAnalytics.isFaroInitialized) {
  print('📊 Grafana Faro active');
}

if (EngineAnalytics.isSplunkInitialized) {
  print('🔍 Splunk active');
}

if (EngineAnalytics.isGoogleLoggingInitialized) {
  print('☁️ Google Cloud Logging active');
}
```

---

## Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow existing code patterns
- Document new features
- Test on both Android and iOS
- Update the CHANGELOG.md

### License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## About STMR

Developed by **STMR** - Mobile solutions specialists.

STMR is a company focused on developing innovative technology solutions for mobile devices, specializing in robust architectures, optimized performance, and exceptional user experiences.

### Our Mission
To provide high-quality Flutter tools and libraries that accelerate enterprise mobile application development while maintaining the highest standards of security, performance, and usability.

---

**Tip**: For maximum efficiency, configure only the services you actually use. The library is optimized to work with any combination of enabled or disabled services. With automatic Session ID, you now have complete log correlation and advanced centralization!