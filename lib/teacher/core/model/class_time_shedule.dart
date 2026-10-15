class ClassTimeSheduleModel {
  String? id;

  String? department;
  String? field;
  String? classSection;
  String? subject;
  String? semester;
  String? day;
  int? classDate;
  String? time;
  int? startTimeMinutes;
  int? createdAt;
  String? teacherId;
  String? teacherName;

  ClassTimeSheduleModel(
      {this.id,
      this.department,
      this.field,
      this.classSection,
      this.semester,
      this.day,
      this.classDate,
      this.subject,
      this.time,
      this.startTimeMinutes,
      this.createdAt,
      this.teacherId,
      this.teacherName});

  toJson() {
    return {
      "id": id,
      "department": department,
      "field": field,
      "class_section": classSection,
      "subject": subject,
      "semester": semester,
      "day": day,
      "classDate": classDate,
      "time": time,
      "startTimeMinutes": startTimeMinutes,
      "teacherId": teacherId,
      "teacherName": teacherName,
      "createdAt": createdAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  ClassTimeSheduleModel.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    department = json['department'];
    field = json['field'];
    classSection = json['class_section'];
    subject = json['subject'];
    semester = json['semester'];
    day = json['day'];
    classDate = json['classDate'];
    time = json['time'];
    startTimeMinutes = json['startTimeMinutes'];
    createdAt = json['createdAt'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
  }
}
