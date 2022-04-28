import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../widget/ad_banner_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';
import '../../widget/post/post_appbar_widget.dart';

class PostEditScreen extends StatelessWidget {
  PostEditScreen({Key? key}) : super(key: key);
  late PostViewModel _postViewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostViewModel(),
      child: postEditMainWidget(context),
    );
  }

  Widget postEditMainWidget(BuildContext context){
    _postViewModel = Provider.of<PostViewModel>(context);
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
                    postEditWidget(context),
                    adBannerWidget()
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget postEditWidget(BuildContext context) {
    TextEditingController textController = TextEditingController()..text = _postViewModel.post.postText ?? ""; // temp
    // TextEditingController _locateController = TextEditingController();
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      child: Column(
        children: <Widget>[
          Container(
            width: 390.w,
            height: 390.w * IMAGE_RATIO,
            child: InkWell(
              onTap: (){
                FocusScope.of(context).unfocus();
                getImageDialogWidget(context);
              },
              child: _postViewModel.post.postId != "" ?
              CachedNetworkImage(
                imageUrl: _postViewModel.post.postImageUrl,
                width: 390.w,
                height: 390.w * IMAGE_RATIO,
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
              )
                  :
              _postViewModel.postImage == null ?
              Container(
                width: 100.w,
                height: 100.w,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 57.w,
                  color: Color(0xFFFFFFFF),
                ),
              )
                  :
              Image.file(
                _postViewModel.postImage!,
                width: 390.w,
                height: 390.w * IMAGE_RATIO,
                fit: BoxFit.cover,
              )
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
                            labelText: "오늘의 한 마디",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.w,
                              color: Color(0xFFC4C4C4)
                            )
                        ),
                        // temp
                        maxLines: null,
                        maxLength: 50,
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
                    DateFormat(TIME_FORMAT, krLocale).format(DateTime.now()), // temp
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

  // Dialog to select from gallery or take a photo via camera
  getImageDialogWidget(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "이미지 추가",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              // Select from gallery
              SimpleDialogOption(
                child: Text(
                  "갤러리에서 이미지 추가하기",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: (){
                  _postViewModel.pickImage("gallery");
                },
              ),
              // Take a photo via camera
              SimpleDialogOption(
                child: Text(
                  "카메라로 이미지 촬영하기",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: (){
                  _postViewModel.pickImage("camera");
                },
              ),
              // Cancel
              SimpleDialogOption(
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}
