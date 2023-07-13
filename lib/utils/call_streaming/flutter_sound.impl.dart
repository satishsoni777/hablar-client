import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/flutter_sound.dart' as a;
import 'package:mic_stream/mic_stream.dart';
// import 'package:mic_stream/mic_stream.dart';
// import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

const int tSampleRate = 44000;

class FlutterSoundRecord extends RtcUtil {
  FlutterSoundPlayer? _flutterSoundPlayer;
  late FlutterSoundRecorder flutterSoundRecorder;
  // ignore: close_sinks
  final recordingDataController = StreamController<Food>();
  @override
  void call() async {
    flutterSoundRecorder = FlutterSoundRecorder();
    final hasPer = await Permission.microphone.status;
    if (!hasPer.isGranted) {
      final a = await Permission.microphone.request();
      if (!a.isGranted) return;
    }
    // await flutterSoundRecorder.closeRecorder();
    // await flutterSoundRecorder.openRecorder();
    await flutterSoundRecorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
      bitRate: 16000,
    );
    recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        DI.inject<AppWebSocket>().sendMessage({"message": buffer.data});
      }
    });
    _flutterSoundPlayer?.startPlayerFromStream();
  }

  @override
  void disconnect() {
    flutterSoundRecorder.startRecorder();
  }

  @override
  void dispose() {
    flutterSoundRecorder.startRecorder();
    flutterSoundRecorder.dispositionStream();
  }

  @override
  void init() {
    // TODO: implement init
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

  @override
  void play(List<int> data) async {
    
  }
}
