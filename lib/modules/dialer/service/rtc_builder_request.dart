import 'dart:convert';

import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/db/shared_pref.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class RtcBuilder {
  Future getRtcToken();
}

class RtcBuilderRequest extends HttpManager implements RtcBuilder {
  RtcBuilderRequest();
  @override
  Future getRtcToken() async {
    try {
      final token = await SharedPrefImpl.instance.getString(
        SharPrefKeys.rtcToken,
      );
      if (token != null) return token;
      final res = await this
          .sendRequest(HttpMethod.POST, endPoint: Endpoints.rtcToken, request: {
        "channelName": AgoraConfig.channelName,
      });
      if (res.isSuccesFull()) {
        // final body = jsonDecode(res.data);
        await SharedPrefImpl.instance
            .setString(SharPrefKeys.rtcToken, res.data["rtcToken"]);
        return res.data["rtcToken"];
      } else
        throw res;
    } catch (_) {
      print(_);
      throw _;
    }
  }
}
