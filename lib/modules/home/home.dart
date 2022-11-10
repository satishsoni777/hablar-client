import 'package:flutter/material.dart';
import 'package:take_it_easy/modules/history_page/call_history.dart';
import 'package:take_it_easy/modules/home/initiate_call_page.dart';
import 'package:take_it_easy/modules/profile/profile.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';

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
  @override
  initState() {
    // agoraVoiceManager = AgoraVoiceManager();
    // agoraVoiceManager.initPlatformState();
    super.initState();
  }

  @override
  dispose() {
    // agoraVoiceManager?.dispose();
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeTabs.index,
          onTap: (value) {
            homeTabs = HomeTabs.values[value];
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
        body: tabs[homeTabs]);
  }
}

enum HomeTabs { Call, History, Profile }
