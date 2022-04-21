import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/adBannerWidget.dart';
import '../../widget/post/post_daily_info_widget.dart';
import '../../widget/post/post_appbar_widget.dart';

bool isMyPostUploaded = false; // temp

class PostEditScreen extends StatelessWidget {
  PostEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(

            child: Container(
              child: Column(
                  children: <Widget>[
                    postAppBarWidget("/postEditScreen", context),
                    postDailyInfoWidget("/postEditScreen", context),
                    postEditWidget(),
                    adBannerWidget()
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget postEditWidget() {
    String text = "널 생각하면"; // temp
    TextEditingController textController = TextEditingController()..text = text; // temp
    // TextEditingController _locateController = TextEditingController();
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      child: Column(
        children: <Widget>[
          Container(
            width: 390.w,
            height: 390.w * 3 / 4,
            child: isMyPostUploaded == false ?
            Container(
              color: Color(0xFFC4C4C4),
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  // temp
                  /// add image
                },
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  child: Icon(
                    Icons.add,
                    size: 57.w,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            )
                :
            InkWell(
              onTap: (){
                // temp
                /// detail page
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
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1.w,
                    color: Color(0xFF000000)
                ),
              )
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Icon(
                        Icons.edit,
                        size: 24.w,
                        color: Color(0xFF141414),
                      ),
                    ),
                    Container(
                      width: 320.w,
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelText: "남기고 싶은 메모가 있다면 작성해주세요",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.w,
                              color: Color(0xFFC4C4C4)
                            )
                        ),
                        // temp
                        maxLines: null,
                        maxLength: 50,
                        onChanged: (_) {
                          text = textController.text;
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 26.w),
                  child: Text(
                    // temp
                    "오후 11시 30분",
                    style: TextStyle(
                      fontSize: 9.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFC4C4C4)
                    ),
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
