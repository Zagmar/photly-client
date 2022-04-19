import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool isMePostUploaded = false; // temp
bool isOtherPostUploaded = true; // temp

class PostMainScreen extends StatelessWidget {
  const PostMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            mainAppBar(),
            dailyInfoWidget(),
            dailyMePostWidget(),
            Container(
              height: 30.w,
            ),
            dailyOtherPostWidget(),
          ]
        ),
      ),
    );
  }

  /// 화면 분할 비율
  /// 295 : 1 : 94

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
                size: 24.w,
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
                        height: 20.w,
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
                Container(
                  height: 64.w,
                  child: Text(
                    // temp
                    "상대방을 생각하면 \n지어지는 표정",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontSize: 26.w,
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
      alignment: Alignment.center,
      child: isMePostUploaded == false ?
      /// 업로드 링크 연결
      InkWell(
        onTap: (){},
        child: Container(
          height: 80.w,
          width: 120.w,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.w,
                width: 24.w,
                child: Icon(
                  Icons.edit,
                ),
              ),
              Text(
                "내 답변 사진찍기",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "아직 답변을 하지 않았어요\n얼른 답변을 찍어보세요",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10.w,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      )
          :
      /// 내가 업로드한 이미지
      Row(
        children: <Widget>[
          InkWell(
            onTap: (){},
            child: Container(
              // temp - 사진 비율 4:3으로 임의 설정
              width: 295.w,
              height: 295.w * 3 / 4,
              child: CachedNetworkImage(
                // temp
                imageUrl: "https://pbs.twimg.com/media/D9P1_mlUYAApghf.jpg",
                width: 295.w,
                height: 295.w * 3 / 4,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: CircularProgressIndicator(value: downloadProgress.progress)
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 95.w,
          ),
        ],
      )
    );
  }

  /// Partner's Daily Post
  Widget dailyOtherPostWidget() {
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
      alignment: Alignment.center,
      child: isMePostUploaded == false ?
      Container(
        child: isOtherPostUploaded == false ?
        /// 상대 답변 기다리는 중 안내
        Container(
            height: 80.w,
            width: 220.w,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Icon(
                    Icons.hourglass_bottom_outlined,
                  ),
                ),
                Text(
                  "답변을 기다려요",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "아직 답변을 하지 않았어요\n나의 답변을 작성하고 상대방에게 답변을 요청해봐요.",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 10.w,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
            :
        /// Blur 처리된 이미지
        Container(
            height: 220.w,
            width: 390.w,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              // temp
              imageUrl: "https://file3.instiz.net/data/cached_img/upload/2021/07/16/3/7cede7a98eaff4c6047fedea6c6bca6d.jpg",
              height: 220.w,
              width: 390.w,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                    child: SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: CircularProgressIndicator(value: downloadProgress.progress)
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ).blurred(
              colorOpacity: 0.5,
              blur: 30,
              overlay: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24.w,
                    width: 24.w,
                    child: Icon(
                      Icons.check_circle_outline,
                    ),
                  ),
                  Text(
                    "답변 완료",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "상대방은 답변을 완료했어요\n얼른 답변하고 확인해보세요",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 10.w,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
      )
          :
      Container(
        child: isOtherPostUploaded == false ?
        /// 상대 답변 푸시 안내 버튼
        Container(
          height: 80.w,
          width: 120.w,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.w,
                width: 24.w,
                child: Icon(
                  Icons.notifications_outlined,
                ),
              ),
              Text(
                "답변 푸쉬하기",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "아직 답변을 하지 않았어요\n답변을 요청해보세요",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10.w,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
            :
        /// 상대가 업로드한 이미지
        Row(
          children: <Widget>[
            Container(
              width: 95.w,
            ),
            InkWell(
              onTap: (){},
              child: Container(
                // temp - 사진 비율 4:3으로 임의 설정
                width: 295.w,
                height: 295.w * 3 / 4,
                child: CachedNetworkImage(
                  // temp
                  imageUrl: "http://file3.instiz.net/data/cached_img/upload/2021/07/16/3/7cede7a98eaff4c6047fedea6c6bca6d.jpg",
                  width: 295.w,
                  height: 295.w * 3 / 4,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: CircularProgressIndicator(value: downloadProgress.progress)
                        ),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
