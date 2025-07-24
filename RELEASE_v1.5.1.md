# Engine Tracking v1.5.1

## 📚 Public API Documentation Release

This release focuses on improving developer experience through comprehensive public API documentation and resolving code quality issues.

## 🎯 What's New

### ✅ Complete Public API Documentation
- **562+ lines** of documentation added across **32 files**
- **All public members** now have proper Dartdoc comments (///)
- **Full compliance** with `public_member_api_docs` lint rule
- **Zero lint issues** - from 38 issues to 0

### 🔧 Bug Fixes
- **Deprecated Warning Resolved**: Fixed `userId` deprecation warning in Clarity adapter
- **Code Quality**: Improved maintainability and readability
- **Future-Proof**: Resolved deprecation warnings for upcoming versions

## 📊 Technical Details

### Files Documented
- `lib/src/bug_tracking/engine_bug_tracking.dart` - Methods and getters
- `lib/src/config/engine_http_tracking_config.dart` - Class and constructor
- `lib/src/http/engine_http_override.dart` - Class and constructor  
- `lib/src/observers/engine_navigator_observer.dart` - Class and fields
- `lib/src/session/engine_session.dart` - Class, singleton, getters and methods
- `lib/src/utils/engine_util.dart` - Typedefs and utility functions
- `lib/src/widgets/engine_mask_widget.dart` - Constructors and fields
- `lib/src/widgets/engine_stateful_widget.dart` - Class, constructors, getters and methods
- `lib/src/widgets/engine_stateless_widget.dart` - Constructor
- `lib/src/widgets/engine_widget.dart` - Constructor

### Quality Metrics
- **Lint Status**: ✅ 0 issues found (`dart analyze`)
- **Documentation Coverage**: ✅ 100% of public API members
- **Code Standards**: ✅ Follows project documentation standards
- **Breaking Changes**: ❌ None - only documentation additions

## 🚀 Benefits

1. **Better Developer Experience**: Complete API documentation for all public members
2. **Lint Compliance**: Full compliance with `public_member_api_docs` rule
3. **Code Quality**: Improved code maintainability and readability
4. **Future-Proof**: Resolved deprecation warnings for upcoming versions

## 📦 Installation

```yaml
dependencies:
  engine_tracking: ^1.5.1
```

## 🔄 Migration

No migration required - this is a documentation-only release with no breaking changes.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed information about this release.

---

**Engine Tracking** - Complete Flutter tracking, analytics, and bug reporting library with support for Firebase, Microsoft Clarity, Grafana Faro, Splunk, and Google Cloud Logging.