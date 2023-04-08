class UserConnectionData {
  UserConnectionData({
    this.name,
    this.userId,
    this.username,
    this.audio = true,
    this.video = true,
    this.meetingId,
  });
  String? userId;
  String? username;
  String? name;
  bool audio;
  bool video;
  String? meetingId;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "username": username,
      "audio": audio,
      "video": video,
      "meetingId": meetingId
    };
  }

  Map<String, dynamic> mediaConstraint() {
    return {
      "video": video,
      "audio": audio
    };
  }
}
