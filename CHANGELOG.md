# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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