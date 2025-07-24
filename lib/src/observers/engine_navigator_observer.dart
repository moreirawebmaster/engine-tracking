import 'package:engine_tracking/src/src.dart';
import 'package:flutter/widgets.dart';

/// Navigator observer that automatically tracks page navigation for analytics
///
/// This class extends RouteObserver to automatically track page navigation
/// events and send them to the analytics system when routes are pushed,
/// popped, or replaced.
class EngineNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  /// Default route name used when no route name is available
  final String rootRouteName = 'root';
  @override
  Future<void> didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) async {
    super.didPop(route, previousRoute);
    await EngineAnalytics.setPage(previousRoute?.settings.name ?? rootRouteName, route.settings.name ?? rootRouteName);
  }

  @override
  Future<void> didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);
    await EngineAnalytics.setPage(route.settings.name ?? rootRouteName, previousRoute?.settings.name);
  }

  @override
  Future<void> didReplace({final Route<dynamic>? newRoute, final Route<dynamic>? oldRoute}) async {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    await EngineAnalytics.setPage(oldRoute?.settings.name ?? rootRouteName, newRoute?.settings.name ?? rootRouteName);
  }
}
