import 'dart:io';

import 'package:esandhai/app/app_logs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance = NotificationService._privateConstructor();
  String? fcmToken;
  FirebaseMessaging? firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    logs('Background message Id : ${message.messageId}');
    logs('Background message Time : ${message.sentTime}');
  }

  Future<void> initializeNotification() async {
    await Firebase.initializeApp();
    await initializeLocalNotification();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    fcmToken = await firebaseMessaging.getToken();
    logs('FCM Token --> $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings notificationSettings = await firebaseMessaging.requestPermission(announcement: true);

    logs('Notification permission status : ${notificationSettings.authorizationStatus.name}');
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        logs('Message title: ${remoteMessage.notification!.title}, body: ${remoteMessage.notification!.body}');
        logs('Data message --> ${remoteMessage.data}');
        final String largeIconPath = await _downloadAndSaveFile(remoteMessage.data['image'], 'largeIcon');
        final String bigPicturePath = await _downloadAndSaveFile(remoteMessage.data['image'], 'bigPicture');
        final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          contentTitle: remoteMessage.notification!.title!,
          htmlFormatContentTitle: true,
          summaryText: remoteMessage.notification!.body,
          htmlFormatSummaryText: true,
        );
        AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          'CHANNEL ID',
          'CHANNEL NAME',
          channelDescription: 'CHANNEL DESCRIPTION',
          importance: Importance.max,
          priority: Priority.max,
          styleInformation: bigPictureStyleInformation,
        );
        DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: [DarwinNotificationAttachment(largeIconPath), DarwinNotificationAttachment(bigPicturePath)],
        );
        NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

        await flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification!.title!,
          remoteMessage.notification!.body!,
          notificationDetails,
        );
      });
    }
  }

  initializeLocalNotification() {
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings ios = const DarwinInitializationSettings();
    InitializationSettings platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = Platform.isIOS ? '${directory.path}/$fileName.jpeg' : '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
