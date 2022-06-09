import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("splash Screen 실행");
    return Container(
      color: Theme.of(context).splashColor,
      child: Center(
        child:  SizedBox(
            width: 100.w,
            height: 100.w,
            child: Image.asset(
              "assets/images/splashIcon.png",
              width: 100.w,
              height: 100.w,
              fit: BoxFit.contain,
            )
        ),
      ),
    );
  }
}
