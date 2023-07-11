import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
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
      var token = await DI.inject<SharedStorage>().getStringPreference(
            StorageKey.rtcToken,
          );
      token = AgoraConfig.tempToken;
      if (token != null || token != '') return token;
      final res = await this.sendRequest(HttpMethod.POST, endPoint: Endpoints.rtcToken, request: {"channelName": AgoraConfig.channelName});
      if (res.isSuccesFull()) {
        await await DI.inject<SharedStorage>().setStringPreference(StorageKey.rtcToken, "");
        return "";
      } else
        throw res;
    } catch (_) {
      throw _;
    }
  }

  Future<bool> reGenerateRtcToken() async {
    return await DI.inject<SharedStorage>().setStringPreference(StorageKey.rtcToken, '');
  }
}
