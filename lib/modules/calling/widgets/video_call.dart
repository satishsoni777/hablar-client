import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/calling/controller/calling_controller.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<VideoCall> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Signaling signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  final AppWebSocket appWebSocket = DI.inject<AppWebSocket>();
  bool joinReqsent = false;
  late CallingController _callingController;

  @override
  void didChangeDependencies() {
    _callingController = Provider.of<CallingController>(context, listen: true);
    signaling = Provider.of<Signaling>(context, listen: true);
    init();
    super.didChangeDependencies();
  }

  void init() async {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    DI.inject<AppWebSocket>().onConnected = (dynamic a) async {
      await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      _callingController.joinRandomCall(signaling);
      joinReqsent = true;
    };
    if (DI.inject<AppWebSocket>().isConnected && !joinReqsent) {
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
    signaling.hangUp(_localRenderer);
    signaling.stop();
    appWebSocket.leaveRoom(<String, dynamic>{"roomId": signaling.roomId});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Signaling>(builder: (BuildContext context, Signaling pr, a) {
      if (pr.callType != CallType.Video) return Container();
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: AspectRatio(
              aspectRatio: .54,
              child: RotatedBox(
                quarterTurns: 0,
                child: RTCVideoView(
                  _remoteRenderer,
                  mirror: true,
                  filterQuality: FilterQuality.low,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 180,
                width: 120,
                child: RotatedBox(
                  quarterTurns: 0,
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                    filterQuality: FilterQuality.low,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
