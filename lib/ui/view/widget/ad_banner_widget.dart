import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddBannerWidget extends StatelessWidget {
  const AddBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 50.w * 390 / 320,
      color: Colors.greenAccent,
    );
  }
}