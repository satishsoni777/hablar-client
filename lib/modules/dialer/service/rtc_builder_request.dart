
import 'package:flutter/material.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/storage/db/shared_pref.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class RtcBuilder {
  Future getRtcToken();
  Future<bool> reGenerateRtcToken();
}

class RtcBuilderRequest extends HttpManager implements RtcBuilder {
  RtcBuilderRequest();
  @override
  Future getRtcToken() async {
    try {
      var token = await SharedPrefImpl.instance.getString(
        SharPrefKeys.rtcToken,
      );
      token = AgoraConfig.tempToken;
      if (token != null || token != '') return token;
      final res = await this.sendRequest(HttpMethod.POST,
          endPoint: Endpoints.rtcToken,
          request: {"channelName": AgoraConfig.channelName});
      debugPrint("RtcBuilderRequest getRtcToken${res.data} ");
      if (res.isSuccesFull()) {
        await SharedPrefImpl.instance
            .setString(SharPrefKeys.rtcToken, res.data["rtcToken"]);
        return res.data["rtcToken"];
      } else
        throw res;
    } catch (_) {
      throw _;
    }
  }

  Future<bool> reGenerateRtcToken() async {
    return SharedPrefImpl.instance.setString(SharPrefKeys.rtcToken, '');
  }
}
