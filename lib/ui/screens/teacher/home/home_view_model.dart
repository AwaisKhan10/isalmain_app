import 'package:flutter/material.dart';
import 'package:sheduling_app/core/view_model/view_model.dart';

class HomeViewModel extends BaseViewModel {
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
