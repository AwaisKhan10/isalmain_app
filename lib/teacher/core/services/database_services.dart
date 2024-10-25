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
      String docId = classtimeshdedule.id ??
          _database.collection("class_time_shedule").doc().id;
      classtimeshdedule.id = docId;

      debugPrint("Adding Data with ID: $docId"); // Debug print

      await _database
          .collection("class_time_shedule")
          .doc(docId)
          .set(classtimeshdedule.toJson())
          .then((value) => debugPrint("Added Data Successfully"));
    } catch (e) {
      debugPrint("@DataBaseServices ClassTimeShedule ${e.toString()}");
      return false;
    }
  }

  ///
  ///get class time shedule
  ///
  Future<List<ClassTimeSheduleModel>> getClassTimeShedule() async {
    List<ClassTimeSheduleModel> classTimeSheduleList = [];
    try {
      // Fetch data from the Firestore collection
      final data = await _database.collection("class_time_shedule").get();

      // Loop through each document and convert it to ClassTimeSheduleModel
      for (var doc in data.docs) {
        classTimeSheduleList
            .add(ClassTimeSheduleModel.fromJson(doc.data(), doc.id));
      }

      debugPrint(
          "Class Time Schedule List Fetched: ${classTimeSheduleList.length}");
    } catch (e) {
      debugPrint(
          "@DataBaseServices ClassTimeShedule Exception: ${e.toString()}");
    }

    return classTimeSheduleList; // Return the list of schedules
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
