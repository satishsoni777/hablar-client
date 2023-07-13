import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

class MicStreams extends RtcUtil {
  Random rng = new Random();
  Stream<Uint8List>? stream;
  StreamSubscription<Uint8List>? listener;
  FlutterSoundPlayer? _flutterSoundPlayer;
  @override
  void call() async {
    final hasPer = await MicStream.permissionStatus;
    if (!hasPer) {
      final a = await Permission.microphone.request();
      if (!a.isGranted) return;
    }
    stream = (await MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 1000 * (rng.nextInt(50) + 30),
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT));
    listener = stream?.listen((event) {
      DI.inject<AppWebSocket>().sendMessage({"voiceMessageFromClient": event});
    });
  }

  @override
  void reconnect() {
    // TODO: implement reconnect
  }

  @override
  void resume() {}

  @override
  void sendData() {
    // TODO: implement sendData
  }

  @override
  void stop() {
    // Cancel the subscription
    listener?.cancel();
  }

  @override
  void disconnect() {
    listener?.cancel();
  }

  @override
  void dispose() {
    listener?.cancel();
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
  void pause() async {}

  @override
  void play(List<int> data) async {
    _flutterSoundPlayer = FlutterSoundPlayer(
      voiceProcessing: true,
    );
    await _flutterSoundPlayer?.closePlayer();
    await _flutterSoundPlayer?.openPlayer(enableVoiceProcessing: true);
    final buffer = Uint8List.fromList(data);
    try {
      await _flutterSoundPlayer?.openPlayer(enableVoiceProcessing: true);
      final a = await _flutterSoundPlayer?.startPlayer(fromDataBuffer: buffer);
      //  await _flutterSoundPlayer?.closePlayer();
    } catch (_) {
      print(_);
    }
  }
}
