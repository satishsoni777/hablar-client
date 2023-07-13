import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';

class WebrtcUtil extends RtcUtil{
  late WebRTC webRTC;
  
  @override
  void init() {
   webRTC=WebRTC();
  }
  @override
  void call() {
    // TODO: implement call
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }


  @override
  void mute() {
    // TODO: implement mute
  }

  @override
  void pause() {
    // TODO: implement pause
  }

  @override
  void play(List<int> data) {
    // TODO: implement play
  }

  @override
  void reconnect() {
    // TODO: implement reconnect
  }

  @override
  void resume() {
    // TODO: implement resume
  }

  @override
  void sendData() {
    // TODO: implement sendData
  }

  @override
  void stop() {
    // TODO: implement stop
  }

}