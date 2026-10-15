import 'package:flutter/material.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/utils/schedule_utils.dart';
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

  final TextEditingController subjectController = TextEditingController();

  String? selectedDepartment;
  String? selectedField;
  String? selectedSection;
  String? selectedSemester;
  String? selectedDay;
  DateTime? selectedClassDate;
  TimeOfDay? selectedClassTime;

  String? editingScheduleId;
  String? formError;

  String get selectedDateLabel => selectedClassDate == null
      ? 'Select class date'
      : ScheduleUtils.formatClassDate(selectedClassDate!.millisecondsSinceEpoch);

  String get selectedTimeLabel => selectedClassTime == null
      ? 'Select class time'
      : ScheduleUtils.timeOfDayToLabel(selectedClassTime!);

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  void clearFormError() {
    if (formError != null) {
      formError = null;
      notifyListeners();
    }
  }

  void setDepartment(String? department) {
    clearFormError();
    selectedDepartment = department;
    selectedField = null;
    notifyListeners();
  }

  void setField(String? field) {
    clearFormError();
    selectedField = field;
    notifyListeners();
  }

  void setSection(String? section) {
    clearFormError();
    selectedSection = section;
    notifyListeners();
  }

  void setSemester(String? semester) {
    clearFormError();
    selectedSemester = semester;
    notifyListeners();
  }

  void setDay(String? day) {
    clearFormError();
    selectedDay = day;
    notifyListeners();
  }

  void setClassDate(DateTime date) {
    clearFormError();
    selectedClassDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void setClassTime(TimeOfDay time) {
    clearFormError();
    selectedClassTime = time;
    notifyListeners();
  }

  void setupEditMode(ClassTimeSheduleModel schedule) {
    editingScheduleId = schedule.id;
    selectedDepartment = schedule.department;
    selectedField = schedule.field;
    selectedSection = schedule.classSection;
    subjectController.text = schedule.subject ?? "";
    selectedSemester = schedule.semester;
    selectedDay = schedule.day;
    selectedClassDate = schedule.classDate != null
        ? DateTime.fromMillisecondsSinceEpoch(schedule.classDate!)
        : null;
    selectedClassTime = ScheduleUtils.parseTimeLabel(schedule.time);
    notifyListeners();
  }

  void clearEditMode() {
    editingScheduleId = null;
    selectedDepartment = null;
    selectedField = null;
    selectedSection = null;
    selectedSemester = null;
    subjectController.clear();
    selectedDay = null;
    selectedClassDate = null;
    selectedClassTime = null;
    formError = null;
    notifyListeners();
  }

  ClassTimeSheduleModel? _buildScheduleModel() {
    if (selectedDepartment == null ||
        selectedField == null ||
        selectedSection == null ||
        selectedSemester == null ||
        selectedDay == null ||
        selectedClassDate == null ||
        selectedClassTime == null) {
      return null;
    }

    final subject = subjectController.text.trim();
    if (subject.isEmpty) return null;

    return ClassTimeSheduleModel(
      id: editingScheduleId,
      department: selectedDepartment,
      field: selectedField,
      classSection: selectedSection,
      subject: subject,
      semester: selectedSemester,
      day: selectedDay,
      classDate: selectedClassDate!.millisecondsSinceEpoch,
      time: ScheduleUtils.timeOfDayToLabel(selectedClassTime!),
      startTimeMinutes: ScheduleUtils.timeOfDayToMinutes(selectedClassTime!),
      teacherId: authServices.teacherUser.id,
      teacherName: authServices.teacherUser.fullName,
    );
  }

  /// Returns an error message on failure, or null on success.
  Future<String?> addClassTimeShedule() async {
    formError = null;
    final schedule = _buildScheduleModel();
    if (schedule == null) {
      formError =
          'Please fill department, field, section, semester, subject, day, date and time';
      notifyListeners();
      return formError;
    }

    isSaving = true;
    notifyListeners();

    try {
      // Brief delay so the submit button loader is visible before validation/save.
      await Future<void>.delayed(const Duration(milliseconds: 450));

      final conflict = ScheduleUtils.findTeacherScheduleConflict(
        existing: listClassTimeShedule,
        candidate: schedule,
        excludeId: editingScheduleId,
      );
      if (conflict != null) {
        formError = conflict;
        notifyListeners();
        return conflict;
      }

      final saved = await dataBaseServices.addClassTimeShedule(schedule);
      if (!saved) {
        formError = 'Could not save schedule. Please try again.';
        notifyListeners();
        return formError;
      }
      clearEditMode();
      await getClassTimeShedule();
      return null;
    } catch (e) {
      debugPrint('addClassTimeShedule error: $e');
      formError = 'Could not save schedule. Please try again.';
      notifyListeners();
      return formError;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> getClassTimeShedule({bool showLoader = true}) async {
    if (showLoader) {
      isListLoading = true;
      notifyListeners();
    }

    listClassTimeShedule = await dataBaseServices.getClassTimeShedule(
      teacherId: authServices.teacherUser.id,
    );
    ScheduleUtils.sortSchedules(listClassTimeShedule);
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
