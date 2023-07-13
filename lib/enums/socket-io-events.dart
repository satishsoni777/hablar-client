class MeetingPayloadEnum {
  static const String JOIN_MEETIN = "join-room",
      JOIN_RANDOM_CALL = "join-random-call",
      JOINED_MEETING = "joined-room",
      USER_JOINED = "user-joined",
      INCOMING_CONNECTIOPN_REQUEST = "incoming-connection-request",
      OFFER_SDP = "offer-sdp",
      ANSWER_SDP = "answer-sdp",
      LEAVE_ROOM = "leave-room",
      USER_LEFTL = "user-left",
      END_MEETING = "end-room",
      MEETING_ENDED = "room-ended",
      ICECANDIDATE = "incecandidate",
      VIDEO_TOOGLE = "video-toggle",
      AUDIO_TOOGLE = "audio-toggle",
      NOT_FOUND = "not-found",
      UNKNOWN = "unknown",
      CHAT_MESSAGE = "chat-message",
      JOIN = "join",
      CREATE_ROOM = "create-room";
}

class SocketEvents {
  const SocketEvents.instance(this._value);

  factory SocketEvents.from(int value) => SocketEvents.instance(value);

  int get value => _value;
  final int _value;

  @override
  bool operator ==(dynamic name) {
    if (name is SocketEvents) {
      return name._value == _value;
    }
    return false;
  }

  static const SocketEvents JOIN_MEETIN = SocketEvents.instance(100),
      JOIN_RANDOM_CALL = SocketEvents.instance(101),
      USER_JOINED = SocketEvents.instance(102),
      CREATE_ROOM = SocketEvents.instance(103),
      JOIN = SocketEvents.instance(104);

  @override
  int get hashCode => _value.hashCode;
}
