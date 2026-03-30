class StudentUser {
  String? id;
  String? fullName;
  String? email;
  String? fcmToken;
  String? department;
  String? section;
  String? semester;
  String? password;

  StudentUser({
    this.id,
    this.fullName,
    this.email,
    this.fcmToken,
    this.department,
    this.section,
    this.semester,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'fcmToken': fcmToken,
      'department': department,
      'section': section,
      'semester': semester,
      'password': password,
    };
  }

  StudentUser.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    fullName = json['fullName'];
    email = json['email'];
    fcmToken = json['fcmToken'];
    department = json['department'];
    section = json['section'];
    semester = json['semester'];
    password = json['password'];
  }
}
