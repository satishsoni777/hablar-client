import 'package:flutter/material.dart';
import 'package:take_it_easy/modules/home/service/home_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({this.homeService});
  final HomeService? homeService;
  bool isOffline = false;
  Future<dynamic> toggleOffOn(bool offline) async {
    try {
      final res = await homeService?.toggleOffOn(offline);
    } catch (_) {}
  }
}
