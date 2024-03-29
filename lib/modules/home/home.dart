import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/enums/socket-io-events.dart';
import 'package:take_it_easy/modules/home/controller/home_controller.dart';
import 'package:take_it_easy/modules/home/calling.dart';
import 'package:take_it_easy/modules/home/service/home_service.dart';
import 'package:take_it_easy/modules/profile/profile.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTabs homeTabs = HomeTabs.Call;
  AppWebSocket? appWebSocket;
  RtcUtil? callStreaming;
  late HomeController homeController;
  @override
  initState() {
    homeController = HomeController(homeService: HomeServiceImp(), sharedStorage: DI.inject<SharedStorage>());
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

  Widget _getTab(HomeTabs homeTabs) {
    switch (homeTabs) {
      case HomeTabs.Call:
        return Calling();
      case HomeTabs.Profile:
        return UserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          appWebSocket?.sendMessage(<String, dynamic>{
            "userId": "2222",
            "countryCode": "IN",
            "stateCode": "KR",
            "type": "join-random-call",
          }, meetingPayloadEnum: MeetingPayloadEnum.JOIN_RANDOM_CALL);
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeTabs.index,
          onTap: (int value) {
            homeTabs = HomeTabs.values[value];
            setState(() {});
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
        body: MultiProvider(
            providers: [ChangeNotifierProvider<HomeController>.value(value: homeController)],
            builder: (BuildContext context, Widget? snapshot) {
              return _getTab(homeTabs);
            }));
  }
}

enum HomeTabs { Call, Profile }
