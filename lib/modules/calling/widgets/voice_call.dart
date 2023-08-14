import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/calling/controller/signaling_controller.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/style/theme/image_path.dart';

class VoiceCall extends StatelessWidget {
  const VoiceCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignalingController>(builder:
        (BuildContext context, SignalingController provide, Widget? a) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            provide.signaling == CallStatus.CallStarted
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
            if (provide.callStatus == CallStatus.CallStarted)
              TimerConverter(
                seconds: 1,
              )
            else if (provide.callStatus == CallStatus.Connecting)
              Text("Connecting..."),
            Spacer(),
            provide.callStatus == CallStatus.CallStarted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            provide.onSpeaker(provide.speaker);
                          },
                          icon: provide.speaker
                              ? Icon(Icons.speaker_notes_off)
                              : Icon(Icons.speaker)),
                      IconButton(
                          onPressed: () {
                            provide.mute(provide.muted);
                          },
                          icon: provide.muted
                              ? Icon(Icons.mic_off)
                              : Icon((Icons.mic))),
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
                        onPressed: () {
                          provide.callEnd();
                        },
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
  const TimerConverter({required this.seconds});
  final int seconds;

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
      if (mounted) setState(() {});
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
