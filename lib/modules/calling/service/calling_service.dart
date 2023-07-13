import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/model/random_rooms.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/utils/utils.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class CallingApi {
  Future<dynamic> createRoom();
  Future<RoomsResponse> joinRandomRoom();
  Future<dynamic> startMeeting();
  Future<dynamic> leaveRoom();
}

class CallingService extends HttpManager implements CallingApi {
  Future<Response> startMeeting() async {
    final userId = await Utils.userId();
    final body = {"hostId": userId, "hostName": ""};
    final response = await sendRequest(HttpMethod.POST, endPoint: Endpoints.startMeeting, request: body);
    if (response.isSuccesFull()) {
      return response;
    } else
      throw response;
  }

  Future<RoomsResponse> joinRandomRoom() async {
    final userId = await Utils.userId();
    final Map<String, dynamic> req = {"userId": userId, "countryCode": "IN", "stateCode": "KR"};
    RoomsResponse? res;
    try {
      final response = await sendRequest(HttpMethod.POST, endPoint: Endpoints.joinRandomRoom, request: req);
      if (response.isSuccesFull()) {
        res = RoomsResponse.fromJson(jsonDecode(response.data));
        await DI.inject<SharedStorage>().setStringPreference(StorageKey.roomId, res.data?.roomId ?? '');
      }
    } on DioError catch (e) {
      throw e;
    }
    return res!;
  }

  Future<dynamic> leaveRoom() async {
    final userId = await Utils.userId();
    final roomId = await DI.inject<SharedStorage>().getStringPreference(StorageKey.roomId);
    var response;
    final req = {"userId": userId};
    final query = {"roomId": roomId};
    try {
      response = await sendRequest(HttpMethod.POST, endPoint: Endpoints.leaveRoom, queryParameters: query, request: req);
    } on DioError catch (_) {
      throw _;
    }
    return response;
  }

  @override
  Future createRoom() {
    // TODO: implement createRoom
    throw UnimplementedError();
  }
}
