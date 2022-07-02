import 'package:couple_seflie_app/ui/view/screen/post/large_image_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../../view_model/post_view_model.dart';
import '../../widget/post/post_appbar_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';

bool _onPressed = false;

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
          physics: BouncingScrollPhysics(),
          primary: true,
          child: Column(
              children: <Widget>[
                PostScreensAppbar(
                  onTap: () {
                    if(_onPressed == false) {
                      _onPressed = true;
                      Navigator.of(context).pop((route) => PostMainScreen());
                      _onPressed = false;
                    }
                  },
                ),
                PostDailyInfoWidget(
                  bottomButton: _postViewModel.isEditable ?
                  RightTextButtonWidget(
                      onTap: (){
                        if(_onPressed == false) {
                          _onPressed = true;
                          FocusScope.of(context).unfocus();
                          Navigator.pushReplacement(context, PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => PostEditScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero
                          ),);
                          _onPressed = false;
                        }
                      },
                      buttonText: "편집"
                  )
                      :
                  null,
                ),
                PostDetailWidget(),
              ]
          ),
        ),
      ),
    );
  }
}

class PostDetailWidget extends StatelessWidget {
  late PostViewModel _postViewModel;
  PostDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      child: Column(
        children: <Widget>[
          /// 이미지
          Container(
            width: FULL_WIDTH.w,
            height: FULL_WIDTH.w * IMAGE_RATIO,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LargeImageScreen(), fullscreenDialog: true));
                  _onPressed = false;
                }
              },
              child: CachedNetworkImageWidget(
                  imageUrl: _postViewModel.post!.postImageUrl,
                  width: FULL_WIDTH.w,
                  height: FULL_WIDTH.w * IMAGE_RATIO
              ),
            ),
          ),
          /// 상세 텍스트
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        PostIconWidget(
                          iconData: Icons.place_outlined,
                        ),
                        Container(
                          width: 280.w,
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                            _postViewModel.post!.postLocation!,
                            style: TextStyle(
                                fontSize: 12.w,
                                fontWeight: FontWeight.w500,
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
                    PostWeatherImageWidget()
                  ],
                ),
                Container(height: 10.w,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _postViewModel.post!.postText == null || _postViewModel.post!.postText == "" ?
                      Container()
                          :
                      Text(
                        _postViewModel.post!.postText!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Container(height: 10.w,),
                      Text(
                        _postViewModel.dateTimeNow,
                        style: TextStyle(
                            fontSize: 10.w,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF808080)
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

class PostIconWidget extends StatelessWidget {
  final IconData iconData;
  const PostIconWidget({Key? key, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.w,
      width: 24.w,
      child: Container(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        child: Icon(
          iconData,
          size: 24.w,
          color: Color(0xFF292929),
        ),
      )
    );
  }
}

class PostWeatherImageWidget extends StatelessWidget {
  late PostViewModel _postViewModel;
  PostWeatherImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return SizedBox(
        height: 24.w,
        width: 24.w,
        child: Container(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          child: Image.asset(
            "assets/images/weather${_postViewModel.post!.postWeather.toString()}.png",
            height: 24.w,
            width: 24.w,
            color: Color(0xFF292929),
          ),
        )
    );
  }
}
