import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/post/post_appbar_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          primary: true,
          child: Container(
            child: Column(
                children: <Widget>[
                  postAppBarWidget("/postDetailScreen", context),
                  postDailyInfoWidget("/postDetailScreen", context),
                  postDetailWidget(),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget postDetailWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      child: Column(
        children: <Widget>[
          /// 이미지
          Container(
            width: 390.w,
            height: 390.w * 3 / 4,
            child: InkWell(
              onTap: (){
                // temp
                /// detail image
              },
              child: CachedNetworkImage(
                // temp
                imageUrl: "https://pbs.twimg.com/media/D9P1_mlUYAApghf.jpg",
                width: 390.w,
                height: 390.w * 3 / 4,
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
          /// 상세 텍스트
          Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30.w,
                          width: 30.w,
                          child: IconButton(
                              onPressed: (){},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.place_outlined,
                                size: 24.w,
                                color: Color(0xFFAAAAAA),
                              )
                          ),
                        ),
                        Container(
                          width: 280.w,
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text(
                            // temp
                            "서울시 마포구",
                            style: TextStyle(
                              fontSize: 13.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000)
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.w,
                      width: 30.w,
                      // temp
                      child: IconButton(
                        onPressed: (){},
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.wb_sunny_outlined,
                          size: 24.w,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 80.w,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // temp
                        "널 생각하면 기분이 좋아",
                        style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000)
                        ),
                      ),
                      Text(
                        // temp
                        "오후 11시 30분",
                        style: TextStyle(
                            fontSize: 9.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFC4C4C4)
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
