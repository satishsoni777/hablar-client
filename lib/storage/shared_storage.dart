import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_it_easy/modules/authentication/model/gmail_user_data.dart';
import 'package:take_it_easy/utils/string_utils.dart';

abstract class SharedStorage {
  static SharedPreferences sharedPreferences;

  Future<SharedPreferences> get _getPreferences async {
    if (sharedPreferences == null)
      return sharedPreferences = await SharedPreferences.getInstance();
    else
      return sharedPreferences;
  }

  getObjectPreference(String key) async {
    final preferences = await _getPreferences;
    final jsonString = preferences.getString(key);
    if (isNullOrEmpty(jsonString)) {
      return null;
    }
    return jsonDecode(jsonString);
  }

  Future<bool> setObjectPreference(String key, var object) async {
    final preferences = await _getPreferences;
    return await preferences.setString(key, jsonEncode(object));
  }

  setStringPreference(String key, String value) async {
    final preferences = await _getPreferences;
    await preferences.setString(key, value);
  }

  getStringPreference({String key}) async {
    return (await _getPreferences).getString(key);
  }

  setUserData(User customerData);
  Future<GmailUserData> getUserData();
  setInitialRoute({String route});
  Future<String> getInitialRoute();
}

class SharedStorageImpl extends SharedStorage {
  @override
  setUserData(User user) async {
    final data = {
      "displayName": user.displayName,
      "email": user.email,
      'photoURL': user.photoURL,
      'uid': user.uid,
      'phoneNumber': user.phoneNumber,
      'emailVerified': user.emailVerified,
      'tenantId': user.tenantId,
      'isAnonymous': user.isAnonymous,
    };
    await setObjectPreference(StorageKey.gmailUserDataKey, data);
  }

  @override
  Future<GmailUserData> getUserData() async {
    final json =
        (await getObjectPreference(StorageKey.gmailUserDataKey)) as Map;
    final data = GmailUserData.fromJson(json);
    return data;
  }

  @override
  setInitialRoute({String route}) async {
    await setStringPreference(StorageKey.route, route);
  }

  @override
  Future<String> getInitialRoute() async {
    return await getStringPreference(key: StorageKey.route);
  }
}

class StorageKey {
  static final gmailUserDataKey = 'gmail_auth_user_data';
  static final route = 'route';
}
