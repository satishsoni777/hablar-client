class MeetingDetails {
  MeetingDetails({this.hostId, this.hostName, this.id});
  String? id;
  String? hostId;
  String? hostName;
  factory MeetingDetails.fromJson(dynamic json) {
    return MeetingDetails(hostName: json["name"], hostId: json["userId"], id: json["id"]);
  }
}
