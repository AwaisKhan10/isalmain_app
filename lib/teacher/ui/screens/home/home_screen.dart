// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/strings.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/ui/screens/home/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, model, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: _appBar(model),

          ///
          /// Start Body
          ///
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Departments",
                    textAlign: TextAlign.center,
                    style: styleB25.copyWith(
                        color: secondaryColor, fontSize: 30.sp),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GridView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 20.0),
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [primaryColor, secondaryColor]),
                              boxShadow: [
                                BoxShadow(
                                    color: secondaryColor.withOpacity(0.20),
                                    offset: const Offset(0, 4),
                                    spreadRadius: 4,
                                    blurRadius: 4)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "Statistics",
                                  style: styleB25.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                "Subject: Calculas",
                                textAlign: TextAlign.center,
                                style: styleB16.copyWith(color: whiteColor),
                              ),
                              Text(
                                "Semester: 4th",
                                textAlign: TextAlign.center,
                                style: styleB16.copyWith(color: whiteColor),
                              ),
                              Text(
                                "Time: 10:30 to 11:30",
                                textAlign: TextAlign.center,
                                style: styleB14.copyWith(color: whiteColor),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ),

          ///
          /// Floating Action Button
          ///
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondaryColor,
            // focusColor: blackColor,
            // hoverColor: blackColor,
            // splashColor: blackColor,
            // foregroundColor: blackColor,
            onPressed: () {
              _showBottomSheet(context, model);
              // Navigate to Sign In Screen
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SignInScreen(),
              //   ),
              // );
            },
            child: const Icon(
              Icons.person_add,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

AppBar _appBar(HomeViewModel model) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0.0,
    // shadowColor: secondaryColor,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    toolbarHeight: 80.h,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${model.authServices.teacherUser.fullName}",
            style: styleB25.copyWith(color: secondaryColor, fontSize: 28.sp)),
        Text(
          "${model.authServices.teacherUser.qualification}",
          style: styleB16,
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 30.r,
          backgroundImage: const AssetImage("$staticAssets/fiver-profile.jpeg"),
        ),
      ),
      // CircleAvatar(
      //   radius: 25.r,
      //   backgroundColor: secondaryColor,
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.notifications,
      //       size: 35.sp,
      //       color: whiteColor,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
    ],
  );
}

// Function to show the bottom sheet
void _showBottomSheet(BuildContext context, HomeViewModel model) {
  showModalBottomSheet(
    isScrollControlled:
        true, // Allows the bottom sheet to be full-screen and scrollable
    backgroundColor: secondaryColor,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  'CLASS TIME SHEDULE',
                  style: styleB25.copyWith(color: whiteColor, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: model.departmentController,
                  decoration:
                      authFieldDecoration.copyWith(hintText: 'Departments'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: model.subjectController,
                  decoration: authFieldDecoration.copyWith(hintText: 'Subject'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: model.semesterController,
                  decoration:
                      authFieldDecoration.copyWith(hintText: 'Semester'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: model.timeController,
                  decoration: authFieldDecoration.copyWith(hintText: 'Time'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(whiteColor)),
                  onPressed: () {
                    // Perform any actions here, like submitting data
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Text(
                    'Submit',
                    style: styleB16.copyWith(color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
