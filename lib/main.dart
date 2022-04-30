import 'package:couple_seflie_app/ui/view/screen/large_image_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_partner_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_daily_info_widget_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) => LoginViewModel()), // count_provider.dart
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
  )
);

class MyApp extends StatelessWidget {
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
            ScreenUtil.setContext(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          initialRoute: '/registerUsernameScreen',
          routes: {
            '/mainScreen': (context) => PostMainScreen(),
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
}