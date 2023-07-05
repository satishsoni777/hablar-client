import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/dialer/service/meeting_api_impl.dart';
import 'package:take_it_easy/rtc/webrtc/signaling.dart';
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
    init();
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
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
  }

  @override
  void dispose() {
    signaling.hangUp(_localRenderer);
    signaling.stop();
    appWebSocket.leaveRoom({
      "roomId": signaling.roomId
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   final roomId = (await meetingApi.joinRandomRoom()).data?.roomId ?? "";
      // }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<Signaling>.value(
          value: signaling,
          builder: (context, snapshot) {
            return Consumer<Signaling>(builder: (context, snapshot, a) {
              return Column(
                // alignment: Alignment.bottomRight,
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .9,
                        width: MediaQuery.of(context).size.width * .9,
                        child: RTCVideoView(
                          _localRenderer,
                          mirror: true,
                          filterQuality: FilterQuality.low,
                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      height: 200,
                      width: 100,
                      child: RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                ],
              );
            });
          }),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Spacing.sizeBoxHt20,
      //       CircleAvatar(
      //         radius: 40,
      //         child: Icon(Icons.people),
      //       ),
      //       Spacing.sizeBoxHt20,
      //       Text('unknown'),
      //       Spacing.sizeBoxHt20,
      //       Text("Timer"),
      //       const Spacer(),
      //       AppButton(
      //         shapeBorder: CircleBorder(),
      //         child: Icon(Icons.call),
      //         borderRadius: 35,
      //         color: AppColors.lightRed,
      //         height: 70.0,
      //         width: 70,
      //         onPressed: () {},
      //       ),
      //       Spacing.sizeBoxHt40,
      //     ],
      //   ),
      // ),
    );
  }

  Widget _callActivity(BuildContext context) {
    return Card(
      child: Row(
        children: [],
      ),
    );
  }
}
