import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  UserData({
    this.displayName,
    this.email,
    this.photoURL,
    this.uid,
    this.phoneNumber,
    this.emailVerified,
    this.tenantId,
    this.isAnonymous,
    this.userId,
  });
  UserData? instance;

  UserData.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      displayName = json['displayName'];
      email = json['emailId"'];
      photoURL = json['photoURL'];
      uid = json['uid'];
      phoneNumber = json['phoneNumber'];
      emailVerified = json['emailVerified'];
      tenantId = json['tenantId'];
      isAnonymous = json['isAnonymous'];
      userId = json['userId'];
      gender = json["gender"];
      isNewUser = json["isNewUser"];
    }
  }
  void copy(UserData data) {
    this.instance = data;
    if (instance != null) {
      displayName = data.displayName;
      email = data.email;
      emailVerified = data.emailVerified;
      gender = data.gender;
      isNewUser = data.isNewUser;
      photoURL = data.photoURL;
      phoneNumber = data.phoneNumber;
      uid = data.uid;
      userId = data.userId;
      tenantId = data.tenantId;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['emailId'] = this.email;
    data['photoURL'] = this.photoURL;
    data['uid'] = this.uid;
    data['phoneNumber'] = this.phoneNumber;
    data['emailVerified'] = this.emailVerified;
    data['tenantId'] = this.tenantId;
    data['isAnonymous'] = this.isAnonymous;
    data["isAnonymous"] = this.userId;
    data["gender"] = this.gender;
    data["isNewUser"] = this.isNewUser;
    return data;
  }

  String? displayName;
  String? email;
  String? photoURL;
  String? uid;
  String? phoneNumber;
  bool? emailVerified;
  String? tenantId;
  bool? isAnonymous;
  int? userId;
  String? gender;
  bool? isNewUser;
}
