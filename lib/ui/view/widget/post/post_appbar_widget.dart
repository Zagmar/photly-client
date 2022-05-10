import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';

/// Main Appbar
/// 기존 앱바는 스크롤시에 사라지지 않아 Widget으로 만들어 사용
Widget postAppBarWidget(BuildContext context, _scaffoldKey) {
  final DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
  print("2호출");
  print(_dailyCouplePostViewModel.screen);
  return ChangeNotifierProvider(
    create: (_) => DailyCouplePostViewModel(),
    child: Container(
      height: 90.w,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          Container(
            width: 275.w,
            alignment: Alignment.centerLeft,
            child: _dailyCouplePostViewModel.screen == "/dailyCouplePostScreen" ?
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
                _scaffoldKey.currentState?.openDrawer();
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
            child: _dailyCouplePostViewModel.screen == "/dailyCouplePostScreen" ?
            Container()
                :
            IconButton(
              icon: Icon(
                  Icons.clear,
                  size: 37.w,
                  color: Color(0xFF666666)
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop((route) => route.settings.name == "/dailyCouplePostScreen");
              },
            ),
          ),
        ],
      ),
    ),
  );
}