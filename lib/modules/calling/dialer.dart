// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/calling/controller/calling_controller.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/modules/calling/widgets/voice_call.dart';
import 'package:take_it_easy/modules/video_call/video_call.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  final AppWebSocket appWebSocket = DI.inject<AppWebSocket>();
  bool joinReqsent = false;
  @override
  void initState() {
    // init();
    super.initState();
  }

  void init() async {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    DI.inject<AppWebSocket>().onConnected = (a) async {
      await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      signaling.joinRandomCall();
      joinReqsent = true;
    };
    if (DI.inject<AppWebSocket>().isConnected && !joinReqsent) {
      await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      signaling.joinRandomCall();
    }
    signaling.onAddRemoteStream = ((MediaStream stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
  }

  @override
  void dispose() {
    signaling.hangUp(_localRenderer);
    signaling.stop();
    appWebSocket.leaveRoom({"roomId": signaling.roomId});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider<CallingController>.value(value: CallingController()),
            ChangeNotifierProvider<Signaling>.value(value: Signaling())
          ],
          builder: (BuildContext context, Widget? snapshot) {
            return Consumer<Signaling>(builder: (BuildContext context, Signaling snapshot, Widget? a) {
              return snapshot.callType == CallType.Audio ? VoiceCall() : VideoCall();
            });
          }),
    );
  }
}
