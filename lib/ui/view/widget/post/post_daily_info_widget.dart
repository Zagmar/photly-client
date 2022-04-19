import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool isMyPost = true; // temp
bool isToday = true;

/// 화면 분할 비율
/// 295 : 1 : 94

/// 날짜, 제시 질문, 이모티콘 등의 상단 위젯
Widget postDailyInfoWidget(String screen, BuildContext context) {
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
              /// provider를 통해 값 관리
              Container(
                width: 48.w,
                height: 90.w,
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
                          fontSize: 18.w,
                          fontStyle: FontStyle.normal,
                          //fontFamily:
                          //height: 24.w
                        ),
                      ),
                    ),
                    /// month
                    Container(
                      alignment: Alignment.center,
                      height: 15.w,
                      child: Text(
                        // temp
                        "March",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.w,
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
                          fontSize: 30.w,
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
              /// provider를 통해 값 관리
              Container(
                height: 65.w,
                child: Text(
                  // temp
                  "상대방을 생각하면 \n지어지는 표정",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontSize: 24.w,
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
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 40.w),
          child: screen == "/postEditScreen" ?
          /// 저장 버튼
          Container(
            width: 34.w,
            height: 24.w,
            child: TextButton(
              onPressed: (){
                FocusScope.of(context).unfocus();
                // temp
                Navigator.popAndPushNamed(context, '/postDetailScreen');
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero, // Set this
                padding: EdgeInsets.zero, // and this
              ),
              child: Text(
                "저장",
                style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000)
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
              :
          screen != "/postDetailScreen" ?
          Container()
              :
          isMyPost == true && isToday == true ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: (){
                  FocusScope.of(context).unfocus();
                  // temp
                  /// 사진 다운로드
                },
                icon: Icon(
                  Icons.save_alt_outlined,
                  size: 37.w,
                  color: Color(0xFF666666),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 35.w),
                width: 34.w,
                height: 24.w,
                child: TextButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    // temp
                    Navigator.popAndPushNamed(context, '/postEditScreen');
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero, // Set this
                    padding: EdgeInsets.zero, // and this
                  ),
                  child: Text(
                    "편집",
                    style: TextStyle(
                        fontSize: 18.w,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )
              :
          IconButton(
            onPressed: (){
  FocusScope.of(context).unfocus();
  // temp
  /// 사진 다운로드
  },
    icon: Icon(
      Icons.save_alt_outlined,
      size: 37.w,
      color: Color(0xFF666666),
    ),
  ),
        ),
      ],
    ),
  );
}