import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

typedef void StreamStateCallback(MediaStream stream);

final Map<String, dynamic> configuration = <String, dynamic>{
  'iceServers': <dynamic>[
    <String, dynamic>{
      'urls': <String>[
        'stun:stun3.l.google.com:19302?transport=tcp',
        'stun:stun4.l.google.com:19302?transport=tcp'
      ],
    }
  ]
};

class WebrtcSignaling extends SignalingI with ChangeNotifier {
  WebrtcSignaling();
  CallType callType = CallType.Audio;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? _roomId;
  String? deleteByRoomlId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  RTCVideoRenderer? _locaRTCVideoRenderer;
  final AppWebSocket appWebSocket = DI.inject<AppWebSocket>();
  final SharedStorage _pref = DI.inject<SharedStorage>();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  RTCVideoRenderer get localRenderer => _localRenderer;
  HostType? hostType;
  int? userId;
  bool get muted => _muted;
  bool _muted = false;
  bool _speaker = false;
  bool _created = false;
  bool _joined = false;

  void joinRandomCall() async {
    appWebSocket.createRoom();
    appWebSocket.callStarted = (dynamic data) async {
      _roomId = data["_id"];
      deleteByRoomlId = data["roomId"];
      await _pref.setStringPreference(StorageKey.roomId, _roomId ?? '');
      userId = (await _pref.getUserData()).userId;
    };
    appWebSocket.userLeft = (d) {
      callEnd();
    };
    appWebSocket.join = (dynamic data) async {
      _roomId = data["_id"];
      deleteByRoomlId = data["roomId"];
      final roomId = deleteByRoomlId;
      await _pref.setStringPreference(StorageKey.roomId, _roomId ?? '');
      userId = (await _pref.getUserData()).userId;
      if (userId == int.parse(data["hostId"].toString()) && !_created) {
        _created = true;
        await createRoom(roomId ?? '');
      } else if (userId != int.parse(data["hostId"].toString()) && !_joined) {
        _joined = true;
        await joinRoom(roomId ?? '');
      }
    };
  }

  Future<void> createRoom(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference roomRef = db.collection('rooms').doc(_roomId);

    peerConnection = await createPeerConnection(configuration);
    print('configuration status ${peerConnection?.iceConnectionState}');

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((MediaStreamTrack track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    final CollectionReference<Map<String, dynamic>> callerCandidatesCollection =
        roomRef.collection('callerCandidates');

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

    print('New room _created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((MediaStreamTrack track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };
    // Listening for remote session description below
    roomRef.snapshots().listen((DocumentSnapshot<Object?> snapshot) async {
      print('Got updated room: ${snapshot}');
      if (snapshot != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data != null &&
            peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
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
    roomRef
        .collection('calleeCandidates')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docChanges
          .forEach((DocumentChange<Map<String, dynamic>> change) {
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

  Future<void> joinRoom(String roomId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    DocumentSnapshot<Object?> roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      peerConnection = await createPeerConnection(configuration);
      print(
          'Create PeerConnection with configuration: $configuration, $peerConnection');
      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((MediaStreamTrack track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      final CollectionReference<Map<String, dynamic>>
          calleeCandidatesCollection = roomRef.collection('calleeCandidates');
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
      roomRef
          .collection('calleeCandidates')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        snapshot.docChanges
            .forEach((DocumentChange<Map<String, dynamic>> document) {
          if (document.type == DocumentChangeType.added) {
            Map<String, dynamic> data =
                document.doc.data() as Map<String, dynamic>;
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
      final MediaStream stream = await navigator.mediaDevices
          .getUserMedia(<String, bool>{'video': false, 'audio': true});
      localVideo.srcObject = stream;
      localStream = stream;
      remoteVideo.srcObject = await createLocalMediaStream('key');
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  @override
  Future<bool> mute(bool mute) async {
    _locaRTCVideoRenderer?.muted = !mute;
    _muted = !mute;
    notifyListeners();
    return true;
  }

  void enableSpeaker(bool value) {
    _speaker = !value;
    _locaRTCVideoRenderer?.srcObject?.getAudioTracks().forEach((element) {
      element.enableSpeakerphone(_speaker);
    });
  }

  Future<void> hangUp(RTCVideoRenderer? localVideo) async {
    try {
      if (localVideo != null) {
        List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
        tracks.forEach((track) {
          track.stop();
        });
      }

      if (remoteStream != null) {
        remoteStream!.getTracks().forEach((track) => track.stop());
      }
      if (peerConnection != null) peerConnection!.close();
      localStream!.dispose();
      remoteStream?.dispose();
    } catch (e) {
      print("hangUp $e");
    }
  }

  Future<void> callEnd() async {
    try {
      await hangUp(_locaRTCVideoRenderer);
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> roomRef =
          db.collection('rooms').doc(_roomId);
      final List<dynamic> result = await Future.wait([
        roomRef.collection('calleeCandidates').get(),
        roomRef.collection('callerCandidates').get(),
      ]);
      final QuerySnapshot<Map<String, dynamic>> calleeCandidates = result.first;
      final QuerySnapshot<Map<String, dynamic>> callerCandidates = result[1];
      if (!isNullOrEmpty(deleteByRoomlId)) {
        appWebSocket.leaveRoom(<String, dynamic>{"roomId": deleteByRoomlId});
      }
      calleeCandidates.docs.forEach(
          (QueryDocumentSnapshot<Map<String, dynamic>> document) async =>
              await document.reference.delete());
      callerCandidates.docs.forEach(
          (QueryDocumentSnapshot<Map<String, dynamic>> document) async =>
              await document.reference.delete());
      await Future.wait(
          [roomRef.delete(), _pref.setStringPreference(StorageKey.roomId, "")]);
      // callStatus = CallStatus.CallEnded;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // callStatus = CallStatus.CallStarted;
        notifyListeners();
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        // callStatus = CallStatus.CallEnded;
        notifyListeners();
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {}
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future getCallDuration() {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    bool joinReqsent = false;
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    appWebSocket.onConnected = (dynamic a) async {
      await openUserMedia(_localRenderer, _remoteRenderer);
      joinReqsent = true;
    };
    if (appWebSocket.isConnected && !joinReqsent) {
      await openUserMedia(_localRenderer, _remoteRenderer);
    }
    onAddRemoteStream = ((MediaStream stream) {
      _remoteRenderer.srcObject = stream;
    });
  }

  @override
  Future<void> startCall(
      {UserConnectionData? data, String? roomId, int? userId}) {
    throw UnimplementedError();
  }

  @override
  Function(CallStatus p1, {Map<String, dynamic>? data}) get callStatus =>
      throw UnimplementedError();

  @override
  Future<void> speaker(bool value) {
    throw UnimplementedError();
  }
}
