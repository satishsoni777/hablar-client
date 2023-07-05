import 'package:flutter/material.dart';
import 'package:take_it_easy/resources/app_keys.dart';

class AppAlert {
  AppAlert._();
  static bool _hasLoader = false;
  static AppAlert _instance = AppAlert._();
  static BuildContext? _context;
  factory AppAlert.of({BuildContext? context}) {
    _context = context ?? navigatorKey.currentContext;
    return _instance;
  }
  static Future<dynamic> dialog({Widget? child, BuildContext? context}) async {
    print(child);
    _context = context ?? navigatorKey.currentContext;
    if (_hasLoader) return;
    _hasLoader = true;
    await showDialog(
        context: _context!,
        barrierDismissible: false,
        builder: (c) {
          return child ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(child: CircularProgressIndicator(), height: 40.0, width: 40.0),
                ],
              );
        });
  }

  static popDialog() async {
    if (_hasLoader) {
      _hasLoader = false;
      Navigator.pop(_context!);
    }
  }
}

class DialogHelper {
  static Future<dynamic> showCommonDialog({
    Widget? child,
  }) async {
    final BuildContext context = navigatorKey.currentContext!;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return child ?? Container();
      },
    );
  }
}
