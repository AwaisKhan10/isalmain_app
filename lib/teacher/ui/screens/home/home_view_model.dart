import 'package:flutter/material.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class HomeViewModel extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  List<ClassTimeSheduleModel> listClassTimeShedule = [];

  HomeViewModel({getClassTimeShedule()?});

  //final ClassTimeSheduleModel classTimeSheduleModel = ClassTimeSheduleModel();

  // Controllers for form fields
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController classSectionController = TextEditingController();
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

  addClassTimeShedule() async {
    final classTimeSheduleModel = ClassTimeSheduleModel(
      department: departmentController.text.trim(),
      classSection: classSectionController.text.trim(),
      subject: subjectController.text.trim(),
      semister: semesterController.text.trim(),
      time: timeController.text.trim(),
    );
    await dataBaseServices.addClassTimeShedule(classTimeSheduleModel);
  }

  getClassTimeShedule() async {
    setState(ViewState.busy);
    listClassTimeShedule = await dataBaseServices.getClassTimeShedule();
    setState(ViewState.idle);
  }
}
