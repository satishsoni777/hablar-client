// ignore_for_file: always_specify_types
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/calling/controller/calling_controller.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

import 'package:take_it_easy/modules/calling/widgets/voice_call.dart';

import 'widgets/video_call.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);
  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  late final Signaling signaling;
  late final CallingController _callingController;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  final AppWebSocket appWebSocket = DI.inject<AppWebSocket>();
  bool joinReqsent = false;

  @override
  void initState() {
    signaling = Signaling();
    _callingController = CallingController(signaling, appWebSocket);
    appWebSocket.userLeft = (dynamic data) {
      _callingController.callEnd(signaling);
    };
    super.initState();
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  void init() async {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    appWebSocket.onConnected = (dynamic a) async {
      await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      _callingController.joinRandomCall(signaling);
      joinReqsent = true;
    };
    if (appWebSocket.isConnected && !joinReqsent) {
      await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      _callingController.joinRandomCall(signaling);
    }
    signaling.onAddRemoteStream = ((MediaStream stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
  }

  @override
  void dispose() {
    appWebSocket.leaveRoom(<String, dynamic>{"roomId": signaling.roomId});
    super.dispose();
  }

  Future<bool> _handUp() async {
    AppLoader.showLoader();
    try {
      await _callingController.callEnd(signaling);
    } catch (_) {}
    AppLoader.hideLoader();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(_handUp());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider<Signaling>.value(value: signaling),
              ChangeNotifierProvider<CallingController>.value(value: _callingController)
            ],
            builder: (BuildContext context, Widget? snapshot) {
              return Consumer<Signaling>(builder: (BuildContext context, Signaling prodider, Widget? a) {
                return Stack(
                  children: [
                    if (prodider.callType == CallType.Video)
                      VideoCall(
                        localRenderer: _localRenderer,
                        remoteRenderer: _remoteRenderer,
                      ),
                    VoiceCall(),
                  ],
                );
              });
            }),
      ),
    );
  }
}
