# Changelog

All notable changes to the Engine Tracking library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.0] - 2025-01-25

### Added
- **EngineHttpTrackingModel**: New model-based configuration system for HTTP tracking following the same pattern as analytics and bug tracking models
- **Model-based Architecture**: HTTP tracking now uses `EngineHttpTrackingModel` with `enabled` flag in the model instead of configuration
- **EngineHttpTrackingModelDefault**: Default implementation with HTTP tracking disabled
- **Unified Initialization**: HTTP tracking now integrates with `EngineTrackingInitialize.initWithModels()` method
- **Enhanced EngineWidget**: Automatically detects Clarity configuration from initialized adapters, no manual configuration needed

### Changed
- **BREAKING**: `EngineHttpTrackingConfig` no longer extends `IEngineConfig` and doesn't have `enabled` parameter
- **BREAKING**: HTTP tracking initialization now uses `EngineHttpTracking.initWithModel()` instead of `initialize()`
- **BREAKING**: `EngineWidget` no longer requires `clarityConfig` parameter - automatically detects from `EngineAnalytics`
- **Improved**: HTTP tracking follows the same architectural pattern as analytics and bug tracking services
- **Enhanced**: Better consistency across all tracking services with unified model approach
- **Updated**: Example app demonstrates new model-based HTTP tracking configuration

### Removed
- **BREAKING**: `EngineHttpTracking.withConfig()` - Method removed as it was deemed irrelevant for the new architecture
- **BREAKING**: `EngineHttpTracking.withModel()` - Method removed as it was deemed irrelevant for the new architecture

### Deprecated
- `EngineHttpTracking.initialize()` - Use `initWithModel()` instead
- Manual `clarityConfig` parameter in `EngineWidget` - Now automatically detected

### Documentation
- Updated README.md with new model-based HTTP tracking examples
- Enhanced documentation showing unified initialization approach
- Added backward compatibility notes for deprecated methods
- Improved example app with proper model usage

### Migration Guide
```dart
// Before (v1.5.1)
EngineHttpTracking.initialize(EngineHttpTrackingConfig(
  enabled: true,
  enableRequestLogging: true,
  // ...
));

// After (v1.6.0)
EngineHttpTracking.initWithModel(EngineHttpTrackingModel(
  enabled: true,
  httpTrackingConfig: EngineHttpTrackingConfig(
    enableRequestLogging: true,
    // ...
  ),
));

// Removed methods (no direct replacement)
// EngineHttpTracking.withConfig() - REMOVED
// EngineHttpTracking.withModel() - REMOVED
// Use updateModel() for runtime configuration changes instead

// EngineWidget - Before
EngineWidget(
  app: MyApp(),
  clarityConfig: clarityConfig,
)

// EngineWidget - After (automatic detection)
EngineWidget(app: MyApp())
```

## [1.5.1] - 2025-01-23

### Changed
- Improved README.md structure and organization
- Removed duplicate content and explanations
- Enhanced documentation clarity for better developer experience
- Optimized Mermaid diagrams for better readability
- Consolidated examples and usage patterns

### Documentation
- Restructured README.md with better progressive disclosure
- Improved Quick Start section for faster onboarding
- Enhanced architecture overview with clearer diagrams
- Better organization of usage examples and configuration options
- Streamlined installation and setup instructions

## [1.5.0] - 2025-01-23

### Added
- **HTTP Tracking**: Complete HTTP request/response tracking system with `EngineHttpTracking`
- **EngineClarityAdapter**: New dedicated adapter for Microsoft Clarity analytics
- **IEngineConfig**: Interface for standardized configuration management
- Enhanced Microsoft Clarity integration with proper adapter pattern
- Clarity-specific status verification methods in EngineAnalytics
- Automatic session ID synchronization with Clarity sessions
- HTTP client override for automatic request interception
- Comprehensive HTTP tracking with request/response logging

### Changed
- Improved documentation structure and readability
- Simplified architecture diagrams for better understanding
- Enhanced code examples with real-world scenarios
- Updated README.md with professional tone and clearer sections
- Microsoft Clarity now uses dedicated adapter instead of widget-only integration
- Enhanced error handling across all adapters
- Improved configuration masking for sensitive data

### Dependencies
- Updated `firebase_crashlytics` from ^4.3.7 to ^4.3.10 - Enhanced crash reporting stability
- Updated `firebase_analytics` from ^11.5.0 to ^11.6.0 - Latest Firebase Analytics features and improvements
- Updated `faro` from ^0.3.6 to ^0.4.1 - Improved Grafana Faro observability capabilities
- Updated `clarity_flutter` from ^1.0.0 to ^1.2.0 - Enhanced Microsoft Clarity integration
- Updated `mockito` from ^5.4.4 to ^5.5.0 (dev dependency) - Better testing framework support
- Updated `build_runner` from ^2.4.9 to ^2.6.0 (dev dependency) - Improved code generation performance

### Documentation
- Added comprehensive changelog
- Restructured README.md for better developer experience
- Simplified Mermaid diagrams with English labels
- Improved installation and setup instructions
- Enhanced code examples and usage patterns
- Updated architecture diagrams to include Clarity adapter
- Added HTTP tracking examples and documentation

## [1.4.0] - 2024-12-15

### Added
- Session ID automatic correlation system with UUID v4 generation
- Centralized initialization with `EngineTrackingInitialize` class
- Enhanced widget tracking with `EngineStatelessWidget` and `EngineStatefulWidget`
- Comprehensive logging system with `EngineLog` and multiple levels
- HTTP request tracking capabilities with automatic monitoring
- Navigation observer with `EngineNavigationObserver` for automatic screen tracking
- Custom widgets with built-in tracking: `EngineWidget`, `EngineMaskWidget`

### Changed
- Improved session management with automatic correlation across all services
- Enhanced error handling with automatic Flutter error capture
- Better adapter pattern implementation for service integrations
- Optimized performance with conditional service initialization

### Features
- Multi-platform analytics support (Firebase, Faro, Splunk, Google Cloud Logging)
- Advanced bug tracking with Firebase Crashlytics integration
- Type-safe implementation with full Dart null safety
- Flexible service configuration (enable/disable individual services)

## [1.3.0] - 2024-11-20

### Added
- Google Cloud Logging integration for analytics and bug tracking
- Microsoft Clarity support for session recordings and heatmaps
- Splunk integration for enterprise logging
- Enhanced Grafana Faro support with improved configuration

### Changed
- Improved adapter pattern with better error handling
- Enhanced configuration system with validation
- Better documentation with comprehensive examples

### Fixed
- Memory leaks in service adapters
- Initialization race conditions
- Configuration validation issues

## [1.2.0] - 2024-10-15

### Added
- Grafana Faro integration for observability and monitoring
- Enhanced Firebase Analytics adapter with custom parameters
- Improved error tracking with context information
- Session management with automatic ID generation

### Changed
- Refactored adapter architecture for better maintainability
- Improved initialization process with better error handling
- Enhanced logging system with structured output

### Fixed
- Firebase Crashlytics initialization issues
- Analytics event parameter validation
- Memory management improvements

## [1.1.0] - 2024-09-10

### Added
- Firebase Crashlytics integration for crash reporting
- Enhanced Firebase Analytics support
- Custom error tracking with stack traces
- User identification and properties management

### Changed
- Improved service initialization with better error handling
- Enhanced adapter pattern implementation
- Better configuration management

### Fixed
- Service initialization timing issues
- Analytics event tracking reliability
- Bug tracking context preservation

## [1.0.0] - 2024-08-01

### Added
- Initial release of Engine Tracking library
- Firebase Analytics integration
- Basic bug tracking capabilities
- Type-safe Dart implementation
- iOS and Android platform support
- Unified API for multiple tracking services
- Adapter pattern for service integrations

### Features
- Analytics event tracking
- User management and properties
- Screen navigation tracking
- Error reporting and logging
- Flexible service configuration

### Platforms
- iOS support
- Android support

---

## Contributing

When contributing to this project, please:

1. Update the changelog for any notable changes
2. Follow semantic versioning principles
3. Include dependency updates in the Dependencies section
4. Categorize changes appropriately (Added, Changed, Fixed, Removed, Security)
5. Include the date of release in YYYY-MM-DD format