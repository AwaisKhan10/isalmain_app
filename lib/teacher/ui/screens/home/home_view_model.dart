import 'package:flutter/material.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    getClassTimeShedule();
  }

  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  List<ClassTimeSheduleModel> listClassTimeShedule = [];
  bool isListLoading = false;
  bool isSaving = false;

  final TextEditingController departmentController = TextEditingController();
  final TextEditingController classSectionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String? editingScheduleId;

  @override
  void dispose() {
    departmentController.dispose();
    classSectionController.dispose();
    subjectController.dispose();
    semesterController.dispose();
    timeController.dispose();
    super.dispose();
  }

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

  Future<bool> addClassTimeShedule() async {
    isSaving = true;
    notifyListeners();

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

    try {
      await dataBaseServices.addClassTimeShedule(classTimeSheduleModel);
      clearEditMode();
      await getClassTimeShedule();
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> getClassTimeShedule() async {
    isListLoading = true;
    notifyListeners();

    listClassTimeShedule = await dataBaseServices.getClassTimeShedule(
      teacherId: authServices.teacherUser.id,
    );
    debugPrint(
      "ClassTimeShedule list fetched: ${listClassTimeShedule.length} for teacherId: ${authServices.teacherUser.id}",
    );

    isListLoading = false;
    notifyListeners();
  }

  Future<bool> deleteSchedule(String id) async {
    isListLoading = true;
    notifyListeners();

    final success = await dataBaseServices.deleteClassTimeShedule(id);
    if (success) {
      await getClassTimeShedule();
      return true;
    }

    isListLoading = false;
    notifyListeners();
    return false;
  }
}
