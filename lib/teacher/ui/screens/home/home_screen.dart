import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/teacher/ui/screens/home/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: whiteColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: () {
            model.clearEditMode();
            _showBottomSheet(context, model);
          },
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'My Class Schedules',
            style: styleB25.copyWith(color: secondaryColor, fontSize: 22.sp),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: whiteColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: secondaryColor),
              onPressed: () => model.getClassTimeShedule(),
            ),
          ],
        ),
        body: Stack(
          children: [
            if (model.isListLoading && model.listClassTimeShedule.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (model.listClassTimeShedule.isEmpty)
              const Center(child: Text("No schedules added by you yet"))
            else
              ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: model.listClassTimeShedule.length,
                    itemBuilder: (context, index) {
                      final schedule = model.listClassTimeShedule[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      schedule.subject ?? "N/A",
                                      style:
                                          styleB18.copyWith(color: whiteColor),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue, size: 20),
                                        onPressed: () {
                                          model.setupEditMode(schedule);
                                          _showBottomSheet(context, model);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 20),
                                        onPressed: () => _showDeleteDialog(
                                            context, model, schedule.id!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Department: ${schedule.department}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                              4.verticalSpace,
                              Text(
                                "Section: ${schedule.classSection}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                              4.verticalSpace,
                              Text(
                                "Semester: ${schedule.semester}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                              4.verticalSpace,
                              Text(
                                "Time: ${schedule.time}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            if (model.isListLoading && model.listClassTimeShedule.isNotEmpty)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(minHeight: 3),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HomeViewModel model, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Schedule"),
        content: const Text("Are you sure you want to delete this schedule?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await model.deleteSchedule(id);
              if (success) {
                AppSnackbar.success('Schedule deleted successfully');
              } else {
                AppSnackbar.error('Could not delete schedule');
              }
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, HomeViewModel model) {
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: secondaryColor,
    context: context,
    builder: (sheetContext) {
      return Consumer<HomeViewModel>(
        builder: (context, sheetModel, _) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    sheetModel.editingScheduleId == null
                        ? 'ADD CLASS SCHEDULE'
                        : 'EDIT CLASS SCHEDULE',
                    style:
                        styleB25.copyWith(color: whiteColor, fontSize: 20.sp),
                  ),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    icon: dropdownFieldIcon,
                    value: sheetModel.departmentController.text.isEmpty
                        ? null
                        : sheetModel.departmentController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Department'),
                    items: AppConstants.departments.map((dept) {
                      return DropdownMenuItem(value: dept, child: Text(dept));
                    }).toList(),
                    onChanged: (val) =>
                        sheetModel.departmentController.text = val!,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    icon: dropdownFieldIcon,
                    value: sheetModel.classSectionController.text.isEmpty
                        ? null
                        : sheetModel.classSectionController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Section'),
                    items: AppConstants.sections.map((sec) {
                      return DropdownMenuItem(value: sec, child: Text(sec));
                    }).toList(),
                    onChanged: (val) =>
                        sheetModel.classSectionController.text = val!,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: sheetModel.subjectController,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                    decoration:
                        authFieldDecoration.copyWith(hintText: 'Subject Name'),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    icon: dropdownFieldIcon,
                    value: sheetModel.semesterController.text.isEmpty
                        ? null
                        : sheetModel.semesterController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Semester'),
                    items: AppConstants.semesters.map((sem) {
                      return DropdownMenuItem(
                          value: sem, child: Text("Semester $sem"));
                    }).toList(),
                    onChanged: (val) =>
                        sheetModel.semesterController.text = val!,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: sheetModel.timeController,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Class Time (e.g. 10:00 AM)'),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    name: sheetModel.editingScheduleId == null
                        ? 'Submit Schedule'
                        : 'Update Schedule',
                    isLoading: sheetModel.isSaving,
                    textColor: secondaryColor,
                    color1: whiteColor,
                    color2: whiteColor,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final wasEditing = sheetModel.editingScheduleId != null;
                        final success = await sheetModel.addClassTimeShedule();
                        if (success) {
                          Get.back();
                          AppSnackbar.success(
                            wasEditing
                                ? 'Schedule updated successfully'
                                : 'Schedule added successfully',
                          );
                        } else {
                          AppSnackbar.error('Could not save schedule');
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    },
  );
}
