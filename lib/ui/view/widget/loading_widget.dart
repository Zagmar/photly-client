import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("loadingScreen 실행");
    return Center(
      child:  SizedBox(
          width: 30.w,
          height: 30.w,
          child: CircularProgressIndicator()
      ),
    );
  }
}
