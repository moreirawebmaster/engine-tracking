# Changelog

All notable changes to the Engine Tracking library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2025-01-23

### Added
- **EngineClarityAdapter**: New dedicated adapter for Microsoft Clarity analytics
- Enhanced Microsoft Clarity integration with proper adapter pattern
- Clarity-specific status verification methods in EngineAnalytics
- Automatic session ID synchronization with Clarity sessions

### Changed
- Improved documentation structure and readability
- Simplified architecture diagrams for better understanding
- Enhanced code examples with real-world scenarios
- Updated README.md with professional tone and clearer sections
- Microsoft Clarity now uses dedicated adapter instead of widget-only integration

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