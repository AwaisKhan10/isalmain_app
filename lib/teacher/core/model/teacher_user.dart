import 'dart:io';

class TeacherUser {
  String? id;
  File? imgUrl;
  String? fullName;
  String? fcmToken;
  String? email;
  String? phoneNo;
  String? password;

  //teacher information
  String? department;
  String? qualification;
  String? subjects;
  String? gender;

  TeacherUser(
      {this.id,
      this.email,
      this.imgUrl,
      this.fcmToken,
      this.fullName,
      this.password,
      this.phoneNo,
      this.department,
      this.qualification,
      this.gender,
      this.subjects});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['fullName'] = fullName;
    data['fcmToken'] = fcmToken;
    data['email'] = email;
    data['password'] = password;
    data['phoneNo'] = phoneNo;
    data['department'] = department;
    data['qualification'] = qualification;
    data['gender'] = gender;
    data['subjects'] = subjects;

    return data;
  }

  TeacherUser.fromJson(json, id) {
    id = id;
    fullName = json['fullName'];
    imgUrl = json['imgUrl'];
    email = json['email'];
    password = json['password'];
    fcmToken = json['fcmToken'];
    phoneNo = json['phoneNo'];
    department = json['password'];
    qualification = json['qualification'];
    gender = json['gender'];
    subjects = json['subjects'];
  }
}
