import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:take_it_easy/style/app_colors.dart';
import 'package:take_it_easy/style/spacing.dart';

class Dialer extends StatefulWidget {
  const Dialer({Key? key}) : super(key: key);

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  late RtcInterface rtcInterface;
  @override
  void initState() {
    rtcInterface = AgoraManager();
    _init();
    super.initState();
  }
  @override
  void dispose(){
    rtcInterface.dispose();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.sizeBoxHt20,
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.people),
            ),
            Spacing.sizeBoxHt20,
            Text('unknown'),
            Spacing.sizeBoxHt20,
            Text("Timer"),
            const Spacer(),
            AppButton(
              shapeBorder: CircleBorder(),
              child: Icon(Icons.call),
              borderRadius: 35,
              color: AppColors.lightRed,
              height: 70.0,
              width: 70,
              onPressed: () {},
            ),
            Spacing.sizeBoxHt40,
          ],
        ),
      ),
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
