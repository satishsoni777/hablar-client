import 'package:flutter/material.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/enums/socket-io-events.dart';
import 'package:take_it_easy/modules/history_page/call_history.dart';
import 'package:take_it_easy/modules/home/initiate_call_page.dart';
import 'package:take_it_easy/modules/profile/profile.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTabs homeTabs = HomeTabs.Call;
  AppWebSocket? appWebSocket;
  RtcUtil? callStreaming;

  @override
  initState() {
    appWebSocket = DI.inject<AppWebSocket>();
    appWebSocket?.connect();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    appWebSocket?.close();
    callStreaming?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <HomeTabs, Widget>{HomeTabs.Call: InitiateCall(), HomeTabs.Profile: UserProfile()};
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          appWebSocket?.sendMessage({"userId": "2222", "countryCode": "IN", "stateCode": "KR", "type": "join-random-call"},
              meetingPayloadEnum: MeetingPayloadEnum.JOIN_RANDOM_CALL);
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeTabs.index,
          onTap: (value) {
            homeTabs = HomeTabs.values[value];
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
        body: tabs[homeTabs]);
  }
}

enum HomeTabs { Call, Profile }
