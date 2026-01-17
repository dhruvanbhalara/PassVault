import 'package:flutter/widgets.dart';
import 'package:passvault/core/utils/app_logger.dart';

/// Custom GoRouter observer for logging navigation events.
///
/// This observer tracks all navigation events in the application:
/// - didPush: When a new route is pushed onto the stack
/// - didPop: When a route is popped from the stack
/// - didRemove: When a route is removed from the stack
/// - didReplace: When a route is replaced with another route
///
/// All navigation events are logged using [AppLogger] for consistent
/// logging across the application.
class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.debug(
      'Pushed: ${route.settings.name ?? route.toString()}',
      tag: 'Navigation',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.debug(
      'Popped: ${route.settings.name ?? route.toString()}',
      tag: 'Navigation',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.debug(
      'Removed: ${route.settings.name ?? route.toString()}',
      tag: 'Navigation',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.debug(
      'Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
      tag: 'Navigation',
    );
  }
}
