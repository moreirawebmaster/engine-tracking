import 'package:engine_tracking/src/src.dart';
import 'package:flutter/widgets.dart';

class EngineNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  Future<void> didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) async {
    super.didPop(route, previousRoute);
    await EngineAnalytics.setPage(
      previousRoute?.settings.name ?? '',
      route.settings.name ?? '',
    );
  }

  @override
  Future<void> didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);
    await EngineAnalytics.setPage(route.settings.name ?? '', previousRoute?.settings.name ?? '');
  }

  @override
  Future<void> didReplace({final Route<dynamic>? newRoute, final Route<dynamic>? oldRoute}) async {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    await EngineAnalytics.setPage(
      oldRoute?.settings.name ?? '',
      newRoute?.settings.name ?? '',
    );
  }
}
