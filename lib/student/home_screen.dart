import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/student/ui/screens/home/student_home_view_model.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentHomeViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "My Classes",
            style: styleB25.copyWith(color: secondaryColor, fontSize: 24.sp),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: secondaryColor),
              onPressed: () => model.fetchFilteredClasses(),
            ),
          ],
        ),
        body: model.state == ViewState.busy
            ? const Center(child: CircularProgressIndicator())
            : model.filteredClasses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.class_outlined,
                            size: 60.sp, color: Colors.grey),
                        SizedBox(height: 10.h),
                        const Text("No classes found for your section."),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: model.filteredClasses.length,
                    itemBuilder: (context, index) {
                      final item = model.filteredClasses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.subject ?? "No Subject",
                                style: styleB18,
                              ),
                              const SizedBox(height: 5),
                              Text("Time: ${item.time}"),
                              Text("Semester: ${item.semester}"),
                              Text("Dept: ${item.department}"),
                              Text("Section: ${item.classSection}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
