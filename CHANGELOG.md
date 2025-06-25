# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-01-23

### Added
- **🌐 HTTP Tracking Example**: Novo exemplo completo demonstrando tracking de requisições HTTPS

### Enhanced
#### Exemplo HTTP Tracking
- **PokéAPI Integration**: Demonstração de requisições GET para dados de pokémons
- **JSONPlaceholder Integration**: Exemplo completo com GET e POST para posts e usuários
- **Métricas Detalhadas**: Tracking automático de:
  - Tempo de resposta em milissegundos
  - Códigos de status HTTP
  - Tamanho das respostas em bytes
  - Sucesso/falha das requisições
  - Timestamps completos
- **Tratamento de Erros**: Sistema robusto de captura e logging de erros HTTP
- **Interface Responsiva**: Design adaptativo com scroll automático

#### Funcionalidades das APIs
- **Pokemon List Page**: Lista interativa de pokémons com detalhes em modal
- **Posts List Page**: Visualização e criação de posts com tracking completo
- **Users List Page**: Lista detalhada de usuários com informações completas

#### Sistema de Tracking
- **EngineStatelessWidget**: Implementação otimizada para tracking automático

### Fixed
- **Code Organization**: Otimização do código com redução de linhas desnecessárias

### Dependencies
- **http: ^1.1.0**: Adicionada para requisições HTTP no exemplo

## [1.1.0] - 2025-01-23

### Added
- **Sistema de Configuração Aprimorado**: Nova arquitetura de configuração com modelos padrão
- **Cobertura de Testes Abrangente**: 62 testes de unidade com cobertura superior a 95% nas configurações
- **Documentação Completa**: README detalhado com exemplos práticos de uso
- **Exemplos de View Tracking**: Sistema completo de tracking de telas e ações de usuário

### Enhanced
#### Configuração de Analytics
- `EngineAnalyticsModel`: Modelo principal para configuração de analytics
- `EngineAnalyticsModelDefault`: Implementação padrão com serviços desabilitados por segurança
- `EngineFirebaseAnalyticsConfig`: Configuração específica do Firebase Analytics
- Reutilização da configuração Faro para integração dual

#### Sistema de Analytics Refatorado
- **EngineAnalytics**: Refatorado para usar sistema de configuração baseado em modelos
- **Construtor Privado**: Implementação de padrão singleton com métodos estáticos apenas
- **Inicialização Condicional**: Serviços inicializam apenas quando habilitados
- **Método Reset**: Suporte para reset de configuração (útil para testes)

#### Testes de Unidade
- `engine_firebase_analytics_config_test.dart`: 8 testes para configuração Firebase
- `engine_analytics_model_test.dart`: 8 testes para modelos de analytics
- `engine_analytics_test.dart`: 6 testes para funcionalidades principais
- `engine_crashlytics_config_test.dart`: 8 testes para configuração Crashlytics
- `engine_faro_config_test.dart`: 8 testes para configuração Faro
- `engine_bug_tracking_model_test.dart`: 8 testes para modelos de bug tracking
- `engine_bug_tracking_test.dart`: 6 testes para funcionalidades de bug tracking
- `engine_log_level_test.dart`: 5 testes para níveis de log
- `engine_log_test.dart`: 7 testes para sistema de logging

#### Exemplos Práticos
- **View Tracking Example**: Aplicação completa demonstrando tracking de views
- **Mixins de Tracking**: `EngineStatelessWidget` e `EngineStatefulWidget`
- **Tracking Automático**: Sistema automático de tracking de entrada e saída de telas
- **Parâmetros Customizados**: Suporte a parâmetros específicos por tela
- **Eventos de Usuário**: Logging de ações, mudanças de estado e eventos customizados

### Fixed
- **Null Safety**: Correção de campos `late final` para nullable evitando erros de inicialização
- **Dependências Firebase**: Isolamento adequado de dependências para testes
- **Arquitetura Static**: Padronização de toda API pública como métodos estáticos

### Documentation
- **README Atualizado**: Documentação completa com:
  - Instalação e configuração passo a passo
  - Exemplos de uso para Analytics e Bug Tracking
  - Configurações avançadas por ambiente
  - Melhores práticas de implementação
  - Suporte a todas as plataformas Flutter

### Quality Improvements
- **Cobertura de Testes**: 
  - Config Files: 100% (3/3 arquivos)
  - Model Files: 100% (2/2 arquivos)
  - Logging: 77% (24/31 linhas)
  - Cobertura Total: 33.5% (62 de 185 linhas executáveis)
- **62 Testes Passando**: 100% de sucesso em todos os testes
- **Arquitetura Consistente**: Padronização com prefixo "Engine" em todas as classes
- **Type Safety**: Implementação tipo-segura em toda a biblioteca

### Breaking Changes
- `EngineAnalyticsService` renomeado para `EngineAnalytics` (consistência de nomenclatura)
- Remoção de providers individuais em favor do sistema de configuração baseado em modelos
- API de inicialização alterada para usar modelos de configuração

### Migration Guide
```dart
// Antes (v1.0.x)
await EngineAnalyticsService.initialize(/* ... */);

// Agora (v1.1.0+)
final analyticsModel = EngineAnalyticsModel(
  firebaseConfig: EngineFirebaseAnalyticsConfig(
    enabled: true,
  ),
  faroConfig: EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro.example.com',
    // ... outras configurações
  ),
);
await EngineAnalytics.initWithModel(analyticsModel);
```

## [1.0.1] - 2025-06-23

### Added
- **Complete CI/CD Infrastructure**: Comprehensive GitHub Actions pipeline for automated testing, analysis, and publishing
- **Code Quality Integration**: Pana analysis with perfect 160/160 score requirement
- **Code Coverage Tracking**: Codecov integration with 49.5% coverage (45% target)
- **Professional Issue Templates**: Structured templates for bug reports and feature requests
- **Development Automation**: Scripts for automated testing and quality analysis
- **Quality Assurance**: Weekly automated security and dependency audits

### Infrastructure Files Added
```
.github/
├── workflows/
│   ├── ci.yml              # Main CI pipeline (tests, analysis, coverage)
│   ├── publish.yml         # Automatic pub.dev publishing on tags
│   └── quality.yml         # Weekly quality and security checks
├── issue_template/
│   ├── bug_report.md       # Structured bug reporting template
│   └── feature_request.md  # Feature request template with priority
├── pull_request_template.md # Comprehensive PR review template
└── README.md               # CI/CD infrastructure documentation

codecov.yml                 # Code coverage configuration (45% target)
pana_config.yaml           # Package analysis configuration (160/160 score)
scripts/
├── test_coverage.sh       # Automated test coverage with HTML reports
└── pana_analysis.sh       # Package quality analysis script
```

### CI/CD Features
- **Automated Testing**: Complete test suite execution with coverage reporting
- **Code Quality**: Integrated Pana analysis and Flutter code analysis
- **Format Validation**: Automatic code formatting verification
- **Publishing Automation**: Tag-based automatic publishing to pub.dev
- **Security Audits**: Weekly dependency and security analysis
- **Coverage Integration**: Codecov reporting with PR comments

### Quality Standards Achieved
- ✅ **Pana Score**: 160/160 (Perfect)
- ✅ **Tests**: 83 passing (100% success rate)
- ✅ **Coverage**: 49.5% (exceeds 45% target)
- ✅ **Linting**: 0 warnings, 0 errors
- ✅ **Formatting**: 100% compliant

### Configuration Optimizations
- **Branch Strategy**: Streamlined to main branch workflow
- **Template Internationalization**: English templates for global accessibility
- **Publishing Method**: Direct `dart pub publish` with secure credential management
- **Quality Requirements**: Perfect Pana score enforcement

## [1.0.0] - 2025-01-22

### Added
- Initial release of `engine_tracking` package
- **EngineAnalytics**: Complete analytics system supporting Firebase Analytics and Grafana Faro
- **EngineBugTracking**: Bug tracking system with Firebase Crashlytics and Grafana Faro integration
- **EngineLog**: Structured logging system with multiple log levels
- **Configuration Models**: Type-safe configuration classes for all services
- **Dual Integration**: Simultaneous support for Firebase and Grafana Faro services
- **Conditional Initialization**: Services initialize only when enabled in configuration
- **Static API**: All public methods are static for easy access

### Features
#### Analytics (EngineAnalytics)
- Event logging with custom parameters
- User identification and properties
- Page/screen tracking
- App open events
- Firebase Analytics integration
- Grafana Faro integration

#### Bug Tracking (EngineBugTracking)
- Error recording with stack traces
- Flutter error handling
- User identification
- Custom key-value logging
- Structured logging with levels
- Firebase Crashlytics integration
- Grafana Faro integration

#### Configuration
- `EngineAnalyticsModel`: Analytics configuration model
- `EngineFirebaseAnalyticsConfig`: Firebase Analytics configuration
- `EngineBugTrackingModel`: Bug tracking configuration model
- `EngineCrashlyticsConfig`: Crashlytics configuration
- `EngineFaroConfig`: Grafana Faro configuration (shared)

#### System
- `EngineLogLevelType`: Log level enumeration
- `EngineLog`: Structured logging implementation

### Supported Platforms
- ✅ iOS
- ✅ Android

### Dependencies
- `firebase_core: ^3.14.0`
- `firebase_analytics: ^11.5.0`
- `firebase_crashlytics: ^4.3.7`
- `faro: ^0.3.6`

### Development
- Flutter lints for code quality
- Dart SDK compatibility: `>=3.8.0 <4.0.0`
- Flutter compatibility: `>=3.32.0`

---

## [Unreleased]

### Planned Features
- Web platform support
- macOS platform support  
- Windows platform support
- Linux platform support
- Advanced filtering options
- Performance monitoring integration
- Custom event validation 