import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/post/post_appbar_widget.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "서비스 문의",
          style:  Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: SingleButton(
              icon: Icons.clear,
              onTap: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "서비스 관련 문의는\n아래 연락처로 직접 문의 부탁드립니다\n\n이메일: team.zagmar@gmail.com",
          style: TextStyle(
            fontSize: 16.w,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
