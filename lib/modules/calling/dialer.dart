// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/home/widget/off_line_toggle.dart';
import 'package:take_it_easy/modules/calling/controller/calling_controller.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/modules/calling/widgets/voice_call.dart';

import 'widgets/video_call.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: OfflineToggle(),
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider<CallingController>.value(value: CallingController()),
            ChangeNotifierProvider<Signaling>.value(value: Signaling())
          ],
          builder: (BuildContext context, Widget? snapshot) {
            return Consumer<Signaling>(builder: (BuildContext context, Signaling prodider, Widget? a) {
              return Stack(
                children: [
                  VideoCall(),
                  // if (prodider.callType == CallType.Audio)
                  VoiceCall(),
                ],
              );
            });
          }),
    );
  }
}
