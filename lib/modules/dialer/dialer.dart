import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_wrapper/rtc_manager.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  late RtcInterface rtcInterface;
  @override
  void initState() {
    rtcInterface = WebRtcManager();
    (rtcInterface as WebRtcManager).makeMicCall(
        context,
        UserConnectionData(
          audio: true,
          userId: "2345",
          name: "asdf",
          username: "aSDFG",
        ));
    // rtcInterface = AgoraManager();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    rtcInterface.disconnect();
    super.dispose();
  }

  void _init() async {
    await rtcInterface.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<WebRtcManager>.value(
          value: rtcInterface as WebRtcManager,
          builder: (context, snapshot) {
            return Consumer<WebRtcManager>(builder: (context, snapshot, a) {
              return RTCVideoView(
                (rtcInterface as WebRtcManager).rtcVideoRenderer!,
                mirror: false,
                filterQuality: FilterQuality.medium,
                placeholderBuilder: (c) => SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )),
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
