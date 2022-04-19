import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/model/post_model.dart';
import '../../widget/post/post_daily_info_widget.dart';
import '../../widget/post/post_appbar_widget.dart';

bool isMyPostUploaded = true; // temp
bool isPartnerPostUploaded = true; // temp
List<DailyCouplePostModel> dailyPosts = [];

class PostMainScreen extends StatelessWidget {
  const PostMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              postAppBarWidget("/mainScreen", context),
              postDailyInfoWidget("/mainScreen", context),
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: PageController(initialPage: dailyPosts.length),
                itemCount: dailyPosts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      dailyMyPostWidget(context),
                      Container(
                        height: 30.w,
                      ),
                      dailyPartnerPostWidget(context),
                    ],
                  );
                }
              )
            ]
          ),
        ),
      ),
    );
  }

  /// 화면 분할 비율
  /// 295 : 1 : 94

  /// My Daily Post
  Widget dailyMyPostWidget(BuildContext context) {
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
      child: isMyPostUploaded == false ?
      /// 업로드 페이지
      InkWell(
        onTap: (){
          FocusScope.of(context).unfocus();
          Navigator.pushNamed(context, '/postEditScreen');
        },
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
            onTap: (){
              // temp
              Navigator.pushNamed(context, "/postDetailScreen");
            },
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
  Widget dailyPartnerPostWidget(BuildContext context) {
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
      child: isMyPostUploaded == false ?
      Container(
        child: isPartnerPostUploaded == false ?
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
        child: isPartnerPostUploaded == false ?
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
              onTap: (){
                // temp
                Navigator.pushNamed(context, "/postDetailScreen");
              },
              child: Container(
                // temp - 사진 비율 4:3으로 임의 설정
                width: 295.w,
                height: 295.w * 3 / 4,
                child: CachedNetworkImage(
                  // temp
                  imageUrl: "https://file3.instiz.net/data/cached_img/upload/2021/07/16/3/7cede7a98eaff4c6047fedea6c6bca6d.jpg",
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
