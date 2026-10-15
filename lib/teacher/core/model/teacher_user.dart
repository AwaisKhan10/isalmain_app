class TeacherUser {
  String? id;
  String? profileImageUrl;
  String? fullName;
  String? fcmToken;
  String? email;
  String? phoneNo;
  String? password;
  String? department;
  String? qualification;
  String? subjects;
  String? gender;
  bool? isOnline;

  TeacherUser({
    this.id,
    this.email,
    this.profileImageUrl,
    this.fcmToken,
    this.fullName,
    this.password,
    this.phoneNo,
    this.department,
    this.qualification,
    this.gender,
    this.isOnline,
    this.subjects,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (profileImageUrl != null) {
      data['profileImageUrl'] = profileImageUrl;
      data['imgUrl'] = profileImageUrl;
    }
    if (fullName != null) data['fullName'] = fullName;
    if (fcmToken != null) data['fcmToken'] = fcmToken;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (phoneNo != null) data['phoneNo'] = phoneNo;
    if (department != null) data['department'] = department;
    if (qualification != null) data['qualification'] = qualification;
    if (gender != null) data['gender'] = gender;
    if (isOnline != null) data['isOnline'] = isOnline;
    if (subjects != null) data['subjects'] = subjects;
    return data;
  }

  TeacherUser.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    fullName = json['fullName'] as String?;
    profileImageUrl =
        (json['profileImageUrl'] ?? json['imgUrl']) as String?;
    email = json['email'] as String?;
    password = json['password'] as String?;
    fcmToken = json['fcmToken'] as String?;
    phoneNo = json['phoneNo'] as String?;
    department = json['department'] as String?;
    qualification = json['qualification'] as String?;
    gender = json['gender'] as String?;
    isOnline = json['isOnline'] as bool?;
    subjects = json['subjects'] as String?;
  }
}
