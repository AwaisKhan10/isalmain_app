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
import 'package:sheduling_app/teacher/core/utils/schedule_utils.dart';
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
            RefreshIndicator(
              color: secondaryColor,
              onRefresh: () => model.getClassTimeShedule(showLoader: false),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (model.isListLoading &&
                      model.listClassTimeShedule.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: constraints.maxHeight,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  }
                  if (model.listClassTimeShedule.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: constraints.maxHeight,
                          child: const Center(
                            child: Text("No schedules added by you yet"),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                "Field: ${schedule.field ?? 'N/A'}",
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
                                "Day: ${schedule.day ?? 'N/A'}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                              4.verticalSpace,
                              Text(
                                "Date: ${ScheduleUtils.formatClassDate(schedule.classDate)}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                              4.verticalSpace,
                              Text(
                                "Time: ${ScheduleUtils.formatTimeDisplay(schedule.time)}",
                                style: styleN16.copyWith(color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                            );
                          },
                        );
                },
              ),
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
      return Scaffold(
        backgroundColor: secondaryColor,
        body: Consumer<HomeViewModel>(
        builder: (context, sheetModel, _) => Padding(
        padding: MediaQuery.of(sheetContext).viewInsets,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    value: sheetModel.selectedDepartment,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Department'),
                    items: AppConstants.departments.map((dept) {
                      return DropdownMenuItem(value: dept, child: Text(dept));
                    }).toList(),
                    onChanged: sheetModel.setDepartment,
                  ),
                  if (sheetModel.selectedDepartment != null) ...[
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      icon: dropdownFieldIcon,
                      value: sheetModel.selectedField,
                      validator: (value) => value == null ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Field (e.g. Software, AI)',
                      ),
                      items: AppConstants.fieldsForDepartment(
                              sheetModel.selectedDepartment)
                          .map((field) {
                        return DropdownMenuItem(
                            value: field, child: Text(field));
                      }).toList(),
                      onChanged: sheetModel.setField,
                    ),
                  ],
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    icon: dropdownFieldIcon,
                    value: sheetModel.selectedSection,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Section'),
                    items: AppConstants.sections.map((sec) {
                      return DropdownMenuItem(value: sec, child: Text(sec));
                    }).toList(),
                    onChanged: sheetModel.setSection,
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
                    value: sheetModel.selectedSemester,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Semester'),
                    items: AppConstants.semesters.map((sem) {
                      return DropdownMenuItem(
                          value: sem, child: Text("Semester $sem"));
                    }).toList(),
                    onChanged: sheetModel.setSemester,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    icon: dropdownFieldIcon,
                    value: sheetModel.selectedDay,
                    validator: (value) => value == null ? "Required" : null,
                    decoration: authFieldDecoration.copyWith(
                      hintText: 'Select Day (e.g. Monday)',
                    ),
                    items: AppConstants.weekDays.map((day) {
                      return DropdownMenuItem(value: day, child: Text(day));
                    }).toList(),
                    onChanged: sheetModel.setDay,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: sheetContext,
                        initialDate: sheetModel.selectedClassDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null) sheetModel.setClassDate(picked);
                    },
                    child: InputDecorator(
                      decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Class Date',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sheetModel.selectedDateLabel,
                            style: styleN16.copyWith(
                              color: sheetModel.selectedClassDate == null
                                  ? Colors.grey
                                  : blackColor,
                            ),
                          ),
                          const Icon(Icons.calendar_today, color: blackColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (sheetModel.selectedClassDate == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        'Date is required',
                        style: styleN12.copyWith(color: Colors.red.shade200),
                      ),
                    ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: sheetContext,
                        initialTime: sheetModel.selectedClassTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) sheetModel.setClassTime(picked);
                    },
                    child: InputDecorator(
                      decoration: authFieldDecoration.copyWith(
                        hintText: 'Select Class Time',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sheetModel.selectedTimeLabel,
                            style: styleN16.copyWith(
                              color: sheetModel.selectedClassTime == null
                                  ? Colors.grey
                                  : blackColor,
                            ),
                          ),
                          const Icon(Icons.access_time, color: blackColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (sheetModel.selectedClassTime == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        'Time is required',
                        style: styleN12.copyWith(color: Colors.red.shade200),
                      ),
                    ),
                  if (sheetModel.formError != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade300, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              sheetModel.formError!,
                              style: styleN14.copyWith(
                                color: Colors.red.shade900,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      FocusScope.of(sheetContext).unfocus();

                      if (!formKey.currentState!.validate()) {
                        AppSnackbar.error(
                          'Please complete all required fields (department, field, section, semester, subject, day)',
                          context: sheetContext,
                        );
                        return;
                      }
                      if (sheetModel.selectedField == null) {
                        AppSnackbar.error(
                          'Please select a field for this department',
                          context: sheetContext,
                        );
                        return;
                      }
                      if (sheetModel.selectedClassDate == null ||
                          sheetModel.selectedClassTime == null) {
                        AppSnackbar.error(
                          'Please select class date and time',
                          context: sheetContext,
                        );
                        return;
                      }

                      final wasEditing = sheetModel.editingScheduleId != null;
                      final error = await sheetModel.addClassTimeShedule();
                      if (!sheetContext.mounted) return;

                      if (error != null) {
                        AppSnackbar.error(error, context: sheetContext);
                        return;
                      }

                      Navigator.of(sheetContext).pop();
                      AppSnackbar.success(
                        wasEditing
                            ? 'Schedule updated successfully'
                            : 'Schedule added successfully',
                        context: context,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
      );
    },
  );
}
