class ClassTimeSheduleModel {
  String? id;

  String? department;
  String? classSection;
  String? subject;
  String? semister;
  String? time;

  ClassTimeSheduleModel(
      {this.id,
      this.department,
      this.classSection,
      this.semister,
      this.subject,
      this.time});

  toJson() {
    return {
      "id": id,
      "department": department,
      "class_section": classSection,
      "subject": subject,
      "semister": semister,
      "time": time,
    };
  }

  ClassTimeSheduleModel.fromJson(
    json,
  ) {
    this.id = id;
    department = json['department'];
    classSection = json['class_section'];
    subject = json['subject'];
    semister = json['semister'];
    time = json['time'];
    department = json['department'];
  }
}
