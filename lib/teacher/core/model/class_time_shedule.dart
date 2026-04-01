class ClassTimeSheduleModel {
  String? id;

  String? department;
  String? classSection;
  String? subject;
  String? semester;
  String? time;
  int? createdAt;
  String? teacherId;
  String? teacherName;

  ClassTimeSheduleModel(
      {this.id,
      this.department,
      this.classSection,
      this.semester,
      this.subject,
      this.time,
      this.createdAt,
      this.teacherId,
      this.teacherName});

  toJson() {
    return {
      "id": id,
      "department": department,
      "class_section": classSection,
      "subject": subject,
      "semester": semester,
      "time": time,
      "teacherId": teacherId,
      "teacherName": teacherName,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    };
  }

  ClassTimeSheduleModel.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    department = json['department'];
    classSection = json['class_section'];
    subject = json['subject'];
    semester = json['semester'];
    time = json['time'];
    createdAt = json['createdAt'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
  }
}
