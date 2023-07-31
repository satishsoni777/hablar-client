import 'package:flutter/material.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/modules/home/service/home_service.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class HomeController extends ChangeNotifier {
  HomeController({this.homeService, this.sharedStorage});
  final HomeService? homeService;
  final SharedStorage? sharedStorage;
  bool isOffline = false;
  int _level = 0;
  String _genger = "";
  String get gedner => _genger;
  int get selectedLevel => _level;
  Future<dynamic> toggleOffOn(bool offline) async {
    try {
      AppLoader.showLoader();
      isOffline = offline;
      final dynamic res = await homeService?.toggleOnline(offline);
      print(res);
      await sharedStorage?.setStringPreference(StorageKey.online, offline.toString());
      AppLoader.hideLoader();
      notifyListeners();
    } catch (_) {
      print(_);
    }
  }

  void selectLevel(int level) {
    this._level = level;
    notifyListeners();
  }

  void selectGender(String value) {
    this._genger = value;
    notifyListeners();
  }
}
