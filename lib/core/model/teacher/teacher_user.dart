class TeacherUser {
  String? id;
  String? imgUrl;
  String? fullName;
  String? fcmToken;
  String? email;
  String? phoneNo;
  String? password;

  TeacherUser(
      {this.id,
      this.email,
      this.imgUrl,
      this.fcmToken,
      this.fullName,
      this.password,
      this.phoneNo});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['fullName'] = fullName;
    data['fcmToken'] = fcmToken;
    data['email'] = email;
    data['password'] = password;
    data['phoneNo'] = phoneNo;
    return data;
  }

  TeacherUser.fromJson(json, id) {
    id = id;
    fullName = json['fullName'];
    imgUrl = json['imgUrl'];
    email = json['email'];
    fcmToken = json['fcmToken'];
    phoneNo = json['phoneNo'];
    password = json['password'];
  }
}
