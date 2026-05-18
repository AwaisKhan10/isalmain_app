import 'package:flutter/material.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class StudentHomeViewModel extends BaseViewModel {
  final _authServices = locator<AuthServices>();
  final _databaseServices = locator<DatabaseServices>();

  List<ClassTimeSheduleModel> filteredClasses = [];
  bool isListLoading = false;

  StudentHomeViewModel() {
    fetchFilteredClasses();
  }

  Future<void> fetchFilteredClasses() async {
    isListLoading = true;
    notifyListeners();

    final student = _authServices.studentUser;

    if (student.department != null &&
        student.section != null &&
        student.semester != null) {
      filteredClasses = await _databaseServices.getClassTimeShedule(
        department: student.department,
        section: student.section,
        semester: student.semester,
      );
    } else {
      AppSnackbar.error(
        'Complete your profile (department, section, semester) to see classes',
      );
      debugPrint("Student department, section or semester is null");
    }

    isListLoading = false;
    notifyListeners();
  }
}
