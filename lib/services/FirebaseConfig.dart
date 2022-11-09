import 'package:camera_example/business_logic/comment.dart';
import 'package:camera_example/services/notification/complete_notification.dart';
import 'package:camera_example/services/notification/connection_notification.dart';
import 'package:camera_example/services/notification/upload_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfiguration {
  static final FirebaseConfiguration _singleton =
      FirebaseConfiguration._internal();

  factory FirebaseConfiguration() {
    return _singleton;
  }

  FirebaseConfiguration._internal();
  MaintenanceTicketConnectionNotification
      maintenanceTicketConnectionNotification =
      MaintenanceTicketConnectionNotification();
  UploadNotification uploadNotification = UploadNotification();
  UploadCompleteNotification completeNotification =
      UploadCompleteNotification();

  void initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    maintenanceTicketConnectionNotification.initialize();
    uploadNotification.initialize();
    completeNotification.initialize();

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) async {
      print("TEST");
      if (message.notification!.title! == "Maintenance Ticket Upload") {
        switch (message.notification!.body!) {
          case "Image uploading...":
            await uploadNotification.showNotification();
            break;
          case "Upload Complete":
            await completeNotification
                .showNotification(message.data["imageURL"].toString());
            break;
        }
      }
    });
  }

  FirebaseFirestore getDB() {
    return FirebaseFirestore.instance;
  }

  Future<void> setComment(String firebaseId, Comment comment) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MaintenanceTicket")
        .doc(firebaseId)
        .collection("Comment")
        .doc();
    documentReference.set(comment.toJson());
  }

  Future<String?> getToken() async {
    if (kIsWeb) {
      return await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BN0NLV1vcX9IwimhTRi5UomTfgBOSVfFJ86K01mzxkKXmfWGNgYF2kQgrsG-VQGNyE9C3el6-J8dj8AHZpWn6lk");
    }
    return await FirebaseMessaging.instance.getToken();
  }
}
