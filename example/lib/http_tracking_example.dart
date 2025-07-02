import 'dart:convert';

import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpTrackingExample extends StatelessWidget {
  const HttpTrackingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Tracking Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HttpMainPage(),
      routes: {
        '/pokemon': (context) => PokemonListPage(),
        '/posts': (context) => PostsListPage(),
        '/users': (context) => UsersListPage(),
      },
    );
  }
}

class HttpMainPage extends EngineStatelessWidget {
  HttpMainPage({super.key});

  @override
  String get screenName => 'HttpMainPage';

  @override
  Map<String, dynamic>? get screenParameters => {'app_version': '1.0.0', 'example_type': 'http_tracking'};

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplos HTTP Tracking'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Exemplos de Tracking com Chamadas HTTPS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Este exemplo demonstra o tracking de requisições HTTP usando APIs públicas',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.catching_pokemon, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    const Text('PokéAPI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Lista de Pokémons com requisições GET', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        logUserAction(
                          'navigate_to_pokemon_api',
                          parameters: {
                            'api_name': 'pokeapi',
                            'navigation_method': 'button_tap',
                            'source_screen': screenName,
                          },
                        );
                        Navigator.pushNamed(context, '/pokemon');
                      },
                      child: const Text('Ver Pokémons'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.article, size: 48, color: Colors.green),
                    const SizedBox(height: 8),
                    const Text('JSONPlaceholder - Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Lista de posts com GET e criação com POST', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        logUserAction(
                          'navigate_to_posts_api',
                          parameters: {
                            'api_name': 'jsonplaceholder_posts',
                            'navigation_method': 'button_tap',
                            'source_screen': screenName,
                          },
                        );
                        Navigator.pushNamed(context, '/posts');
                      },
                      child: const Text('Ver Posts'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.people, size: 48, color: Colors.orange),
                    const SizedBox(height: 8),
                    const Text('JSONPlaceholder - Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Lista de usuários com requisições GET', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        logUserAction(
                          'navigate_to_users_api',
                          parameters: {
                            'api_name': 'jsonplaceholder_users',
                            'navigation_method': 'button_tap',
                            'source_screen': screenName,
                          },
                        );
                        Navigator.pushNamed(context, '/users');
                      },
                      child: const Text('Ver Usuários'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // Adiciona espaço extra no final
          ],
        ),
      ),
    );
  }
}

class PokemonListPage extends EngineStatelessWidget {
  PokemonListPage({super.key});

  @override
  String get screenName => 'PokemonListPage';

  @override
  Map<String, dynamic>? get screenParameters => {'api_name': 'pokeapi', 'endpoint': 'pokemon', 'request_type': 'GET'};

  Future<List<dynamic>> _fetchPokemonList() async {
    final stopwatch = Stopwatch()..start();

    try {
      logCustomEvent(
        'api_request_started',
        parameters: {
          'api_name': 'pokeapi',
          'endpoint': 'https://pokeapi.co/api/v2/pokemon',
          'method': 'GET',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'),
        headers: {'Accept': 'application/json'},
      );

      stopwatch.stop();

      logCustomEvent(
        'api_request_completed',
        parameters: {
          'api_name': 'pokeapi',
          'endpoint': 'https://pokeapi.co/api/v2/pokemon',
          'method': 'GET',
          'status_code': response.statusCode,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'response_size_bytes': response.body.length,
          'success': response.statusCode == 200,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to load pokemon: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      stopwatch.stop();

      logScreenError(
        'Erro ao carregar lista de pokémons',
        exception: e,
        stackTrace: stackTrace,
        additionalData: {
          'api_name': 'pokeapi',
          'endpoint': 'https://pokeapi.co/api/v2/pokemon',
          'method': 'GET',
          'response_time_ms': stopwatch.elapsedMilliseconds,
        },
      );

      rethrow;
    }
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémons'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando pokémons...')],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      logUserAction('retry_pokemon_list', parameters: {'error_message': snapshot.error.toString()});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PokemonListPage()));
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final pokemonList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.catching_pokemon)),
                  title: Text(
                    pokemon['name'].toString().toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('URL: ${pokemon['url']}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    logUserAction(
                      'pokemon_item_tapped',
                      parameters: {
                        'pokemon_name': pokemon['name'],
                        'pokemon_url': pokemon['url'],
                        'list_position': index,
                      },
                    );

                    // Mostrar detalhes do pokémon
                    showDialog(
                      context: context,
                      builder: (context) => PokemonDetailDialog(pokemonUrl: pokemon['url']),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Dialog para mostrar detalhes do pokémon
class PokemonDetailDialog extends EngineStatelessWidget {
  final String pokemonUrl;

  PokemonDetailDialog({super.key, required this.pokemonUrl});

  Future<Map<String, dynamic>> _fetchPokemonDetails() async {
    final response = await http.get(Uri.parse(pokemonUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pokemon details');
    }
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchPokemonDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasError) {
              return SizedBox(height: 200, child: Center(child: Text('Erro: ${snapshot.error}')));
            }

            final pokemon = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pokemon['name'].toString().toUpperCase(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (pokemon['sprites']?['front_default'] != null)
                  Image.network(pokemon['sprites']['front_default'], height: 100, width: 100),
                const SizedBox(height: 16),
                Text('ID: ${pokemon['id']}'),
                Text('Altura: ${pokemon['height']} decímetros'),
                Text('Peso: ${pokemon['weight']} hectogramas'),
                Text('Exp. Base: ${pokemon['base_experience']}'),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Página de Posts do JSONPlaceholder - Exemplo com GET e POST
class PostsListPage extends EngineStatelessWidget {
  PostsListPage({super.key});

  @override
  String get screenName => 'posts_list_page';

  @override
  Map<String, dynamic>? get screenParameters => {
    'api_name': 'jsonplaceholder',
    'endpoint': 'posts',
    'supported_methods': ['GET', 'POST'],
  };

  Future<List<dynamic>> _fetchPosts() async {
    final stopwatch = Stopwatch()..start();

    try {
      logCustomEvent(
        'api_request_started',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'GET',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
        headers: {'Accept': 'application/json'},
      );

      stopwatch.stop();

      logCustomEvent(
        'api_request_completed',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'GET',
          'status_code': response.statusCode,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'response_size_bytes': response.body.length,
          'success': response.statusCode == 200,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      stopwatch.stop();

      logScreenError(
        'Erro ao carregar lista de posts',
        exception: e,
        stackTrace: stackTrace,
        additionalData: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'GET',
          'response_time_ms': stopwatch.elapsedMilliseconds,
        },
      );

      rethrow;
    }
  }

  Future<Map<String, dynamic>> _createPost(String title, String body) async {
    final stopwatch = Stopwatch()..start();

    try {
      logCustomEvent(
        'api_request_started',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'POST',
          'timestamp': DateTime.now().toIso8601String(),
          'request_data': {'title': title, 'body': body},
        },
      );

      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'title': title, 'body': body, 'userId': 1}),
      );

      stopwatch.stop();

      logCustomEvent(
        'api_request_completed',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'POST',
          'status_code': response.statusCode,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'response_size_bytes': response.body.length,
          'success': response.statusCode == 201,
        },
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      stopwatch.stop();

      logScreenError(
        'Erro ao criar post',
        exception: e,
        stackTrace: stackTrace,
        additionalData: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/posts',
          'method': 'POST',
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'request_data': {'title': title, 'body': body},
        },
      );

      rethrow;
    }
  }

  void _showCreatePostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Novo Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Conteúdo', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && bodyController.text.isNotEmpty) {
                Navigator.pop(context);

                try {
                  logUserAction(
                    'create_post_attempted',
                    parameters: {
                      'title_length': titleController.text.length,
                      'body_length': bodyController.text.length,
                    },
                  );

                  final newPost = await _createPost(titleController.text, bodyController.text);

                  logUserAction(
                    'create_post_success',
                    parameters: {'post_id': newPost['id'], 'title': newPost['title']},
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post criado com sucesso! ID: ${newPost['id']}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erro ao criar post: $e'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts - JSONPlaceholder'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              logUserAction('add_post_button_tapped', parameters: {'source_screen': screenName});
              _showCreatePostDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando posts...')],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      logUserAction('retry_posts_list', parameters: {'error_message': snapshot.error.toString()});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostsListPage()));
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final posts = snapshot.data ?? [];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${post['id']}')),
                  title: Text(
                    post['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(post['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    logUserAction(
                      'post_item_tapped',
                      parameters: {'post_id': post['id'], 'post_title': post['title'], 'list_position': index},
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Post #${post['id']}'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 16),
                              Text(post['body']),
                            ],
                          ),
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Página de Usuários do JSONPlaceholder - Exemplo com GET
class UsersListPage extends EngineStatelessWidget {
  UsersListPage({super.key});

  @override
  String get screenName => 'users_list_page';

  @override
  Map<String, dynamic>? get screenParameters => {
    'api_name': 'jsonplaceholder',
    'endpoint': 'users',
    'request_type': 'GET',
  };

  Future<List<dynamic>> _fetchUsers() async {
    final stopwatch = Stopwatch()..start();

    try {
      logCustomEvent(
        'api_request_started',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/users',
          'method': 'GET',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        headers: {'Accept': 'application/json'},
      );

      stopwatch.stop();

      logCustomEvent(
        'api_request_completed',
        parameters: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/users',
          'method': 'GET',
          'status_code': response.statusCode,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'response_size_bytes': response.body.length,
          'success': response.statusCode == 200,
          'users_count': response.statusCode == 200 ? json.decode(response.body).length : 0,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      stopwatch.stop();

      logScreenError(
        'Erro ao carregar lista de usuários',
        exception: e,
        stackTrace: stackTrace,
        additionalData: {
          'api_name': 'jsonplaceholder',
          'endpoint': 'https://jsonplaceholder.typicode.com/users',
          'method': 'GET',
          'response_time_ms': stopwatch.elapsedMilliseconds,
        },
      );

      rethrow;
    }
  }

  @override
  Widget buildWithTracking(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários - JSONPlaceholder'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando usuários...')],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      logUserAction('retry_users_list', parameters: {'error_message': snapshot.error.toString()});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsersListPage()));
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user['name'][0])),
                  title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['email']}'),
                      Text('Telefone: ${user['phone']}'),
                      Text('Website: ${user['website']}'),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    logUserAction(
                      'user_item_tapped',
                      parameters: {
                        'user_id': user['id'],
                        'user_name': user['name'],
                        'user_email': user['email'],
                        'list_position': index,
                      },
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(user['name']),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildUserInfoRow('ID', user['id'].toString()),
                              _buildUserInfoRow('Username', user['username']),
                              _buildUserInfoRow('Email', user['email']),
                              _buildUserInfoRow('Telefone', user['phone']),
                              _buildUserInfoRow('Website', user['website']),
                              const Divider(),
                              const Text('Endereço:', style: TextStyle(fontWeight: FontWeight.bold)),
                              _buildUserInfoRow('Rua', '${user['address']['street']}, ${user['address']['suite']}'),
                              _buildUserInfoRow('Cidade', user['address']['city']),
                              _buildUserInfoRow('CEP', user['address']['zipcode']),
                              const Divider(),
                              const Text('Empresa:', style: TextStyle(fontWeight: FontWeight.bold)),
                              _buildUserInfoRow('Nome', user['company']['name']),
                              _buildUserInfoRow('Slogan', user['company']['catchPhrase']),
                            ],
                          ),
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// Função para demonstrar a inicialização do sistema com tracking HTTP
Future<void> initializeHttpTrackingExample() async {
  final analyticsModel = EngineAnalyticsModel(
    firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector-prod-us-east-0.grafana.net/collect',
      appName: 'engine_tracking_http_example',
      appVersion: '1.0.0',
      environment: 'development',
      apiKey: 'your-api-key-here',
      namespace: 'flutter_app',
      platform: 'mobile',
    ),
    splunkConfig: const EngineSplunkConfig(
      enabled: false,
      endpoint: '',
      token: '',
      source: '',
      sourcetype: '',
      index: '',
    ),
    clarityConfig: const EngineClarityConfig(
      enabled: false,
      projectId: '',
    ),
    googleLoggingConfig: const EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  final bugTrackingModel = EngineBugTrackingModel(
    crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
    faroConfig: const EngineFaroConfig(
      enabled: true,
      endpoint: 'https://faro-collector-prod-us-east-0.grafana.net/collect',
      appName: 'engine_tracking_http_example',
      appVersion: '1.0.0',
      environment: 'development',
      apiKey: 'your-api-key-here',
      namespace: 'flutter_app',
      platform: 'mobile',
    ),
    googleLoggingConfig: const EngineGoogleLoggingConfig(
      enabled: false,
      projectId: '',
      logName: '',
      credentials: {},
    ),
  );

  await EngineAnalytics.initWithModel(analyticsModel);
  await EngineBugTracking.initWithModel(bugTrackingModel);

  print('Sistema de tracking HTTP inicializado com sucesso!');
  print('- PokéAPI: https://pokeapi.co/api/v2/pokemon');
  print('- JSONPlaceholder Posts: https://jsonplaceholder.typicode.com/posts');
  print('- JSONPlaceholder Users: https://jsonplaceholder.typicode.com/users');
}
