import 'package:engine_tracking/engine_tracking.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do Google Cloud Logging
  // Você precisa criar uma Service Account no Google Cloud Console
  // e baixar o arquivo JSON com as credenciais
  const googleLoggingConfig = EngineGoogleLoggingConfig(
    enabled: true,
    projectId: 'seu-projeto-id',
    logName: 'engine-tracking',
    credentials: {
      // Coloque aqui o conteúdo do seu arquivo de credenciais JSON
      "type": "service_account",
      "project_id": "seu-projeto-id",
      "private_key_id": "...",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      "client_email": "sua-service-account@seu-projeto-id.iam.gserviceaccount.com",
      "client_id": "...",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "...",
    },
    resource: {
      'type': 'global',
      'labels': {
        'project_id': 'seu-projeto-id',
      },
    },
  );

  // Opção 1: Inicializar com adaptadores individuais
  await EngineAnalytics.init([
    EngineGoogleLoggingAnalyticsAdapter(googleLoggingConfig),
  ]);

  await EngineBugTracking.init([
    EngineGoogleLoggingBugTrackingAdapter(googleLoggingConfig),
  ]);

  // Opção 2: Inicializar com modelos (recomendado)
  // final analyticsModel = EngineAnalyticsModel(
  //   firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: false),
  //   faroConfig: const EngineFaroConfig(
  //     enabled: false,
  //     endpoint: '',
  //     appName: '',
  //     appVersion: '',
  //     environment: '',
  //     apiKey: '',
  //     namespace: '',
  //     platform: '',
  //   ),
  //   googleLoggingConfig: googleLoggingConfig,
  //   splunkConfig: const EngineSplunkConfig(
  //     enabled: false,
  //     endpoint: '',
  //     token: '',
  //     source: '',
  //     sourcetype: '',
  //     index: '',
  //   ),
  // );

  // final bugTrackingModel = EngineBugTrackingModel(
  //   crashlyticsConfig: const EngineCrashlyticsConfig(enabled: false),
  //   faroConfig: const EngineFaroConfig(
  //     enabled: false,
  //     endpoint: '',
  //     appName: '',
  //     appVersion: '',
  //     environment: '',
  //     apiKey: '',
  //     namespace: '',
  //     platform: '',
  //   ),
  //   googleLoggingConfig: googleLoggingConfig,
  // );

  // await EngineAnalytics.initWithModel(analyticsModel);
  // await EngineBugTracking.initWithModel(bugTrackingModel);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Cloud Logging Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GoogleLoggingExamplePage(),
    );
  }
}

class GoogleLoggingExamplePage extends StatelessWidget {
  const GoogleLoggingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Cloud Logging Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Enviando evento de analytics
                await EngineAnalytics.logEvent('button_clicked', {
                  'button_name': 'test_analytics',
                  'screen': 'home',
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics event sent!')),
                );
              },
              child: const Text('Send Analytics Event'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Definindo identificador do usuário
                await EngineAnalytics.setUserId(
                  'user123',
                  'user@example.com',
                  'John Doe',
                );

                await EngineBugTracking.setUserIdentifier(
                  'user123',
                  'user@example.com',
                  'John Doe',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User identified!')),
                );
              },
              child: const Text('Set User ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Registrando uma propriedade do usuário
                await EngineAnalytics.setUserProperty('plan', 'premium');

                // Registrando uma chave customizada para bug tracking
                await EngineBugTracking.setCustomKey('app_version', '1.0.0');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Properties set!')),
                );
              },
              child: const Text('Set User Properties'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Registrando visualização de tela
                await EngineAnalytics.setPage(
                  'home_screen',
                  'splash_screen',
                  {'campaign': 'summer_sale'},
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Page view tracked!')),
                );
              },
              child: const Text('Track Page View'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Enviando log de bug tracking
                await EngineBugTracking.log(
                  'User performed action',
                  level: 'INFO',
                  attributes: {
                    'action': 'button_click',
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log sent!')),
                );
              },
              child: const Text('Send Log'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Simulando um erro
                  throw Exception('Test exception for Google Cloud Logging');
                } catch (e, stackTrace) {
                  await EngineBugTracking.recordError(
                    e,
                    stackTrace,
                    reason: 'Test error button clicked',
                    information: ['User clicked the test error button'],
                    isFatal: false,
                    data: {'button': 'test_error'},
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error recorded!')),
                  );
                }
              },
              child: const Text('Test Error'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Testando crash (não fatal)
                await EngineBugTracking.testCrash();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test crash sent!')),
                );
              },
              child: const Text('Test Crash'),
            ),
          ],
        ),
      ),
    );
  }
}
