import 'package:flutter/material.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    getClassTimeShedule(); // This method will be called when HomeViewModel is initialized
  }

  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  List<ClassTimeSheduleModel> listClassTimeShedule = [];

  // Controllers for form fields
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController classSectionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String? editingScheduleId;

  @override
  void dispose() {
    // Dispose controllers when not in use
    departmentController.dispose();
    classSectionController.dispose();
    subjectController.dispose();
    semesterController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // Pre-fill controllers for editing
  void setupEditMode(ClassTimeSheduleModel schedule) {
    editingScheduleId = schedule.id;
    departmentController.text = schedule.department ?? "";
    classSectionController.text = schedule.classSection ?? "";
    subjectController.text = schedule.subject ?? "";
    semesterController.text = schedule.semester ?? "";
    timeController.text = schedule.time ?? "";
    notifyListeners();
  }

  void clearEditMode() {
    editingScheduleId = null;
    departmentController.clear();
    classSectionController.clear();
    subjectController.clear();
    semesterController.clear();
    timeController.clear();
    notifyListeners();
  }

  // Add or Update class time schedule
  addClassTimeShedule() async {
    setState(ViewState.busy);
    final classTimeSheduleModel = ClassTimeSheduleModel(
      id: editingScheduleId,
      department: departmentController.text.trim(),
      classSection: classSectionController.text.trim(),
      subject: subjectController.text.trim(),
      semester: semesterController.text.trim(),
      time: timeController.text.trim(),
      teacherId: authServices.teacherUser.id,
      teacherName: authServices.teacherUser.fullName,
    );
    
    await dataBaseServices.addClassTimeShedule(classTimeSheduleModel);
    
    // Clear controllers after success
    clearEditMode();
    
    // Refresh the list
    await getClassTimeShedule();
    
    setState(ViewState.idle);
  }

  // Get class time schedule (filtered for CURRENT teacher)
  getClassTimeShedule() async {
    setState(ViewState.busy);
    listClassTimeShedule = await dataBaseServices.getClassTimeShedule(
      teacherId: authServices.teacherUser.id,
    );
    debugPrint("ClassTimeShedule list fetched: ${listClassTimeShedule.length} for teacherId: ${authServices.teacherUser.id}");
    setState(ViewState.idle);
  }

  // Delete schedule
  deleteSchedule(String id) async {
    setState(ViewState.busy);
    bool success = await dataBaseServices.deleteClassTimeShedule(id);
    if (success) {
      await getClassTimeShedule();
    }
    setState(ViewState.idle);
    return success;
  }
}
