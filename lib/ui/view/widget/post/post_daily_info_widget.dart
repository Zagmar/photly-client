import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';

/// Screen Split Ratio
/// 295 : 1 : 94

/// Top widgets: date, suggested question, emoji
Widget postDailyInfoWidget(BuildContext context) {
  final PostViewModel _postViewModel = Provider.of<PostViewModel>(context);
  final DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
  return ChangeNotifierProvider(
    create: (_) => DailyCouplePostViewModel(),
    child: Container(
      width: 390.w,
      height: 190.w,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          /// Date
          Container(
            width: 275.w,
            margin: EdgeInsets.only(bottom: 30.w),
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// 날짜 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 90.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /// year
                          Container(
                            height: 24.w,
                            color: Color(0xFF000000),
                            alignment: Alignment.center,
                            child: Text(
                              _dailyCouplePostViewModel.year,
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
                              _dailyCouplePostViewModel.month,
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
                              _dailyCouplePostViewModel.day,
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
                    _dailyCouplePostViewModel.questionType == 0 ?
                    Container()
                        :
                    Container(
                      width: 90.w,
                      height: 90.w,
                      child: CachedNetworkImage(
                        imageUrl: _dailyCouplePostViewModel.questionImageUrl!,
                        width: 90.w,
                        height: 90.w,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(
                              child: SizedBox(
                                  width: 15.w,
                                  height: 15.w,
                                  child: CircularProgressIndicator(value: downloadProgress.progress)
                              ),
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline_outlined),
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
                /// 해당 날짜의 질문
                Container(
                  height: 65.w,
                  child: Text(
                    _dailyCouplePostViewModel.questionText,
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
            child: _dailyCouplePostViewModel.screen == "/postEditScreen" ?
            /// PostEditScreen -> Save Post Button
            Container(
              width: 34.w,
              height: 24.w,
              child: TextButton(
                onPressed: (){
                  FocusScope.of(context).unfocus();
                  print("저장");
                  if(_postViewModel.postId == ""){
                    _postViewModel.createPost(_postViewModel.post);
                  }
                  else{
                    _postViewModel.editPost(_postViewModel.post);
                  }
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
            _dailyCouplePostViewModel.screen != "/postDetailScreen" ?
            /// DailyCouplePostScreen -> Empty
            Container()
                :
            /// PostDetailScreen ->
            _dailyCouplePostViewModel.isMyPost == true && _dailyCouplePostViewModel.isToday == true ?
            /// is my post & is today -> Download & Edit Button
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
            /// is not my post | is not today -> Download Button
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
    ),
  );
}