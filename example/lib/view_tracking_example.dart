// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

class ViewTrackingExample extends StatelessWidget {
  const ViewTrackingExample({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'View Tracking Example',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MainMenuPage(),
    routes: {
      '/profile': (final context) => const ProfilePage(),
      '/settings': (final context) => SettingsPage(),
      '/shopping': (final context) => const ShoppingCartPage(),
    },
  );
}

class MainMenuPage extends EngineStatelessWidget {
  MainMenuPage({super.key});

  @override
  String get screenName => 'main_menu';

  @override
  Map<String, dynamic>? get screenParameters => {
    'app_version': '1.0.0',
    'source': 'app_launch',
  };

  @override
  Widget buildWithTracking(final BuildContext context) => Scaffold(
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
            onPressed: () async {
              await logUserAction(
                'navigate_to_profile',
                parameters: {
                  'navigation_method': 'button_tap',
                  'source_screen': screenName,
                },
              );
              unawaited(Navigator.pushNamed(context, '/profile'));
            },
            child: const Text('Perfil do Usuário'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await logUserAction(
                'navigate_to_settings',
                parameters: {
                  'navigation_method': 'button_tap',
                  'source_screen': screenName,
                },
              );
              unawaited(Navigator.pushNamed(context, '/settings'));
            },
            child: const Text('Configurações'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await logUserAction(
                'navigate_to_shopping',
                parameters: {
                  'navigation_method': 'button_tap',
                  'source_screen': screenName,
                },
              );
              unawaited(Navigator.pushNamed(context, '/shopping'));
            },
            child: const Text('Carrinho de Compras'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              await logCustomEvent(
                'feature_demo',
                parameters: {
                  'feature_type': 'premium_feature',
                  'user_type': 'free',
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Evento customizado registrado!'),
                ),
              );
            },
            child: const Text('Demonstrar Evento Customizado'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                throw Exception('Erro demonstrativo');
              } catch (e, stackTrace) {
                await logScreenError(
                  'Erro simulado para demonstração',
                  exception: e,
                  stackTrace: stackTrace,
                  additionalData: {
                    'error_type': 'demonstration',
                    'user_triggered': true,
                  },
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro registrado no sistema!')),
              );
            },
            child: const Text('Simular Erro'),
          ),
        ],
      ),
    ),
  );
}

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
  Widget buildWithTracking(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Perfil do Usuário')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
            onChanged: (final value) async {
              setState(() {
                _name = value;
              });

              await logStateChange(
                'name_field_changed',
                additionalData: {
                  'character_count': value.length,
                  'has_content': value.isNotEmpty,
                },
              );
            },
            onSubmitted: (final value) async {
              await logUserAction(
                'field_completed',
                parameters: {
                  'field': 'name',
                  'character_count': value.length,
                },
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            onChanged: (final value) async {
              setState(() {
                _email = value;
              });

              await logStateChange(
                'email_field_changed',
                additionalData: {
                  'character_count': value.length,
                  'is_valid_format': value.contains('@'),
                },
              );
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Receber Notificações'),
            value: _notificationsEnabled,
            onChanged: (final value) async {
              setState(() {
                _notificationsEnabled = value;
              });

              await logUserAction(
                'notification_preference_changed',
                parameters: {'enabled': value, 'source': 'profile_settings'},
              );
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (_name.isNotEmpty && _email.isNotEmpty)
                ? () async {
                    await logUserAction(
                      'profile_save_attempted',
                      parameters: {
                        'name_length': _name.length,
                        'email_length': _email.length,
                        'notifications_enabled': _notificationsEnabled,
                        'completion_percentage': _getProfileCompletion(),
                      },
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Perfil salvo com sucesso!'),
                      ),
                    );
                  }
                : null,
            child: const Text('Salvar Perfil'),
          ),
        ],
      ),
    ),
  );
}

class SettingsPage extends EngineStatelessWidget {
  SettingsPage({super.key});

  @override
  String get screenName => 'app_settings';

  @override
  Widget buildWithTracking(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Configurações')),
    body: ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notificações'),
          subtitle: const Text('Gerenciar preferências de notificação'),
          onTap: () async {
            await logUserAction(
              'settings_item_tapped',
              parameters: {
                'setting_type': 'notifications',
                'item_position': 0,
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacidade'),
          subtitle: const Text('Configurações de privacidade e dados'),
          onTap: () async {
            await logUserAction(
              'settings_item_tapped',
              parameters: {'setting_type': 'privacy', 'item_position': 1},
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Segurança'),
          subtitle: const Text('Configurações de segurança da conta'),
          onTap: () async {
            await logUserAction(
              'settings_item_tapped',
              parameters: {'setting_type': 'security', 'item_position': 2},
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Ajuda'),
          subtitle: const Text('Central de ajuda e suporte'),
          onTap: () async {
            await logUserAction(
              'settings_item_tapped',
              parameters: {'setting_type': 'help', 'item_position': 3},
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Sobre o App'),
          onTap: () async {
            await logCustomEvent(
              'about_app_accessed',
              parameters: {'source_screen': screenName},
            );
          },
        ),
      ],
    ),
  );
}

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

  double _calculateTotal() => _products.fold(
    0.0,
    (final sum, final product) => sum + (product['price'] as double) * (product['quantity'] as int),
  );

  @override
  Widget buildWithTracking(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Carrinho'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          onPressed: _products.isNotEmpty
              ? () async {
                  await logUserAction(
                    'clear_cart_pressed',
                    parameters: {
                      'items_to_remove': _products.length,
                      'total_value_lost': _calculateTotal(),
                    },
                  );

                  setState(_products.clear);

                  await logStateChange(
                    'cart_cleared',
                    additionalData: {
                      'action': 'clear_all',
                      'remaining_items': 0,
                    },
                  );
                }
              : null,
        ),
      ],
    ),
    body: _products.isEmpty
        ? const Center(
            child: Text(
              'Carrinho vazio',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (final context, final index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(product['name'] as String),
                        subtitle: Text(
                          // ignore: avoid_dynamic_calls
                          'R\$ ${product['price']?.toStringAsFixed(2)} x ${product['quantity']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                setState(() {
                                  if ((product['quantity'] as int) > 1) {
                                    product['quantity'] = (product['quantity'] as int) - 1;
                                  }
                                });

                                await logUserAction(
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
                              onPressed: () async {
                                setState(() {
                                  product['quantity'] = (product['quantity'] as int) + 1;
                                });

                                await logUserAction(
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
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final removedProduct = _products[index];
                                setState(() {
                                  _products.removeAt(index);
                                });

                                await logUserAction(
                                  'product_removed',
                                  parameters: {
                                    'product_id': removedProduct['id'],
                                    'product_name': removedProduct['name'],
                                    'quantity_removed': removedProduct['quantity'],
                                    'value_lost':
                                        (removedProduct['price'] as double) * (removedProduct['quantity'] as int),
                                  },
                                );

                                await logStateChange(
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
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${_calculateTotal().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _products.isNotEmpty
                            ? () async {
                                await logUserAction(
                                  'checkout_initiated',
                                  parameters: {
                                    'product_count': _products.length,
                                    'total_value': _calculateTotal(),
                                    'items': _products
                                        .map(
                                          (final p) => {
                                            'id': p['id'],
                                            'quantity': p['quantity'],
                                          },
                                        )
                                        .toList(),
                                  },
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checkout iniciado!'),
                                    backgroundColor: Colors.green,
                                  ),
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

Future<void> initializeTrackingExample() async {
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: EngineFirebaseAnalyticsConfig(
      enabled: false,
    ),
    faroConfig: EngineFaroConfig(
      enabled: false,
      endpoint: '',
      appName: '',
      appVersion: '',
      environment: '',
      apiKey: '',
      namespace: '',
      platform: '',
    ),
    splunkConfig: EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
    clarityConfig: EngineClarityConfig(enabled: false, projectId: ''),
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: EngineCrashlyticsConfig(enabled: false),
    faroConfig: EngineFaroConfig(
      enabled: false,
      endpoint: '',
      appName: '',
      appVersion: '',
      environment: '',
      apiKey: '',
      namespace: '',
      platform: '',
    ),
    googleLoggingConfig: EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
  await EngineBugTracking.initWithModel(bugTrackingModel);

  debugPrint('Sistema de tracking inicializado para exemplo!');
}
