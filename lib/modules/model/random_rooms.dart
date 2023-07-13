class RoomsResponse {
  bool? success;
  Data? data;

  RoomsResponse({this.success, this.data});

  RoomsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? createdAt;
  String? roomId;
  String? userId;

  Data({
    this.createdAt,
    this.roomId,
    this.userId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    roomId = json['roomId'];
    userId = json["userId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['roomId'] = this.roomId;
    data["userId"] = this.userId;
    return data;
  }
}
