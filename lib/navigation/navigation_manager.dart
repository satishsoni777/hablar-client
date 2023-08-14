import 'package:flutter/material.dart';

class NavigationManager {
  NavigationManager._();
  static NavigationManager instance = NavigationManager._();
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  final RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return Navigator.of(_navigationKey.currentContext!).pushNamed(routeName, arguments: arguments);
  }

  Future<void> pop([dynamic arguments]) async {
    return Navigator.of(navigationKey.currentContext!).pop(arguments);
  }

  pushReplacementNamed(String routeName, {BuildContext? context, dynamic arguments}) {
    if (context != null) {
      Navigator.popAndPushNamed(context, routeName);
    } else
      try {
        return Navigator.of(navigationKey.currentContext!).pushReplacementNamed(routeName, arguments: arguments);
      } catch (e) {
        print(e);
      }
  }
  
   Future<dynamic> launchDialog({
    required Widget widget,
    bool barrierDismissible = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog(
      context: _navigationKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => widget,
      useSafeArea: false,
      routeSettings: routeSettings,
    );
  }

}
