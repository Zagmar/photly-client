import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/ui/view/screen/large_image_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/logout_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_partner_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/user_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_daily_info_widget_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'amplifyconfiguration.dart';
import 'data/repository/auth_service.dart';

String _initialRoute = "";
late String username;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    _initialRoute = "/mainScreen";
  }
  else{
    _initialRoute = "/loginScreen";
  }


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) => LoginViewModel()),
      ChangeNotifierProvider(
          create: (BuildContext context) => UserViewModel()), // count_provider.dart
      ChangeNotifierProvider(
          create: (BuildContext context) => RegisterViewModel()),
      ChangeNotifierProvider(
          create: (BuildContext context) => PostViewModel()),
      ChangeNotifierProvider(
          create: (BuildContext context) => PostDailyInfoWidgetViewModel()),
      ChangeNotifierProvider(
          create: (BuildContext context) => DailyCouplePostViewModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ScreenUtil.init(context);
            // ScreenUtil.setContext(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          initialRoute: _initialRoute,
          routes: {
            // '/mainScreen': (context) => PostMainScreen(),
            '/mainScreen': (context) => LogoutScreen(),
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
      _initialRoute = "/mainScreen";
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