import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AgoraVoiceManager agoraVoiceManager;
  @override
  initState() {
    agoraVoiceManager = AgoraVoiceManager();
    agoraVoiceManager.initPlatformState();
    super.initState();
  }

  @override
  dispose() {
    agoraVoiceManager?.dispose();
    super.dispose();
  }

  Widget _body() {
    return TextButton(onPressed: () {}, child: Text("Voice Calls"));
  }

  Widget _agora() {
    return TextButton(
        onPressed: () {
          agoraVoiceManager.dispose();
        },
        child: Text("Agora Calls"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_body(), _agora()],
        ),
      ),
    );
  }
}
