import 'package:dio/dio.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/utils/utils.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

class MeetingService extends HttpManager {
  Future<Response> startMeeting() async {
    final userId = await Utils.userId();
    final body = {
      "hostId": userId,
      "hostName": ""
    };
    final response = await sendRequest(HttpMethod.POST, endPoint: Endpoints.startMeeting, request: body);
    if (response.isSuccesFull()) {
      return response;
    } else
      throw response;
  }

  Future<Response> joinMeeting(String meetingId) async {
    final userId = await Utils.userId();
    final body = {
      "hostId": userId,
      "hostName": ""
    };
    final response = await sendRequest(HttpMethod.GET, endPoint: Endpoints.join, queryParameters: {
      "meetingId": meetingId
    });
    if (response.isSuccesFull()) {
      return response;
    } else
      throw response;
  }
}
