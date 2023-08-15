class ConversationalList {
  ConversationalList({
    this.otherUserId,
    this.rating,
    this.comment,
    this.userId,
    this.name,
    this.image,
    this.success,
  });

  ConversationalList.fromJson(Map<String, dynamic> json) {
    otherUserId = json['otherUserId'];
    rating = json['rating'];
    comment = json['comment'];
    userId = json['userId'];
    name = json['name'];
    image = json['image'];
    success = json['success'];
  }
  int? otherUserId;
  int? rating;
  String? comment;
  int? userId;
  String? name;
  String? image;
  bool? success;
}
