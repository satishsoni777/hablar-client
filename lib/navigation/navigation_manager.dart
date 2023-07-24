import 'package:flutter/widgets.dart';

class NavigationManager {
  NavigationManager._();
  static NavigationManager instance = NavigationManager._();
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  final RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<void> pop([dynamic arguments]) async {
    _navigationKey.currentState!.pop(arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}
