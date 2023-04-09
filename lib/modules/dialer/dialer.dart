import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/dialer/service/meeting_api_impl.dart';
import 'package:take_it_easy/rtc/webrtc/signaling.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_wrapper/rtc_manager.dart';

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

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  final MeetingApi meetingApi = DI.inject<MeetingApi>();
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
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  RTCVideoView(
                    _remoteRenderer,
                    mirror: false,
                    filterQuality: FilterQuality.low,
                    // placeholderBuilder: (c) => SizedBox(
                    //     height: 60,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         CircularProgressIndicator(),
                    //       ],
                    //     )),
                  ),
                  Positioned(
                      child: SizedBox(
                    height: 200,
                    width: 100,
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: false,
                    ),
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Create Room"),
                        onPressed: () {
                          signaling.createRoom(_remoteRenderer);
                        },
                      ),
                      TextButton(
                        child: Text("Join"),
                        onPressed: () {
                          signaling.joinRoom("J2Z2zLBC5N5Pa2xTnHsB", _remoteRenderer);
                        },
                      )
                    ],
                  )
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
