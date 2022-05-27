import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../../view_model/post_view_model.dart';
import '../../widget/post/post_appbar_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';

class PostDetailScreen extends StatelessWidget {
  late PostViewModel _postViewModel;
  PostDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          primary: true,
          child: Column(
              children: <Widget>[
                PostScreensAppbar(),
                PostDailyInfoWidget(
                  topButton: IconButtonWidget(
                    iconData: Icons.save_alt_outlined,
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      // temp
                      /// 사진 다운로드
                    },
                  ),
                  // bottomButton: _dailyCouplePostViewModel.isUserDone == true && _dailyCouplePostViewModel.isToday == true ?
                  bottomButton: _postViewModel.post!.postUserId == _postViewModel.currentUserId && _postViewModel.post!.postEditTime.year == DateTime.now().year && _postViewModel.post!.postEditTime.month == DateTime.now().month && _postViewModel.post!.postEditTime.day == DateTime.now().day ?
                  TextButtonWidget(
                      onTap: (){
                        FocusScope.of(context).unfocus();
                        print("누름");
                        // temp
                        Navigator.popAndPushNamed(context, '/postEditScreen');
                      },
                      buttonText: "편집"
                  )
                      :
                  Container(),
                ),
                postDetailWidget(),
              ]
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
            height: 390.w * IMAGE_RATIO,
            child: InkWell(
              onTap: (){
                _postViewModel.setTempImageUrl(_postViewModel.post!.postImageUrl);
                //Navigator.pushNamed(context, "/largeImageScreen");
              },
              child: CashedNetworkImageWidget(
                  imageUrl: _postViewModel.post!.postImageUrl,
                  width: 390.w,
                  height: 390.w * IMAGE_RATIO
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
                    _postViewModel.post!.postLocation != null ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        PostButtonWidget(
                            iconData: Icons.place_outlined,
                            onTap: (){}
                        ),
                        Container(
                          width: 280.w,
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text(
                            _postViewModel.post!.postLocation!,
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
                    )
                        :
                    Container(),
                    PostButtonWidget(
                        iconData: Icons.wb_sunny_outlined,
                        onTap: (){}
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
                        _postViewModel.post!.postText ?? "",
                        style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF000000)
                        ),
                      ),
                      Text(
                        // 오후 1시 30분
                        _postViewModel.dateTimeNow,
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

class PostButtonWidget extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback onTap;
  const PostButtonWidget({Key? key, required this.iconData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.w,
      width: 30.w,
      child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            child: Icon(
              iconData,
              size: 24.w,
              color: Color(0xFF292929),
            ),
          )
      ),
    );
  }
}
