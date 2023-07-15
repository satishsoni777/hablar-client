import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/style/theme/image_path.dart';

class VoiceCall extends StatelessWidget {
  const VoiceCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Signaling>(builder: (BuildContext context, Signaling provide, Widget? a) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            provide.callStatus == CallStatus.Connected
                ? CircleAvatar(
                    child: Icon(Icons.person),
                    maxRadius: 40,
                  )
                : CircleAvatar(
                    maxRadius: 40,
                    child: Image.asset(
                      ImagePath.call,
                    ),
                  ),
            SizedBox(
              height: 16,
            ),
            if (provide.callStatus == CallStatus.Connected)
              TimerConverter(
                seconds: 1,
              )
            else
              Text("Connecting..."),
            Spacer(),
            provide.callStatus == CallStatus.Connected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          ImagePath.speaker,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.red,
                        shape: CircleBorder(),
                        child: Icon(Icons.phone_forwarded_sharp),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.red,
                        shape: CircleBorder(),
                        height: 65,
                        child: Icon(Icons.phone_forwarded_sharp),
                      )
                    ],
                  ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    });
  }
}

class TimerConverter extends StatefulWidget {
  final int seconds;

  TimerConverter({required this.seconds});

  @override
  State<TimerConverter> createState() => _TimerConverterState();
}

class _TimerConverterState extends State<TimerConverter> {
  Timer? timer;
  String duration = "";
  @override
  void initState() {
    timer?.cancel();
    _convertToHours();
    super.initState();
  }

  String _formatTime(int value) {
    return value < 10 ? '0$value' : value.toString();
  }

  void _convertToHours() {
    int seconds;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timer.tick;
      seconds = timer.tick;
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      String formattedHours = _formatTime(hours);
      String formattedMinutes = _formatTime(minutes);
      String formattedSeconds = _formatTime(remainingSeconds);

      duration = '$formattedHours:$formattedMinutes:$formattedSeconds';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      duration,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}
