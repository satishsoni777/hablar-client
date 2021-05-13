import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/components/app_textfield.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AgoraVoiceManager agoraVoiceManager;
  final TextEditingController _userName = new TextEditingController();
  final TextEditingController _channelName = new TextEditingController();
  @override
  initState() {
    agoraVoiceManager = AgoraVoiceManager();
    // agoraVoiceManager.initPlatformState();
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

  Widget _join() {
    return Column(
      children: [
        AppTxtFld(
          controller: _userName,
        ),
        AppTxtFld(
          controller: _channelName,
        ),
        AppButton(
          onPressed: () async {
           await  agoraVoiceManager.initPlatformState();
          },
          text: "Connect",
        ),
        AppButton(
            onPressed: () async {
              agoraVoiceManager.dispose();
            },
            shapeBorder: CircleBorder(),
            text: "Disconect",
            height: 100.0)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _body(),
            _agora(),
            _join(),
          ],
        ),
      ),
    );
  }
}
