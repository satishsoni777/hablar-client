import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/rtc/webrtc/webrtc_signaling.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key, required this.localRenderer, required this.remoteRenderer});
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  @override
  State<VideoCall> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<VideoCall> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebrtcSignaling>(builder: (BuildContext context, WebrtcSignaling pr, a) {
      if (pr.callType != CallType.Video) return Container();
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: AspectRatio(
              aspectRatio: .54,
              child: RotatedBox(
                quarterTurns: 0,
                child: RTCVideoView(
                  widget.remoteRenderer,
                  mirror: true,
                  filterQuality: FilterQuality.low,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 180,
                width: 120,
                child: RotatedBox(
                  quarterTurns: 0,
                  child: RTCVideoView(
                    widget.localRenderer,
                    mirror: true,
                    filterQuality: FilterQuality.low,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
