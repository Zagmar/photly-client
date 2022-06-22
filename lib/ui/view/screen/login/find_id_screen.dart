import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/route_button_widgets.dart';

class FindIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Text(
                  "ID 찾기는 아래 연락처로 직접 문의 부탁드립니다\n관리자 : rjsgy0815",
                style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
              LeftButtonOnlyWidget(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
                buttonText: "이전",
              )
            ],
          ),
        ),
      ),
    );
  }
}
