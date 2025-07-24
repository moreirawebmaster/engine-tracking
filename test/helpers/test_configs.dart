import 'package:engine_tracking/engine_tracking.dart';

/// Configurações padrão para testes
class TestConfigs {
  TestConfigs._();

  /// Configuração padrão do Google Cloud Logging para testes
  static final googleLoggingConfig = EngineGoogleLoggingConfig(
    enabled: false,
    projectId: '',
    logName: '',
    credentials: {},
  );

  /// Configuração habilitada do Google Cloud Logging para testes
  static final googleLoggingConfigEnabled = EngineGoogleLoggingConfig(
    enabled: true,
    projectId: 'test-project',
    logName: 'test-logs',
    credentials: {
      'type': 'service_account',
      'project_id': 'test-project',
      'private_key_id': 'test-key-id',
      'private_key': '-----BEGIN PRIVATE KEY-----\ntest-key\n-----END PRIVATE KEY-----\n',
      'client_email': 'test@test-project.iam.gserviceaccount.com',
      'client_id': 'test-client-id',
    },
  );
}
