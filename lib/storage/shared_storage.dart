import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/utils/string_utils.dart';

abstract class SharedStorage {
  static SharedPreferences? sharedPreferences;

  Future<SharedPreferences> get _getPreferences async {
    if (sharedPreferences == null)
      return sharedPreferences = await SharedPreferences.getInstance();
    else
      return sharedPreferences!;
  }

  getObjectPreference(String key) async {
    final SharedPreferences preferences = await _getPreferences;
    final String? jsonString = preferences.getString(key);
    if (isNullOrEmpty(jsonString)) {
      return null;
    }
    return jsonDecode(jsonString ?? '');
  }

  Future<bool> setObjectPreference(String key, var object) async {
    final SharedPreferences preferences = await _getPreferences;
    return await preferences.setString(key, jsonEncode(object));
  }

  Future<bool> setStringPreference(String key, String value) async {
    final SharedPreferences preferences = await _getPreferences;
    return await preferences.setString(key, value);
  }

  Future<String?> getStringPreference(String? key) async {
    return (await _getPreferences).getString(key!);
  }

  setUserData(dynamic customerData);

  Future<void> setToken(String token);

  Future<bool> setNewUser(String value);

  Future<String?> getToken();

  Future<bool> isSignIn();

  Future<bool?> isNewUser();

  Future<UserData> getUserData();

  setInitialRoute({String route});

  Future<String> getInitialRoute();

  Future<void> logout() async {
    (await sharedPreferences)?.clear();
  }

  // Remove aall store key from shared preferences
  Future<bool> resetFlow() async {
    bool isClear = false;
    for (final String key in sharedPreferences!.getKeys()) {
      isClear = await sharedPreferences!.remove(key);
    }
    return isClear;
  }
}

class SharedStorageImpl extends SharedStorage {
  @override
  setUserData(dynamic user) async {
    final bool result = await setObjectPreference(StorageKey.gmailUserDataKey, user);
    return result;
  }

  @override
  Future<UserData> getUserData() async {
    try {
      final dynamic json = (await getObjectPreference(StorageKey.gmailUserDataKey));
      final UserData data = UserData.fromJson((json as Map<String, dynamic>));
      return data;
    } catch (_) {
      throw _;
    }
  }

  @override
  setInitialRoute({String? route}) async {
    await setStringPreference(StorageKey.route, route!);
  }

  @override
  Future<String> getInitialRoute() async {
    return await getStringPreference(StorageKey.route) ?? '';
  }

  Future<dynamic> getJsonObject(String key) async {
    final String? result = await this.getStringPreference(key);
    return jsonDecode(result ?? '');
  }

  @override
  Future<void> setToken(String token) async {
    await setStringPreference(StorageKey.token, token);
  }

  @override
  Future<String?> getToken() async {
    return getStringPreference(StorageKey.token);
  }

  @override
  Future<bool> setNewUser(String value) async {
    return await setStringPreference(StorageKey.isNewUser, value);
  }

  @override
  Future<bool?> isNewUser() async {
    return (await getStringPreference(StorageKey.isNewUser)) == "true" ? true : false;
  }

  @override
  Future<bool> isSignIn() async {
    final String? token = await getStringPreference(StorageKey.token);
    return !isNullOrEmpty(token);
  }
}

// Define All storage keys here.
class StorageKey {
  StorageKey._();
  static final String gmailUserDataKey = 'gmail_auth_user_data';
  static final String route = 'route';
  static final String userId = "userId";
  static const String rtcToken = "rtc_token";
  static const String roomId = "roomId";
  static const String token = "token";
  static const String online = "online";
  static const String isNewUser = "is_new_user";
}
