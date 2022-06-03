import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/choice_dialog_widget.dart';
import 'package:couple_seflie_app/ui/view/widget/loading_widget.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../widget/ad_banner_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';
import '../../widget/post/post_appbar_widget.dart';

class PostEditScreen extends StatelessWidget {
  PostEditScreen({Key? key}) : super(key: key);
  late PostViewModel _postViewModel;
  late DailyCouplePostViewModel _dailyCouplePostViewModel;

  @override
  Widget build(BuildContext context) {
    _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context, listen: false);
    _postViewModel = Provider.of<PostViewModel>(context);

    return _postViewModel.loading ?
    LoadingScreen()
        :
    Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
                children: <Widget>[
                  PostScreensAppbar(
                    onTap: () {
                      _postViewModel.clearLocalImage();
                      Navigator.of(context).pop((route) => PostMainScreen());
                    },
                  ),
                  PostDailyInfoWidget(
                    bottomButton: TextButtonWidget(
                      buttonText: "저장",
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        await _postViewModel.checkIsPostOk();
                        _postViewModel.isPostReady ?
                        _postViewModel.isNewPost ?
                        await _postViewModel.createPost()
                            :
                        await _postViewModel.editPost()
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _postViewModel.postErrorMessage!
                            ),
                          ),
                        );
                        print("시도");

                        _postViewModel.isPostOk ?
                        {
                          await _dailyCouplePostViewModel.refreshTodayCouplePost(),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => PostDetailScreen()),
                          )
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _postViewModel.postFailMessage!
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      // Image area
                      Container(
                        width: 390.w,
                        height: 390.w * IMAGE_RATIO,
                        child: InkWell(
                            onTap: (){
                              FocusScope.of(context).unfocus();
                              // show dialog to pick the way to get image
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return ThreeOptionsDialogWidget(
                                        title: "이미지 추가",
                                        // Get image from Gallery
                                        firstDialogOption: SingleDialogOption(
                                          dialogText: "갤러리에서 이미지 추가하기",
                                          onPressed: (){
                                            Navigator.pop(context);
                                            _postViewModel.pickImage(ImageSource.gallery);
                                          },
                                        ),
                                        // Take a picture with camera
                                        secondDialogOption: SingleDialogOption(
                                          dialogText: "카메라로 이미지 촬영하기",
                                          onPressed: (){
                                            Navigator.pop(context);
                                            _postViewModel.pickImage(ImageSource.camera);
                                          },
                                        ),
                                        // cancel
                                        thirdDialogOption: SingleDialogOption(
                                          dialogText: "취소",
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        ),
                                    );
                                  }
                              );
                            },
                            child: _postViewModel.postImage != null ?
                            // Image from local
                            Image.file(
                              _postViewModel.postImage!,
                              width: 390.w,
                              height: 390.w * IMAGE_RATIO,
                              fit: BoxFit.cover,
                            )
                                :
                            _postViewModel.post!.postId != 0 ?
                            // Image from DB
                            CachedNetworkImageWidget(
                              imageUrl: _postViewModel.post!.postImageUrl,
                              width: 390,
                              height: 390 * IMAGE_RATIO,
                            )
                                :
                            // Default image
                            EmptyImageWidget()
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.w),
                        child: HorizontalBorder(),
                      ),
                      PostTextFormWidget(
                        initialPostText: _postViewModel.post!.postText,
                        weatherButtonOnTap: (){
                          FocusScope.of(context).unfocus();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return WeatherDialogWidget();
                              }
                          );
                        },
                        placeButtonOnTap: (){
                          FocusScope.of(context).unfocus();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return LocationDialogWidget();
                              }
                          );
                        },
                        postInputTextOnChanged: (value) {
                          _postViewModel.setPostText(value);
                        },
                        dateTimeNow: _postViewModel.dateTimeNow,
                        weatherImagePath: "images/weathers/x1/weather_${(_postViewModel.post!.postWeather??0).toString()}.png",
                      )
                    ],
                  ),
                  AddBannerWidget()
                ]
            ),
          ),
        ),
      ),
    );
  }
}

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit? boxFit;
  const CachedNetworkImageWidget({Key? key, required this.imageUrl, required this.width, required this.height, this.boxFit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width.w,
      height: height.w,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Center(
            child: SizedBox(
                width: 30.w,
                height: 30.w,
                child: CircularProgressIndicator(value: downloadProgress.progress)
            ),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: boxFit ?? BoxFit.cover,
    );
  }
}

class EmptyImageWidget extends StatelessWidget {
  const EmptyImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFF000000),
              width: 1.w
          )
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        size: 57.w,
        color: Color(0xFF000000),
      ),
    );
  }
}

class HorizontalBorder extends StatelessWidget {
  const HorizontalBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1.w,
        color: Color(0xFF000000)
    );
  }
}

class PostTextFormWidget extends StatelessWidget {
  final String? initialPostText;
  final String weatherImagePath;
  final String dateTimeNow;
  final GestureTapCallback weatherButtonOnTap;
  final GestureTapCallback placeButtonOnTap;
  final ValueChanged<String> postInputTextOnChanged;
  late PostViewModel _postViewModel;
  PostTextFormWidget({Key? key, this.initialPostText, required this.weatherImagePath, required this.dateTimeNow, required this.weatherButtonOnTap, required this.placeButtonOnTap, required this.postInputTextOnChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: <Widget>[
          _postViewModel.post!.postLocation == null || _postViewModel.post!.postLocation == ""?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Weather button
              InkWell(
                onTap: weatherButtonOnTap,
                child: Image.asset(
                  weatherImagePath,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 10.w)),
              // Place button
              InkWell(
                onTap: placeButtonOnTap,
                child: Image.asset(
                  "images/icons/icon_map_pin/map_pin_1.png",
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              )
            ],
          )
              :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Place button
                  InkWell(
                    onTap: placeButtonOnTap,
                    child: Image.asset(
                      "images/icons/icon_map_pin/map_pin_1.png",
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10.w)),
                  Text(
                    _postViewModel.post!.postLocation!,
                    style: TextStyle(
                      fontSize: 15.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              // Weather button
              InkWell(
                onTap: weatherButtonOnTap,
                child: Image.asset(
                  weatherImagePath,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 5.w)),
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
                child: TextFormField(
                  initialValue: initialPostText ?? "",
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "오늘의 한 마디",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.w,
                          color: Color(0xFFC4C4C4)
                      ),
                  ),
                  onChanged: postInputTextOnChanged,
                  maxLines: null,
                  maxLength: 50,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.w),
            alignment: Alignment.centerRight,
            child: Text(
              dateTimeNow,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 10.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF444444)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDialogWidget extends StatelessWidget {
  const WeatherDialogWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _nWeathers = Provider.of<PostViewModel>(context).nWeather;
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "날씨를 기록해보세요",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 40.w,
          width: 200.w,
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return WeatherButton(indexWeather: index);
            },
            itemCount: _nWeathers,
          ),
        )
      ],
    );
  }
}

class WeatherButton extends StatelessWidget {
  final int indexWeather;
  const WeatherButton({Key? key, required this.indexWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Provider.of<PostViewModel>(context, listen: false).setPostWeather(indexWeather);
        },
        child: Image.asset(
          "images/weathers/x1/weather_${indexWeather.toString()}.png",
          width: 35.w,
          height: 35.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class LocationDialogWidget extends StatelessWidget {
  LocationDialogWidget({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  late PostViewModel _postViewModel;

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "장소를 기록해주세요",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInputWidget(
                  initialValue: _postViewModel.post!.postLocation,
                  maxLines: 1,
                  maxLength: 8,
                  obscureText: false,
                  onFieldSubmitted: (value) async {
                    await _postViewModel.setLocation(value??"");
                  },
                  onSaved: (value) async {
                    await _postViewModel.setLocation(value??"");
                  },
                ),
                InkWell(
                  onTap: (){
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: Color(0xFF050505),
                    ),
                    margin: EdgeInsets.only(top: 10.w),
                    width: 390.w,
                    height: 50.w,
                    alignment: Alignment.center,
                    child: Text(
                      "위치 등록",
                      style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE5E5E5)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}