import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPref {
  static SharedPreferences? sharedPreferences;
  Future<SharedPreferences> get getPref async {
    sharedPreferences =
        (await SharedPreferences.getInstance()) ?? sharedPreferences;
    return sharedPreferences!;
  }

  Future<bool> setString(String key, String value) async {
    return await sharedPreferences!.setString(key, value);
  }

  Future<dynamic> getString(String key) async {
    return sharedPreferences!.getString(key);
  }
}

class SharedPrefImpl extends SharedPref {
  factory SharedPrefImpl._() {
    return SharedPrefImpl._();
  }

  static SharedPrefImpl instance = SharedPrefImpl._();
  static SharedPreferences ?sharedPreferences;

  Future<SharedPreferences> get getPref async {
    return super.getPref;
  }

  Future<dynamic> getJsonObject(String key) async {
    final result = await this.getString(key);
    jsonDecode(result);
  }

  Future<bool> setString(String key, String value) async {
    return super.setString(key, jsonEncode(value));
  }
}

class SharPrefKeys {
  static const String rtcToken = "rtc_token";
}
