import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class FirebaseCloudMessagingService {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String PUSH = "$PHOTLY/user/push";

  Future<Object> pushPartnerToUpload() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'req_type' : 0,
    };
    // call API
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> pushUploadedNotification() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'req_type' : 1,
    };
    // call API
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> registerDevice() async {
    String _userId = await AuthService().getCurrentUserId();
    String? _deviceToken = await FirebaseMessaging.instance.getToken();
    print(_deviceToken);

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'user_device_token' : _deviceToken,
    };

    print(inputData);
    // call API
    return await _remoteDataSource.putToUri(PUSH, inputData);
  }

  Future<void> fcmSetting() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Register Device
    var response = await registerDevice();
    if(response is Success){
      print("디바이스 등록 성공");
    }
    if(response is Failure) {
      print("디바이스 등록 실패");
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // foreground에서의 푸시 알림 표시를 위한 local notifications 설정
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {});

    // foreground 푸시 알림 핸들링
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data.keys}');
      print('Message data: ${message.data.values}');

      // background 푸시 알림 핸들링
      print('Got a message whilst in the background!');
      print(notification?.title);
      print(notification?.body);
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance: Importance.max,
                priority: Priority.max,
                enableLights: true,
                visibility: NotificationVisibility.public,
                icon: android?.smallIcon,
              ),
              iOS: IOSNotificationDetails(),
            ));
      }
    });
  }

}