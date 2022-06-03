import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Notification at 21:00 Today or Next day & After 5days
///
class LocalNotificationService{
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late NotificationDetails _notificationDetails;

  Future<void> initialize() async{
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    tz.setLocalLocation(tz.getLocation("Asia/Seoul"));
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings _initializationSettingsAndroid = AndroidInitializationSettings("ic_launcher");
    final IOSInitializationSettings _initializationSettingsIOS = IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
        android: _initializationSettingsAndroid,
        iOS: _initializationSettingsIOS
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        //onSelectNotification: onSelectNotification()
    );

    var _androidDetail = AndroidNotificationDetails("id", "channel",
      channelDescription : "description",
      importance: Importance.max,
      priority: Priority.high,
    );

    var _iosDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    _notificationDetails = NotificationDetails(android: _androidDetail, iOS: _iosDetails);

    //tz.initializeDatabase([]);
    await _dailyNotification();
    await _after5DaysNotification();
  }

  Future<void> _dailyNotification() async {
    // 자정 알림
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Photly',
      '오늘의 질문 확인하기🤣',
        //makeDailyDate(21,00),
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time
    );
  }

  Future<void> _after5DaysNotification() async {
    // 5일 뒤 알림
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Photly',
        '오늘의 질문 확인하기🤣',
        //makeAfter5Days(21,00),
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time
    );
  }


  makeDailyDate(hour, min){
    var now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, 0);
    if (when.isBefore(now)) {
      return when.add(Duration(days: 1));
    } else {
      return when;
    }
  }

  makeAfter5Days(hour, min){
    var now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, 0);
    if (when.isBefore(now)) {
      return when.add(Duration(days: 6));
    } else {
      return when.add(Duration(days: 5));
    }
  }

  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}