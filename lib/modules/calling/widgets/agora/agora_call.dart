import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/calling/controller/signaling_controller.dart';
import 'package:take_it_easy/modules/calling/widgets/voice_call.dart';
import 'package:take_it_easy/rtc/agora_rtc/agora_manager.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';

class AgoraCall extends StatefulWidget {
  const AgoraCall({super.key});

  @override
  State<AgoraCall> createState() => _AgoraCallState();
}

class _AgoraCallState extends State<AgoraCall>
    with SingleTickerProviderStateMixin {
  late SignalingController controller;
  @override
  void didChangeDependencies() {
    controller = Provider.of<SignalingController>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<SignalingController>(
          builder: (BuildContext context, SignalingController provider, a) {
        if ((provider.signaling as AgoraManager).rtcEngine == null ||
            provider.callStatus == CallStatus.None) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return VoiceCall();
        return AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: (provider.signaling as AgoraManager).rtcEngine!,
            canvas: VideoCanvas(),
          ),
        );
      }),
    );
  }
}
