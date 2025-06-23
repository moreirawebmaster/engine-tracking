# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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