class GmailUserData {
  String displayName;
  String email;
  String photoURL;
  String uid;
  String phoneNumber;
  bool emailVerified;
  String tenantId;
  bool isAnonymous;

  GmailUserData(
      {this.displayName,
      this.email,
      this.photoURL,
      this.uid,
      this.phoneNumber,
      this.emailVerified,
      this.tenantId,
      this.isAnonymous});

  GmailUserData.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    photoURL = json['photoURL'];
    uid = json['uid'];
    phoneNumber = json['phoneNumber'];
    emailVerified = json['emailVerified'];
    tenantId = json['tenantId'];
    isAnonymous = json['isAnonymous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['photoURL'] = this.photoURL;
    data['uid'] = this.uid;
    data['phoneNumber'] = this.phoneNumber;
    data['emailVerified'] = this.emailVerified;
    data['tenantId'] = this.tenantId;
    data['isAnonymous'] = this.isAnonymous;
    return data;
  }
}
