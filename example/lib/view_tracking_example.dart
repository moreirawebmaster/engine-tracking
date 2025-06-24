import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

/// Exemplo de uso do sistema de tracking de views do Engine Tracking
class ViewTrackingExample extends StatelessWidget {
  const ViewTrackingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Tracking Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainMenuPage(),
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/shopping': (context) => const ShoppingCartPage(),
      },
    );
  }
}

/// Exemplo usando classe base EngineStatelessWidgetBase
class MainMenuPage extends EngineStatelessWidgetBase {
  MainMenuPage({super.key});

  @override
  String get screenName => 'main_menu';

  @override
  Map<String, dynamic>? get screenParameters => {'app_version': '1.0.0', 'source': 'app_launch'};

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Exemplo de Tracking de Views',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                logUserAction(
                  'navigate_to_profile',
                  parameters: {'navigation_method': 'button_tap', 'source_screen': screenName},
                );
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Perfil do Usuário'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                logUserAction(
                  'navigate_to_settings',
                  parameters: {'navigation_method': 'button_tap', 'source_screen': screenName},
                );
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Configurações'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                logUserAction(
                  'navigate_to_shopping',
                  parameters: {'navigation_method': 'button_tap', 'source_screen': screenName},
                );
                Navigator.pushNamed(context, '/shopping');
              },
              child: const Text('Carrinho de Compras'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                logCustomEvent('feature_demo', parameters: {'feature_type': 'premium_feature', 'user_type': 'free'});
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Evento customizado registrado!')));
              },
              child: const Text('Demonstrar Evento Customizado'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                try {
                  throw Exception('Erro demonstrativo');
                } catch (e, stackTrace) {
                  logScreenError(
                    'Erro simulado para demonstração',
                    exception: e,
                    stackTrace: stackTrace,
                    additionalData: {'error_type': 'demonstration', 'user_triggered': true},
                  );
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Erro registrado no sistema!')));
              },
              child: const Text('Simular Erro'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exemplo usando classe base EngineStatefulWidget
class ProfilePage extends EngineStatefulWidget {
  const ProfilePage({super.key});

  @override
  EngineStatefulWidgetState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends EngineStatefulWidgetState<ProfilePage> {
  String _name = '';
  String _email = '';
  bool _notificationsEnabled = true;

  @override
  String get screenName => 'user_profile';

  @override
  Map<String, dynamic>? get screenParameters => {
    'user_type': 'registered',
    'profile_completion': _getProfileCompletion(),
  };

  double _getProfileCompletion() {
    int completed = 0;
    if (_name.isNotEmpty) completed++;
    if (_email.isNotEmpty) completed++;
    return completed / 2.0;
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });

                logStateChange(
                  'name_field_changed',
                  additionalData: {'character_count': value.length, 'has_content': value.isNotEmpty},
                );
              },
              onSubmitted: (value) {
                logUserAction('field_completed', parameters: {'field': 'name', 'character_count': value.length});
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });

                logStateChange(
                  'email_field_changed',
                  additionalData: {'character_count': value.length, 'is_valid_format': value.contains('@')},
                );
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Receber Notificações'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });

                logUserAction(
                  'notification_preference_changed',
                  parameters: {'enabled': value, 'source': 'profile_settings'},
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (_name.isNotEmpty && _email.isNotEmpty)
                  ? () {
                      logUserAction(
                        'profile_save_attempted',
                        parameters: {
                          'name_length': _name.length,
                          'email_length': _email.length,
                          'notifications_enabled': _notificationsEnabled,
                          'completion_percentage': _getProfileCompletion(),
                        },
                      );

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Perfil salvo com sucesso!')));
                    }
                  : null,
              child: const Text('Salvar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exemplo usando classe base para StatelessWidget
class SettingsPage extends EngineStatelessWidgetBase {
  SettingsPage({super.key});

  @override
  String get screenName => 'app_settings';

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            subtitle: const Text('Gerenciar preferências de notificação'),
            onTap: () {
              logUserAction('settings_item_tapped', parameters: {'setting_type': 'notifications', 'item_position': 0});
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidade'),
            subtitle: const Text('Configurações de privacidade e dados'),
            onTap: () {
              logUserAction('settings_item_tapped', parameters: {'setting_type': 'privacy', 'item_position': 1});
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Segurança'),
            subtitle: const Text('Configurações de segurança da conta'),
            onTap: () {
              logUserAction('settings_item_tapped', parameters: {'setting_type': 'security', 'item_position': 2});
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            subtitle: const Text('Central de ajuda e suporte'),
            onTap: () {
              logUserAction('settings_item_tapped', parameters: {'setting_type': 'help', 'item_position': 3});
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o App'),
            onTap: () {
              logCustomEvent('about_app_accessed', parameters: {'source_screen': screenName});
            },
          ),
        ],
      ),
    );
  }
}

/// Exemplo usando classe base para StatefulWidget
class ShoppingCartPage extends EngineStatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  EngineStatefulWidgetState<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends EngineStatefulWidgetState<ShoppingCartPage> {
  final List<Map<String, dynamic>> _products = [
    {'id': '1', 'name': 'Smartphone', 'price': 899.99, 'quantity': 1},
    {'id': '2', 'name': 'Fones de Ouvido', 'price': 199.99, 'quantity': 2},
    {'id': '3', 'name': 'Carregador', 'price': 49.99, 'quantity': 1},
  ];

  @override
  String get screenName => 'shopping_cart';

  @override
  Map<String, dynamic>? get screenParameters => {
    'product_count': _products.length,
    'total_value': _calculateTotal(),
    'has_items': _products.isNotEmpty,
  };

  double _calculateTotal() {
    return _products.fold(0.0, (sum, product) => sum + (product['price'] as double) * (product['quantity'] as int));
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _products.isNotEmpty
                ? () {
                    logUserAction(
                      'clear_cart_pressed',
                      parameters: {'items_to_remove': _products.length, 'total_value_lost': _calculateTotal()},
                    );

                    setState(() {
                      _products.clear();
                    });

                    logStateChange('cart_cleared', additionalData: {'action': 'clear_all', 'remaining_items': 0});
                  }
                : null,
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text('Carrinho vazio', style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(product['name']),
                          subtitle: Text('R\$ ${product['price'].toStringAsFixed(2)} x ${product['quantity']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (product['quantity'] > 1) {
                                      product['quantity']--;
                                    }
                                  });

                                  logUserAction(
                                    'quantity_decreased',
                                    parameters: {
                                      'product_id': product['id'],
                                      'product_name': product['name'],
                                      'new_quantity': product['quantity'],
                                    },
                                  );
                                },
                              ),
                              Text('${product['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    product['quantity']++;
                                  });

                                  logUserAction(
                                    'quantity_increased',
                                    parameters: {
                                      'product_id': product['id'],
                                      'product_name': product['name'],
                                      'new_quantity': product['quantity'],
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  final removedProduct = _products[index];
                                  setState(() {
                                    _products.removeAt(index);
                                  });

                                  logUserAction(
                                    'product_removed',
                                    parameters: {
                                      'product_id': removedProduct['id'],
                                      'product_name': removedProduct['name'],
                                      'quantity_removed': removedProduct['quantity'],
                                      'value_lost': removedProduct['price'] * removedProduct['quantity'],
                                    },
                                  );

                                  logStateChange(
                                    'cart_updated',
                                    additionalData: {
                                      'action': 'item_removal',
                                      'remaining_items': _products.length,
                                      'new_total': _calculateTotal(),
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            'R\$ ${_calculateTotal().toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _products.isNotEmpty
                              ? () {
                                  logUserAction(
                                    'checkout_initiated',
                                    parameters: {
                                      'product_count': _products.length,
                                      'total_value': _calculateTotal(),
                                      'items': _products
                                          .map((p) => {'id': p['id'], 'quantity': p['quantity']})
                                          .toList(),
                                    },
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Checkout iniciado!'), backgroundColor: Colors.green),
                                  );
                                }
                              : null,
                          child: const Text('Finalizar Compra'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// Função para demonstrar a inicialização do sistema
Future<void> initializeTrackingExample() async {
  // Configuração básica do Analytics
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
    faroConfig: const EngineFaroConfig(
      enabled: false,
      endpoint: '',
      appName: '',
      appVersion: '',
      environment: '',
      apiKey: '',
      namespace: '',
      platform: '',
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

  // Configuração básica do Bug Tracking
  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
    faroConfig: const EngineFaroConfig(
      enabled: false,
      endpoint: '',
      appName: '',
      appVersion: '',
      environment: '',
      apiKey: '',
      namespace: '',
      platform: '',
    ),
  );

  // Inicializar os sistemas
  await EngineAnalytics.initWithModel(analyticsModel);
  await EngineBugTracking.initWithModel(bugTrackingModel);

  print('Sistema de tracking inicializado para exemplo!');
}
