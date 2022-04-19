import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(MyApp());

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
            backgroundColor: Colors.white,
            primaryColor: Colors.blueGrey,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.white,
          ),
          builder: (context, child) {
            ScreenUtil.setContext(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          initialRoute: '/mainScreen',
          routes: {
            '/mainScreen': (context) => PostMainScreen(),
            '/postEditScreen': (context) => PostEditScreen(),
            '/postDetailScreen': (context) => PostDetailScreen(),
          },
        )
    );
  }
}