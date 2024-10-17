import 'package:flutter/material.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class HomeViewModel extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  // Controllers for form fields
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when not in use
    departmentController.dispose();
    subjectController.dispose();
    semesterController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
