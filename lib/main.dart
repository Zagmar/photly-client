import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/photly_style.dart';
import 'package:couple_seflie_app/ui/splash_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/manage/manage_account_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/user_profile_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'amplifyconfiguration.dart';
import 'data/repository/auth_service.dart';
import 'data/repository/firebase_cloud_messaging_service.dart';
import 'data/repository/local_notification_service.dart';

bool _isLogined = false;
late String username;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 실행");
  print('Got a message whilst in the background!');
  print('Message data: ${message.data.keys}');
  print('Message data: ${message.data.values}');
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  // background 푸시 알림 표시를 위한 local notifications 설정
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          )),
      onSelectNotification: (String? payload) async {});

  // background 푸시 알림 핸들링
  print('Got a message whilst in the background!');
  print('Message data: ${message.data.keys}');
  print('Message data: ${message.data.values}');
  print("${message.data['pinpoint.notification.title']}");
  print("${message.data['pinpoint.notification.body']}");
  flutterLocalNotificationsPlugin.show(
    0,
    "${message.data['pinpoint.notification.title']}",
    "${message.data['pinpoint.notification.body']}",
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        visibility: NotificationVisibility.public,
      ),
      iOS: IOSNotificationDetails(),
    ),
  );
}

main() async {
  // Show Flutter native Splash with Bind Flutter Widget
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  // Init Firebase to use FCM
  //await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Init ScreenUtil to correspond to various device size
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Init Local Notification
  LocalNotificationService().initialize();
  // Add Amplify category plugins
  Amplify.addPlugins([AmplifyAuthCognito(),AmplifyAPI(), ]);

  // Configure Amplify categories via the amplifyconfiguration.dart
  // configuration that was generated via the Amplify CLI
  // to generate an `amplifyconfiguration.dart` file run
  //
  // $ npm install -g @aws-amplify/cli@flutter-preview
  // $ amplify init
  //
  // from the terminal and choose "flutter" as the framework
  try {
    await Amplify.configure(amplifyconfig);
    print('Successfully configured Amplify 🎉');
  } on AmplifyAlreadyConfiguredException {
    print("Amplify was already configured. Looks like app restarted on android.");
  } catch (e) {
    print('Could not configure Amplify ☠️');
  }

  // Check Whether User Already Sign In
  final AuthFlowStatus authFlowStatus = await AuthService().checkAuthStatusService();
  if(authFlowStatus == AuthFlowStatus.session) {
    _isLogined = true;
  }
  else{
    _isLogined = false;
  }

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> DailyCouplePostViewModel(),),
        ChangeNotifierProvider(create: (context)=> PostViewModel()),
        ChangeNotifierProvider(create: (context) => UserInfoViewModel()),
        ChangeNotifierProvider(create: (context) => UserProfileViewModel()),
      ],
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    if (_isLogined && !_isLoading) {
      _isLoading = true;
      Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser();
      Provider.of<DailyCouplePostViewModel>(context,listen: false).initDailyCouplePosts();
      FirebaseCloudMessagingService().fcmSetting();
    }

    print("myApp 실행");
    return ScreenUtilInit(
        splitScreenMode: false,
        designSize: const Size(375, 667),
        builder: (context, _) => OverlaySupport(
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            ),
            debugShowCheckedModeBanner: false,
            title: 'Photly',
            theme: PhotlyStyle(MediaQueryData()).photlyThemeData,
            home: _isLogined ?
            Provider.of<DailyCouplePostViewModel>(context).isLoadDone ?
            // Show loading widget when is loading
            PostMainScreen()
                :
            SplashScreen()
                :
            LoginScreen(),
            routes: {
              '/postEditScreen': (context) => PostEditScreen(),
              '/manageAccountScreen': (context) => ManageAccountScreen(),
            },
          ),
        )
    );
  }
}