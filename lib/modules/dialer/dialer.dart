import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/dialer/service/meeting_api_impl.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/webrtc/signaling.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_wrapper/rtc_manager.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  late WebRtcManager rtcInterface;
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  @override
  void initState() {
    _init();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.createRoom(_remoteRenderer);
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    signaling.hangUp(_localRenderer);
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    rtcInterface.disconnect();
    meetingApi.leaveRoom();
    super.dispose();
  }

  void _init() async {
    await rtcInterface.initialize();
  }

  final MeetingApi meetingApi = DI.inject<MeetingApi>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final roomId = (await meetingApi.joinRandomRoom()).data?.roomId ?? "";
      }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<Signaling>.value(
          value: signaling,
          builder: (context, snapshot) {
            return Consumer<Signaling>(builder: (context, snapshot, a) {
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  RTCVideoView(
                    _remoteRenderer,
                    mirror: false,
                    filterQuality: FilterQuality.low,
                    placeholderBuilder: (c) => SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        )),
                  ),
                  Positioned(
                      child: SizedBox(
                    height: 200,
                    width: 100,
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: false,
                    ),
                  ))
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
