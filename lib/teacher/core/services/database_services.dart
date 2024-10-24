import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';

class DatabaseServices {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final DatabaseServices _singleton = DatabaseServices._internal();

  factory DatabaseServices() {
    return _singleton;
  }

  DatabaseServices._internal();

  ///
  ///
  ///adding data to dataBase

  addTeacherUser(TeacherUser teacherUser) async {
    try {
      await _database
          .collection("teacher_user")
          .doc(teacherUser.id)
          .set(teacherUser.toJson())
          .then((value) => debugPrint('user registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/registerAppUser');
      debugPrint(s.toString());
      return false;
    }
  }

  Future<TeacherUser> getTeacherUser(id) async {
    //Todo: Rename getUsers -> getUser
    debugPrint('@getAppUser: id: $id');
    try {
      final snapshot = await _database.collection('teacher_user').doc(id).get();
      debugPrint('Client Data: ${snapshot.data()}');
      return TeacherUser.fromJson(snapshot.data(), snapshot.id);
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/getTeacherUser');
      debugPrint(s.toString());
      return TeacherUser();
    }
  }

  updateClientFcm(token, id) async {
    await _database
        .collection("teacher_user")
        .doc(id)
        .update({'fcmToken': token}).then(
            (value) => debugPrint('fcm updated successfully'));
  }

  ///
  ///
  ///class time shedule
  ///
  addClassTimeShedule(ClassTimeSheduleModel classtimeshdedule) async {
    try {
      await _database
          .collection("class_time_shedule")
          .doc(classtimeshdedule.id)
          .set(classtimeshdedule.toJson())
          .then((value) => debugPrint("Added Data Successfully"));
    } catch (e) {
      // print("@DataBaseServices ClassTimeSgedule ==>  ${e.toString()}");

      debugPrint("@DataBaseServices ClassTimeSgedule ${e.toString()}");
      return false;
    }
  }

  ///
  ///get class time shedule
  ///
  getClassTimeShedule() async {
    List<ClassTimeSheduleModel> classTimeSheduleModel = [];
    print("class time => ${classTimeSheduleModel.toString()}");
    try {
      final data = await _database.collection("class_time_shedule").get();
      print("class time => ${data}");
      // for (var element in data.docs) {
      //   classTimeSheduleModel
      //       .add(ClassTimeSheduleModel.fromJson(element.data()));
      //   debugPrint("@Database Services Get =====> ${data}");
      // }
    } catch (e) {
      debugPrint("@DataBaseServices ClassTimeSgedule ${e.toString()}");
      return ClassTimeSheduleModel();
    }
  }

  // getBasketData() async {
  //   List<Basket> basketList = [];
  //   try {
  //     final basketData = await _db.collection('baskets').get();
  //     print("BaketData length==>>>>>${basketData.docs.length}");
  //     if (basketData.docs.length > 0) {
  //       basketData.docs.forEach((element) {
  //         basketList.add(Basket.fromJson(element.data(), element.id));
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception@getBasket ==> $e");
  //   }
  //   return basketList;
  // }
}
