import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<VideoCall> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: AspectRatio(
            aspectRatio: .54,
            child: RotatedBox(
              quarterTurns: 0,
              child: RTCVideoView(
                _remoteRenderer,
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
                  _localRenderer,
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
  }
}
