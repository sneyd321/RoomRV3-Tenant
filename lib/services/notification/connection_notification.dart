import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MaintenanceTicketConnectionNotification {

final localNotificationService = FlutterLocalNotificationsPlugin();



  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@drawable/ic_stat_build");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await localNotificationService.initialize(settings,onSelectNotification: (String? data) { 
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  },);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            showProgress: true,
            indeterminate: true,
            playSound: true);

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification() async {
    final details = await _notificationDetails();
    await localNotificationService.show(0, "Upload Maintenance Ticket", "Connecting to servers...", details);
  }
  
  void onSelectNotification(String? data) {
    
  }




}