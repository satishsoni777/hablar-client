import 'package:flutter/material.dart';

class AppAlert {
  AppAlert._();
  bool _hasLoader = false;
  static AppAlert _instance = AppAlert._();
  static BuildContext? _context;
  factory AppAlert.of(BuildContext context) {
    _context = context;
    return _instance;
  }
  Future<void> dialog({Widget? child}) async {
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
    if (_instance._hasLoader) {
      _instance._hasLoader = false;
      Navigator.pop(_context!);
    }
  }
}
