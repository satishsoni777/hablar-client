// import 'dart:async';
// import 'dart:typed_data';
// import 'package:sound_stream/sound_stream.dart';
// import 'package:take_it_easy/utils/call_streaming/call_streaming.dart';

// class CallStreamingImpl extends RtcUtil {
//   RecorderStream _recorder = RecorderStream();
//   PlayerStream _player = PlayerStream();

//   List<Uint8List> _micChunks = [];
//   bool _isRecording = false;
//   bool _isPlaying = false;

//   late StreamSubscription _recorderStatus;
//   late StreamSubscription _playerStatus;
//   late StreamSubscription _audioStream;
  
//   @override
//   void init() {
   
//     initPlugin();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlugin() async {
//     _recorderStatus = _recorder.status.listen((status) {
//       _isRecording = status == SoundStreamStatus.Playing;
//       _isPlaying=_isRecording;
//     });

//     _audioStream = _recorder.audioStream.listen((data) {
//       if (_isPlaying) {
//         _player.writeChunk(data);
//       } else {
//         _micChunks.add(data);
//       }
//     });

//     _playerStatus = _player.status.listen((status) {
//       _isPlaying = status == SoundStreamStatus.Playing;
//     });

//     await Future.wait([
//       _recorder.initialize(),
//       _player.initialize(),
//     ]);
//   }

//   void _play() async {
//     await _player.start();

//     if (_micChunks.isNotEmpty) {
//       for (var chunk in _micChunks) {
//         await _player.writeChunk(chunk);
//       }
//       _micChunks.clear();
//     }
//   }

//   @override
//   void disconnect() {
//     // TODO: implement disconnect
//   }

//   @override
//   void mute() {
//     // TODO: implement mute
//   }

//   @override
//   void pause() {
//     // TODO: implement pause
//   }

//   @override
//   void play() {
//     _play();
//   }

//   @override
//   void reconnect() {
//     // TODO: implement reconnect
//   }

//   @override
//   void resume() {
//     // TODO: implement resume
//   }

//   @override
//   void sendData() {
//     // TODO: implement sendData
//   }

//   @override
//   void stop() {
//     // TODO: implement stop
//   }
//   @override
//   void dispose() {
//     _recorderStatus.cancel();
//     _playerStatus.cancel();
//     _audioStream.cancel();
//   }
// }
