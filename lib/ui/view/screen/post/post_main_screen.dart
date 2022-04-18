import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostMainScreen extends StatelessWidget {
  const PostMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            mainAppBar(),
            dailyInfoWidget(),
            dailyMePostWidget(),
            Container(
              height: 30.w,
            ),
            dailyYouPostWidget(),
          ]
        ),
      ),
    );
  }

  /// Main Appbar
  /// 기존 앱바는 커스텀이 어려워 Widget으로 만들어 사용
  Widget mainAppBar() {
    return Container(
      height: 90.w,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          Container(
            width: 275.w,
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.only(left: 0),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.menu,
                color: Color(0xFF667080),
                size: 24.sp,
              ),
              onPressed: () {  },
            ),
          ),
          Container(
            color: Color(0xFF000000),
            width: 1.w,
          ),
          Container(
            width: 94.w,
          ),
        ],
      ),
    );
  }

  /// 날짜, 제시 질문, 이모티콘 등의 상단 위젯
  Widget dailyInfoWidget() {
    return Container(
      width: 390.w,
      height: 190.w,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          Container(
            width: 275.w,
            margin: EdgeInsets.only(bottom: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// 날짜 정보
                Container(
                  width: 48.w,
                  height: 94.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /// year
                      Container(
                        width: 48.w,
                        height: 24.w,
                        color: Color(0xFF000000),
                        alignment: Alignment.center,
                        child: Text(
                          // temp
                          "2022",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              fontStyle: FontStyle.normal,
                              //fontFamily:
                              //height: 24.w
                          ),
                        ),
                      ),
                      /// month
                      Container(
                        alignment: Alignment.center,
                        height: 20.w,
                        child: Text(
                          // temp
                          "March",
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              fontStyle: FontStyle.normal,
                              //height: 12.w
                              //fontFamily:
                          ),
                        ),
                      ),
                      /// day
                      Container(
                        height: 45.w,
                        alignment: Alignment.center,
                        child: Text(
                          // temp
                          "27",
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontSize: 30.sp,
                              fontStyle: FontStyle.normal,
                              //height: 45.w
                              //fontFamily:
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1.w,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                /// 해당 날짜의 질문
                Container(
                  height: 64.w,
                  child: Text(
                    // temp
                    "상대방을 생각하면 \n지어지는 표정",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontSize: 26.sp,
                      fontStyle: FontStyle.normal,
                      //fontFamily:
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Color(0xFF000000),
            width: 1.w,
          ),
          Container(
            width: 94.w,

          ),
        ],
      ),
    );
  }

  /// My Daily Post
  Widget dailyMePostWidget() {
    return Container(
      height: 220.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.w,
              color: Color(0xFF000000)
          ),
          bottom: BorderSide(
              width: 1.w,
              color: Color(0xFF000000)
          ),
        ),
      ),
    );
  }

  /// Partner's Daily Post
  Widget dailyYouPostWidget() {
    return Container(
      height: 220.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.w,
              color: Color(0xFF000000)
          ),
          bottom: BorderSide(
              width: 1.w,
              color: Color(0xFF000000)
          ),
        ),
      ),
    );
  }
}
