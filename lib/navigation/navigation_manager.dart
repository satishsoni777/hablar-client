import 'package:flutter/widgets.dart';

class NavigationManager {
  NavigationManager._();

  static GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  final RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();
  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<void> pop([dynamic arguments]) async {
    _navigationKey.currentState!.pop(arguments);
  }

  static Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}
