import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_daily_info_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/register1_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'amplifyconfiguration.dart';
import 'data/repository/auth_service.dart';

String _initialRoute = "";
bool _isLogined = false;
late String username;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ScreenUtil.ensureScreenSize();

  // Add the Amplify category plugins, plugins should
  // be added here in order for configuration to work
  // DO NOT add plugins that you haven't configured via
  // the Amplify CLI. This will throw a configuration error.
  Amplify.addPlugins([AmplifyAuthCognito()]);

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

  final AuthFlowStatus authFlowStatus = await AuthService().checkAuthStatusService();
  if(authFlowStatus == AuthFlowStatus.session) {
    _initialRoute = "/postMainScreen";
    _isLogined = true;
  }
  else{
    _initialRoute = "/loginScreen";
    _isLogined = false;
  }

  print("초기 설정 준비");
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> DailyCouplePostViewModel(),),
        ChangeNotifierProvider(create: (context)=> PostDailyInfoViewModel(),),
        ChangeNotifierProvider(create: (context)=> PostViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => Register1ViewModel()),
      ],
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("MyApp 실행");
    return ScreenUtilInit(
        splitScreenMode: false,
        designSize: const Size(390, 840),
        builder: (_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Photly',
          theme: ThemeData(
            fontFamily: 'Noto_Sans_KR',
            brightness: Brightness.light,
            backgroundColor: Color(0xFFFFFFFF),
            primaryColor: Colors.blueGrey,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Color(0xFFFFFFFF),
          ),
          home: _isLogined ?
          PostMainScreen()
              :
          LoginScreen(),
        )
    );
  }

  /*
  // Init AWS amplify
  void _configureAmplify() async {
    _amplify.addPlugins([AmplifyAuthCognito()]);
    final AuthFlowStatus authFlowStatus = await AuthService().checkAuthStatusService();
    if(authFlowStatus == AuthFlowStatus.session) {
      _initialRoute = "/postMainScreen";
    }
    else{
      _initialRoute = "/loginScreen";
    }
    try {
      await _amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } on AmplifyAlreadyConfiguredException {
      print("Amplify was already configured. Looks like app restarted on android.");
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }

   */
}
/*
class MyApp extends StatelessWidget {
  late DailyCouplePostViewModel _dailyCouplePostViewModel;
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("실행 한 번만");
    print("초기 설정 완료");
    return ScreenUtilInit(
        splitScreenMode: false,
        designSize: const Size(390, 840),
        builder: (_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Photly',
          theme: ThemeData(
            fontFamily: 'Noto_Sans_KR',
            brightness: Brightness.light,
            backgroundColor: Color(0xFFFFFFFF),
            primaryColor: Colors.blueGrey,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Color(0xFFFFFFFF),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          initialRoute: _initialRoute,
          routes: {
            '/postMainScreen': (context) => PostMainScreen(),
            '/postEditScreen': (context) => PostEditScreen(),
            '/postDetailScreen': (context) => PostDetailScreen(),
            '/largeImageScreen': (context) => LargeImageScreen(),
            '/loginScreen': (context) => LoginScreen(),
            '/findIdScreen': (context) => FindIdScreen(),
            '/findPwScreen': (context) => FindPwScreen(),
            '/registerScreen': (context) => RegisterScreen(),
            '/registerUsernameScreen': (context) => RegisterUsernameScreen(),
            '/registerPartnerScreen': (context) => RegisterPartnerScreen(),
            '/registerAnniversaryScreen': (context) => RegisterAnniversaryScreen(),
          },
        )
    );
  }

  /*
  // Init AWS amplify
  void _configureAmplify() async {
    _amplify.addPlugins([AmplifyAuthCognito()]);
    final AuthFlowStatus authFlowStatus = await AuthService().checkAuthStatusService();
    if(authFlowStatus == AuthFlowStatus.session) {
      _initialRoute = "/postMainScreen";
    }
    else{
      _initialRoute = "/loginScreen";
    }
    try {
      await _amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } on AmplifyAlreadyConfiguredException {
      print("Amplify was already configured. Looks like app restarted on android.");
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }

   */
}

 */