import 'package:flutter/material.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/history_page/call_history.dart';
import 'package:take_it_easy/modules/home/initiate_call_page.dart';
import 'package:take_it_easy/modules/profile/profile.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_wrapper/rtc_manager.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // AgoraVoiceManager agoraVoiceManager;
  final TextEditingController _userName = new TextEditingController();
  final TextEditingController _channelName = new TextEditingController();
  HomeTabs homeTabs = HomeTabs.Call;
  AppWebSocket? appWebSocket;
  RtcUtil? callStreaming;
  RtcInterface? _rtcInterface;

  @override
  initState() {
    _rtcInterface = WebRtcManager();
    callStreaming = DI.inject<RtcUtil>();
    appWebSocket = DI.inject<AppWebSocket>();
    // appWebSocket?.connect("ws://localhost:8082");
    // agoraVoiceManager = AgoraVoiceManager();
    // agoraVoiceManager.initPlatformState();
    super.initState();
  }

  @override
  dispose() {
    appWebSocket?.close();
    callStreaming?.disconnect();
    _rtcInterface?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <HomeTabs, Widget>{
      HomeTabs.Call: InitiateCall(),
      HomeTabs.History: CallHistory(),
      HomeTabs.Profile: UserProfile()
    };
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeTabs.index,
          onTap: (value) {
            homeTabs = HomeTabs.values[value];
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Recent Calls'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
        body: tabs[homeTabs]);
  }
}

enum HomeTabs {
  Call,
  History,
  Profile
}
