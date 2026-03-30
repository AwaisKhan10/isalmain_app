import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
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
        body: model.state == ViewState.busy
            ? const Center(child: CircularProgressIndicator())
            : model.listClassTimeShedule.isEmpty
                ? const Center(child: Text("No schedules added by you yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: model.listClassTimeShedule.length,
                    itemBuilder: (context, index) {
                      final schedule = model.listClassTimeShedule[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      schedule.subject ?? "N/A",
                                      style: styleB18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        onPressed: () {
                                          model.setupEditMode(schedule);
                                          _showBottomSheet(context, model);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _showDeleteDialog(context, model, schedule.id!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text("Department: ${schedule.department}"),
                              Text("Section: ${schedule.classSection}"),
                              Text("Semester: ${schedule.semester}"),
                              Text("Time: ${schedule.time}"),
                            ],
                          ),
                        ),
                      );
                    },
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
              await model.deleteSchedule(id);
              Get.snackbar("Success", "Schedule deleted successfully");
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
    builder: (context) {
      return Padding(
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
                    model.editingScheduleId == null ? 'ADD CLASS SCHEDULE' : 'EDIT CLASS SCHEDULE',
                    style: styleB25.copyWith(color: whiteColor, fontSize: 20.sp),
                  ),
                  const SizedBox(height: 25),
                  
                  DropdownButtonFormField<String>(
                    value: model.departmentController.text.isEmpty ? null : model.departmentController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(hintText: 'Select Department'),
                    items: AppConstants.departments.map((dept) {
                      return DropdownMenuItem(value: dept, child: Text(dept));
                    }).toList(),
                    onChanged: (val) => model.departmentController.text = val!,
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    value: model.classSectionController.text.isEmpty ? null : model.classSectionController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(hintText: 'Select Section'),
                    items: AppConstants.sections.map((sec) {
                      return DropdownMenuItem(value: sec, child: Text(sec));
                    }).toList(),
                    onChanged: (val) => model.classSectionController.text = val!,
                  ),
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: model.subjectController,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(hintText: 'Subject Name'),
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    value: model.semesterController.text.isEmpty ? null : model.semesterController.text,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(hintText: 'Select Semester'),
                    items: AppConstants.semesters.map((sem) {
                      return DropdownMenuItem(value: sem, child: Text("Semester $sem"));
                    }).toList(),
                    onChanged: (val) => model.semesterController.text = val!,
                  ),
                  const SizedBox(height: 14),
                  
                  TextFormField(
                    controller: model.timeController,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(hintText: 'Class Time (e.g. 10:00 AM)'),
                  ),
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await model.addClassTimeShedule();
                        Get.back();
                        Get.snackbar("Success", model.editingScheduleId == null ? "Schedule added successfully" : "Schedule updated successfully");
                      }
                    },
                    child: Text(
                      model.editingScheduleId == null ? 'SUBMIT SCHEDULE' : 'UPDATE SCHEDULE',
                      style: styleB16.copyWith(color: secondaryColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
