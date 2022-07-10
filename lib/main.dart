import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/theme/photly_style.dart';
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
import 'data/repository/data_repository.dart';
import 'data/repository/firebase_cloud_messaging_service.dart';
import 'data/repository/local_notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

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

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null && android != null) {
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
            icon: android.smallIcon,
          ),
          iOS: IOSNotificationDetails(),
        ));
  }
}

main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  LocalNotificationService().initialize();
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

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        splitScreenMode: false,
        designSize: const Size(375, 667),
        builder: (context, _) {
          return MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            ),
            debugShowCheckedModeBanner: false,
            title: 'Photly',
            theme: PhotlyStyle(MediaQueryData()).photlyThemeData,
            home: const MyHomePage(),
            routes: {
              '/postEditScreen': (context) => PostEditScreen(),
              '/manageAccountScreen': (context) => ManageAccountScreen(),
            },
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthFlowStatus _authFlowStatus = AuthFlowStatus.login;
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    _authFlowStatus = await AuthService().checkAuthStatusService();
    if(_authFlowStatus == AuthFlowStatus.session) {
      await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser();
      await Provider.of<DailyCouplePostViewModel>(context,listen: false).initDailyCouplePosts();
      await FirebaseCloudMessagingService().fcmSetting();
      DataRepository().sendExecutionPoint();
      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => PostMainScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero
      ), (route) => false);
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}