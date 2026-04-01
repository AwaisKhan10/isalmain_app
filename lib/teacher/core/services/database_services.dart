import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';

import 'package:sheduling_app/teacher/core/model/message.dart';
import 'package:sheduling_app/teacher/core/model/conversation.dart';

class DatabaseServices {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final DatabaseServices _singleton = DatabaseServices._internal();

  factory DatabaseServices() {
    return _singleton;
  }

  DatabaseServices._internal();

  ///
  /// Chat Services
  ///
  
  Future<void> sendMessage(MessageModel message, {String? senderName, String? receiverName}) async {
    try {
      String docId = _database.collection("messages").doc().id;
      message.id = docId;
      
      final batch = _database.batch();
      
      // 1. Add message
      batch.set(_database.collection("messages").doc(docId), message.toJson());
      
      // 2. Update conversation summary
      if (message.chatId != null) {
        final convRef = _database.collection("conversations").doc(message.chatId);
        
        // Sorting IDs for consistent order in chatId
        List<String> participants = [message.senderId!, message.receiverId!];
        participants.sort();
        
        // Build update object
        Map<String, dynamic> convData = {
          "id": message.chatId,
          "lastMessage": message.content,
          "lastTime": message.time,
          "participants": participants,
        };
        
        // Store names for fast lookup in chat list
        if (senderName != null && receiverName != null) {
          if (participants[0] == message.senderId) {
            convData["id1Name"] = senderName;
            convData["id2Name"] = receiverName;
          } else {
            convData["id1Name"] = receiverName;
            convData["id2Name"] = senderName;
          }
        }
        
        batch.set(convRef, convData, SetOptions(merge: true));
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint("Exception @DatabaseService/sendMessage: $e");
    }
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _database
        .collection("messages")
        .where("chatId", isEqualTo: chatId)
        .orderBy("time", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ConversationModel>> getConversations(String userId) {
    return _database
        .collection("conversations")
        .where("participants", arrayContains: userId)
        .orderBy("lastTime", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  ///
  /// Utility to generate unique Chat ID
  ///
  static String getChatId(String id1, String id2) {
    if (id1.hashCode <= id2.hashCode) {
      return "${id1}_$id2";
    } else {
      return "${id2}_$id1";
    }
  }

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
      debugPrint('Teacher Data: ${snapshot.data()}');
      return TeacherUser.fromJson(snapshot.data(), snapshot.id);
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/getTeacherUser');
      debugPrint(s.toString());
      return TeacherUser();
    }
  }

  addStudentUser(StudentUser studentUser) async {
    try {
      await _database
          .collection("student_user")
          .doc(studentUser.id)
          .set(studentUser.toJson())
          .then((value) => debugPrint('student registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/registerStudentUser');
      debugPrint(s.toString());
      return false;
    }
  }

  Future<StudentUser> getStudentUser(id) async {
    debugPrint('@getStudentUser: id: $id');
    try {
      final snapshot = await _database.collection('student_user').doc(id).get();
      debugPrint('Student Data: ${snapshot.data()}');
      return StudentUser.fromJson(snapshot.data(), snapshot.id);
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/getStudentUser');
      debugPrint(s.toString());
      return StudentUser();
    }
  }

  updateClientFcm(token, id) async {
    await _database
        .collection("teacher_user")
        .doc(id)
        .update({'fcmToken': token}).then(
            (value) => debugPrint('fcm updated successfully'));
  }

  updateTeacherUser(TeacherUser teacherUser) async {
    try {
      await _database
          .collection("teacher_user")
          .doc(teacherUser.id)
          .update(teacherUser.toJson())
          .then((value) => debugPrint('Teacher profile updated successfully'));
      return true;
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/updateTeacherUser');
      debugPrint(s.toString());
      return false;
    }
  }

  updateStudentUser(StudentUser studentUser) async {
    try {
      await _database
          .collection("student_user")
          .doc(studentUser.id)
          .update(studentUser.toJson())
          .then((value) => debugPrint('Student profile updated successfully'));
      return true;
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/updateStudentUser');
      debugPrint(s.toString());
      return false;
    }
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
      classtimeshdedule.createdAt = DateTime.now().millisecondsSinceEpoch;

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
  Future<List<ClassTimeSheduleModel>> getClassTimeShedule(
      {String? department,
      String? section,
      String? semester,
      String? teacherId}) async {
    List<ClassTimeSheduleModel> classTimeSheduleList = [];
    try {
      // Fetch data from the Firestore collection
      Query query = _database.collection("class_time_shedule");

      if (department != null && department.isNotEmpty) {
        query = query.where('department', isEqualTo: department);
      }
      if (section != null && section.isNotEmpty) {
        query = query.where('class_section', isEqualTo: section);
      }
      if (semester != null && semester.isNotEmpty) {
        query = query.where('semester', isEqualTo: semester);
      }
      if (teacherId != null && teacherId.isNotEmpty) {
        query = query.where('teacherId', isEqualTo: teacherId);
      }

      final data = await query.get();

      // Loop through each document and convert it to ClassTimeSheduleModel
      for (var doc in data.docs) {
        classTimeSheduleList.add(ClassTimeSheduleModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id));
      }

      // Sort by createdAt descending (latest first)
      classTimeSheduleList.sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

      debugPrint(
          "Class Time Schedule List Fetched: ${classTimeSheduleList.length}");
    } catch (e) {
      debugPrint(
          "@DataBaseServices ClassTimeShedule Exception: ${e.toString()}");
    }

    return classTimeSheduleList; // Return the list of schedules
  }

  deleteClassTimeShedule(String id) async {
    try {
      await _database.collection("class_time_shedule").doc(id).delete();
      debugPrint("Schedule deleted successfully");
      return true;
    } catch (e) {
      debugPrint("Exception@deleteClassTimeShedule ==> $e");
      return false;
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
