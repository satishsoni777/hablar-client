class UserConnectionData {
  UserConnectionData(
      {this.name,
      this.userId,
      this.username,
      this.audio = true,
      this.video = false});
  String? userId;
  String? username;
  String? name;
  bool audio;
  bool video;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
    };
  }

  Map<String, dynamic> mediaConstraint() {
    return {"video": video, "audio": audio};
  }
}
