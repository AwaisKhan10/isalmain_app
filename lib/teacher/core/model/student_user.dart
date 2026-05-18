class StudentUser {
  String? id;
  String? profileImageUrl;
  String? fullName;
  String? email;
  String? fcmToken;
  String? department;
  String? section;
  String? semester;
  String? password;
  bool? isOnline;

  StudentUser({
    this.id,
    this.fullName,
    this.email,
    this.profileImageUrl,
    this.fcmToken,
    this.department,
    this.section,
    this.semester,
    this.password,
    this.isOnline,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;
    if (fcmToken != null) data['fcmToken'] = fcmToken;
    if (department != null) data['department'] = department;
    if (section != null) data['section'] = section;
    if (semester != null) data['semester'] = semester;
    if (password != null) data['password'] = password;
    if (isOnline != null) data['isOnline'] = isOnline;
    return data;
  }

  StudentUser.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    fullName = json['fullName'];
    email = json['email'];
    profileImageUrl = json['profileImageUrl'];
    fcmToken = json['fcmToken'];
    department = json['department'];
    section = json['section'];
    semester = json['semester'];
    password = json['password'];
    isOnline = json['isOnline'];
  }
}
