import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Main Appbar
/// 기존 앱바는 스크롤시에 Widget으로 만들어 사용
Widget postAppBarWidget(String screen, BuildContext context) {
  return Container(
    height: 90.w,
    padding: EdgeInsets.only(left: 20.w),
    child: Row(
      children: <Widget>[
        Container(
          width: 275.w,
          alignment: Alignment.centerLeft,
          child: screen == "/mainScreen" ?
          IconButton(
            padding: EdgeInsets.only(left: 0, top: 0),
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.menu,
              color: Color(0xFF667080),
              size: 24.w,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              // temp
              /// show menu
            },
          )
              :
          Container(),
        ),
        Container(
          color: Color(0xFF000000),
          width: 1.w,
        ),
        Container(
          width: 94.w,
          child: screen == "/mainScreen" ?
          Container()
              :
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Color(0xFF666666),
              size: 24.w,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop((route) => route.settings.name == "/mainScreen");
            },
          ),
        ),
      ],
    ),
  );
}