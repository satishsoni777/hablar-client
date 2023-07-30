import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/modules/signin/service/authentication.dart';
import 'package:take_it_easy/modules/calling/service/calling_service.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_repo.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/utils/call_streaming/mic_stream.dart';
import 'package:take_it_easy/websocket/socket-io.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class DI {
  DI();

  factory DI.initializeDependencies() {
    _addDependency<SharedStorage>(SharedStorageImpl(), true);
    _addDependency<LandingRepo>(LandingRepoImpl(), true);
    _addDependency<AppWebSocket>(SocketIO(), true);
    _addDependency<RtcUtil>(MicStreams(), true);
    _addDependency<CallingApi>(CallingService(), true);
    _addDependency<Authentication>(AuthenticationImpl(), true);
    _addDependency<UserData>(UserData(), true);
    return DI();
  }

  static _addDependency<T>(T object, bool isSingleton) {
    Injector().map<T>((injector) => object, isSingleton: isSingleton);
  }

  static addStringDependency(String value, String key) {
    Injector().map<String>((injector) => value, key: key);
  }

  static addDependencyForKey<T>(T object, bool isSingleton, String key) {
    Injector().map<T>((injector) => object, isSingleton: isSingleton, key: key);
  }

  static T inject<T>() {
    return Injector().get<T>();
  }

  static T injectWithKey<T>(String key) {
    return Injector().get<T>(key: key);
  }

  static T injectWithAdditionalParams<T>(String key, Map<String, dynamic> additionalParameters) {
    return Injector().get<T>(key: key, additionalParameters: additionalParameters);
  }
}

class DIKey {
  // DI Keys go here
}
