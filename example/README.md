# Engine Tracking Example

A comprehensive example demonstrating the `engine_tracking` package features.

## Features Demonstrated

This example app showcases:

- **Analytics Integration**: Event tracking, user properties, and page views
- **Bug Tracking**: Error recording, logging, and crash reporting
- **Service Status**: Real-time display of enabled/disabled services
- **User Interaction**: Counter, navigation, and property updates
- **Error Simulation**: Test error recording functionality

## Getting Started

1. **Clone the repository**
2. **Navigate to the example directory**
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Configure Firebase** (optional):
   - Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)
   - Update Firebase project configuration

5. **Configure Faro** (optional):
   - Update the Faro endpoint and API key in `main.dart`

6. **Run the app:**
   ```bash
   flutter run
   ```

## Configuration

The example initializes both Analytics and Bug Tracking with sample configurations:

```dart
// Configure Analytics
final analyticsModel = EngineAnalyticsModel(
  firebaseAnalyticsConfig: const EngineFirebaseAnalyticsConfig(enabled: true),
  faroConfig: const EngineFaroConfig(
    enabled: true,
    endpoint: 'https://faro-collector.example.com/collect',
    appName: 'EngineTrackingExample',
    appVersion: '1.0.0',
    environment: 'development',
    apiKey: 'your-faro-api-key',
  ),
);
```

## What You Can Test

1. **Increment Counter**: Logs analytics events and user interactions
2. **Simulate Error**: Tests error recording and stack trace logging
3. **Set User Property**: Updates user properties in both services
4. **Navigate**: Demonstrates page tracking and navigation events
5. **Service Status**: View real-time status of all tracking services

## Notes

- Firebase services require proper configuration to work
- Faro integration needs valid endpoint and API key
- The app will still function with services disabled
- Check the console for logged events and errors 