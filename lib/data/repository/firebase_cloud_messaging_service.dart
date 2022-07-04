import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class FirebaseCloudMessagingService {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String PUSH = "$PHOTLY/user/push";

  Future<Object> pushPartnerToUpload() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'req_type' : 0,
    };
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> pushUploadedNotification() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'req_type' : 1,
    };
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> pushPartnerMatchedNotification() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'req_type' : 4,
    };
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> pushPartnerClearNotification() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'req_type' : 5,
    };
    return await _remoteDataSource.postToUri(PUSH, inputData);
  }

  Future<Object> registerDevice() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'user_device_token' : await FirebaseMessaging.instance.getToken(),
    };

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
      print("Success to register device");
    }
    if(response is Failure) {
      print("Failure to register device");
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // local notifications setting for notification on foreground
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

    // foreground notification handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

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