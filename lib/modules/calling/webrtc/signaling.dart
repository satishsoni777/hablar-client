import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

enum CallStatus { Connecting, CallStarted, CallEnded, Mute, Disconnected }

enum CallType { Video, Audio }

enum HostType { Callee, Caller }

typedef void StreamStateCallback(MediaStream stream);

final Map<String, dynamic> configuration = <String, dynamic>{
  'iceServers': <dynamic>[
    <String, dynamic>{
      'urls': <String>['stun:stun3.l.google.com:19302', 'stun:stun4.l.google.com:19302']
    }
  ]
};

class Signaling with ChangeNotifier {
  CallStatus callStatus = CallStatus.Connecting;
  CallType callType = CallType.Audio;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  RTCVideoRenderer? _locaRTCVideoRenderer;
  final AppWebSocket appWebSocket = DI.inject<AppWebSocket>();
  final SharedStorage _pref = DI.inject<SharedStorage>();
  bool _muted = false;
  bool get muted => _muted;
  HostType? hostType;

  void joinRandomCall() async {
    appWebSocket.joinRandomCall();
    appWebSocket.roomCreated = (dynamic data) {
      roomId = data["roomId"];
      createRoom();
      _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
    };
    appWebSocket.callStarted = (dynamic data) async {
      roomId = data["roomId"];
      await _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
      final userId = (await _pref.getUserData()).userId;
    };
    appWebSocket.join = (dynamic data) async {
      roomId = data["roomId"];
      await _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
      final userId = (await _pref.getUserData()).userId;
      if (userId == int.parse(data["hostId"].toString())) {
        await createRoom();
      }
      if (userId != int.parse(data["hostId"].toString())) {
        await Future.delayed(const Duration(seconds: 1));
        await joinRoom();
      }
    };
  }

  Future<void> createRoom() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference roomRef = db.collection('rooms').doc(roomId);

    peerConnection = await createPeerConnection(configuration);
    print('configuration status ${peerConnection?.iceConnectionState}');

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((MediaStreamTrack track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    CollectionReference<Map<String, dynamic>> callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    await roomRef.set(roomWithOffer);

    print('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((MediaStreamTrack track) {
        print('Add a track to the remoteStream $track');
        notifyListeners();
        remoteStream?.addTrack(track);
      });
    };
    // Listening for remote session description below
    roomRef.snapshots().listen((DocumentSnapshot<Object?> snapshot) async {
      print('Got updated room: ${snapshot}');
      if (snapshot != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null && data['answer'] != null) {
          RTCSessionDescription answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docChanges.forEach((DocumentChange<Map<String, dynamic>> change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          print('Got new remote ICE candidate: ${jsonEncode(data)}');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });
    hostType = HostType.Caller;
    // Listen for remote ICE candidates above
    notifyListeners();
  }

  Future<void> joinRoom() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    DocumentSnapshot<Object?> roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((MediaStreamTrack track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      CollectionReference<Map<String, dynamic>> calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((MediaStreamTrack track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      Map<String, dynamic> data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      RTCSessionDescription answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        print("## callerCandidates ##");
        notifyListeners();
        snapshot.docChanges.forEach((DocumentChange<Map<String, dynamic>> document) {
          Map<String, dynamic> data = document.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
    hostType = HostType.Callee;
    notifyListeners();
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    _locaRTCVideoRenderer = localVideo;
    final MediaStream stream = await navigator.mediaDevices.getUserMedia(
      <String, bool>{'video': false, 'audio': true},
    );
    localVideo.srcObject = stream;
    localStream = stream;
    remoteVideo.srcObject = await createLocalMediaStream('key');
    remoteVideo.srcObject?.getVideoTracks().forEach((MediaStreamTrack element) {
      element.enabled = false;
    });
    notifyListeners();
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    final List<MediaStreamTrack>? tracks = localVideo.srcObject?.getTracks();
    tracks?.forEach((MediaStreamTrack track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((MediaStreamTrack track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (roomId != null) {}
    localVideo.srcObject?.dispose();
    await peerConnection?.dispose();
    await localStream?.dispose();
    await remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        callStatus = CallStatus.CallStarted;
        notifyListeners();
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed || state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        callStatus = CallStatus.CallEnded;
        callEnd();
        notifyListeners();
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
        callStatus = CallStatus.CallStarted;
        notifyListeners();
      }
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  void stop() {
    try {
      peerConnection?.onTrack = (RTCTrackEvent a) => {
            a.streams.forEach((MediaStream element) {
              element.getVideoTracks().forEach((MediaStreamTrack element) {
                element.enabled = false;
                element.stop();
              });
            }),
            a.streams.forEach((MediaStream element) {
              element.getAudioTracks().forEach((MediaStreamTrack element) {
                element.enabled = false;
                element.stop();
              });
            })
          };
    } catch (_) {
      print(_);
    }
  }

  void mute(bool mute) async {
    _locaRTCVideoRenderer?.muted = !mute;
    _muted = !mute;
    notifyListeners();
  }

  Future<void> callEnd() async {
    try {
      final String? roomId = await _pref.getStringPreference(StorageKey.roomId);
      if (isNullOrEmpty(roomId)) return;
      appWebSocket.leaveRoom(<String, dynamic>{"roomId": roomId});
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> roomRef = db.collection('rooms').doc(roomId);
      if (hostType == HostType.Callee) {
        QuerySnapshot<Map<String, dynamic>> calleeCandidates = await roomRef.collection('calleeCandidates').get();
        calleeCandidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
      } else {
        QuerySnapshot<Map<String, dynamic>> callerCanidates = await roomRef.collection('callerCandidates').get();
        callerCanidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
      }
      await roomRef.delete();
      await hangUp(_locaRTCVideoRenderer!);
      stop();
      callStatus = CallStatus.CallEnded;
    } catch (e) {
      print(e);
    }
    await _pref.setStringPreference(StorageKey.roomId, "");
    notifyListeners();
  }
}
