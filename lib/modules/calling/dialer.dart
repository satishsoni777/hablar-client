// ignore_for_file: always_specify_types
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/calling/controller/signaling_controller.dart';
import 'package:take_it_easy/modules/calling/widgets/agora/agora_call.dart';
import 'package:take_it_easy/modules/calling/widgets/agora/end_call_dialog.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/rtc/agora_rtc/agora_manager.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_signaling.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

import 'package:take_it_easy/modules/calling/widgets/voice_call.dart';

import 'widgets/video_call.dart';

class Dialer extends StatefulWidget {
  const Dialer({
    Key? key,
    required this.signaling,
    required this.appWebSocket,
  }) : super(key: key);
  final SignalingI signaling;
  final AppWebSocket appWebSocket;
  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  late final SignalingController _callingController;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _callingController = SignalingController(widget.signaling,
        widget.appWebSocket, DI.inject<UserData>().userId ?? 0);
    init();
    super.initState();
  }

  void init() {
    _callingController.init();
    _callingController.submitFeedback = (d) {};
  }

  void _showDialog() async {
    bool? result =
        await NavigationManager.instance.launchDialog(widget: EndCallDialog());
    if (result ?? false) {
      _callingController.close();
    }
  }

  @override
  void dispose() {
    // _callingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _showDialog();
        // _callingController.close();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider<SignalingController>.value(
                value: _callingController,
              )
            ],
            builder: (BuildContext context, Widget? snapshot) {
              return Consumer<SignalingController>(builder:
                  (BuildContext context, SignalingController prodider,
                      Widget? a) {
                if (prodider.signaling is AgoraManager) {
                  return AgoraCall();
                }
                else return Container();
                // return Stack(
                //   children: [
                //     if (prodider.signaling.callType == CallType.Video)
                //       VideoCall(
                //         localRenderer: (prodider.signaling as WebrtcSignaling)
                //             .localRenderer,
                //         remoteRenderer: (prodider.signaling as WebrtcSignaling)
                //             .remoteRenderer,
                //       ),
                //     VoiceCall(),
                //   ],
                // );
              });
            }),
      ),
    );
  }
}
