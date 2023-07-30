import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

enum CallStatus { Connecting, CallStarted, CallEnded, Mute, Disconnected, UserLeft }

enum CallType { Video, Audio }

enum HostType { Callee, Caller }

typedef void StreamStateCallback(MediaStream stream);

final Map<String, dynamic> configuration = <String, dynamic>{
  'iceServers': <dynamic>[
    <String, dynamic>{
      'urls': <String>['stun:stun4.l.google.com:19302', 'stun:stun5.l.google.com:19302']
    }
  ]
};

class Signaling with ChangeNotifier {
  Signaling(this.userData);
  final UserData userData;
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
    _listenEvents();
  }

  void _listenEvents() {
    appWebSocket.createRoom = (dynamic data) async {
      roomId = data["roomId"];
      await createRoom();
      _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
    };
    appWebSocket.callStarted = (dynamic data) async {
      roomId = data["roomId"];
      await _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
    };
    appWebSocket.join = (dynamic data) async {
      print("await createRoom()");
      roomId = data["roomId"];
      await _pref.setStringPreference(StorageKey.roomId, roomId ?? '');
      if (userData.userId == int.parse(data["hostId"].toString())) {
        await createRoom();
      }
      if (userData.userId != int.parse(data["hostId"].toString())) {
        await joinRoom();
      }
    };
    appWebSocket.userLeft = (dynamic data) {
      callStatus = CallStatus.UserLeft;
      notifyListeners();
    };
    appWebSocket.callEnd = (dynamic data) {};
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
    try {
      _locaRTCVideoRenderer = localVideo;
      final MediaStream stream = await navigator.mediaDevices.getUserMedia(
        <String, bool>{'video': true, 'audio': true},
      );
      localVideo.srcObject = stream;
      localStream = stream;
      remoteVideo.srcObject = await createLocalMediaStream('key');
      remoteVideo.srcObject?.getVideoTracks().forEach((MediaStreamTrack element) {
        element.enabled = false;
      });
    } catch (_) {
      print("openUserMedia $_");
    }
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
    try {
      await Future.wait([
        peerConnection!.dispose(),
        localStream!.dispose(),
        remoteStream!.dispose(),
        _locaRTCVideoRenderer!.srcObject!.dispose(),
        _locaRTCVideoRenderer!.dispose()
      ]);
    } catch (_) {}
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
        // callStatus = CallStatus.CallStarted;
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
    _locaRTCVideoRenderer?.dispose();
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
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference<Map<String, dynamic>> roomRef = db.collection('rooms').doc(roomId);
    try {
      final List<dynamic> result = await Future.wait([
        _pref.getStringPreference(StorageKey.roomId),
        roomRef.collection('calleeCandidates').get(),
        roomRef.collection('callerCandidates').get(),
        roomRef.delete(),
        hangUp(_locaRTCVideoRenderer!)
      ]);
      final String? roomId = result[0].toString();
      QuerySnapshot<Map<String, dynamic>> calleeCandidates = result[1];
      QuerySnapshot<Map<String, dynamic>> callerCanidates = result[2];
      if (isNullOrEmpty(roomId)) return;
      appWebSocket.leaveRoom(<String, dynamic>{"roomId": roomId});
      if (hostType == HostType.Callee) {
        calleeCandidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
      } else {
        callerCanidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
      }
      stop();
      callStatus = CallStatus.CallEnded;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
