import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/choice_dialog_widget.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late TextEditingController _postTextController;

  @override
  Widget build(BuildContext context) {
    DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
    _postViewModel = Provider.of<PostViewModel>(context);
    _postTextController = TextEditingController()..text = _postViewModel.post.postText ?? ""; // temp
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Container(
              child: Column(
                  children: <Widget>[
                    PostScreensAppbar(),
                    PostDailyInfoWidget(
                      bottomButton: TextButtonWidget(
                        buttonText: "저장",
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          print("저장");
                          if(_postViewModel.postId == ""){
                            _postViewModel.createPost(_postViewModel.post);
                          }
                          else{
                            _postViewModel.editPost(_postViewModel.post);
                          }
                          // temp
                          //Navigator.popAndPushNamed(context, '/postDetailScreen');
                          Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => PostDetailScreen()),
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
                                              _postViewModel.pickImage("gallery");
                                            },
                                          ),
                                          // Take a picture with camera
                                          secondDialogOption: SingleDialogOption(
                                            dialogText: "카메라로 이미지 촬영하기",
                                            onPressed: (){
                                              Navigator.pop(context);
                                              _postViewModel.pickImage("camera");
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
                              _postViewModel.post.postId != "" ?
                              // Image from DB
                              CashedNetworkImageWidget(
                                imageUrl: _postViewModel.post.postImageUrl,
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
                          initialPostText: _postViewModel.post.postText,
                          weatherButtonOnTap: (){
                            Focus.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return WeatherDialogWidget(nWeathers: 3);
                                }
                            );
                          },
                          placeButtonOnTap: (){
                            Focus.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return LocationDialogWidget();
                                }
                            );
                            // temp
                            // 장소 추가 dialog
                          },
                          postInputTextOnChanged: (value) {
                            _postViewModel.setPostText(value);
                          },
                          dateTimeNow: _postViewModel.dateTimeNow,
                          weatherImagePath: "assets/images/weathers/weather_" + (_postViewModel.post.postWeather ?? 0).toString() + ".svg",
                        )
                      ],
                    ),
                    AddBannerWidget()
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  Widget postEditWidget() {
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
                FocusScope.of(_context).unfocus();
                getImageDialogWidget();
              },
              child: _postViewModel.postImage != null ?
              Image.file(
                _postViewModel.postImage!,
                width: 390.w,
                height: 390.w * IMAGE_RATIO,
                fit: BoxFit.cover,
              )
                :
              _postViewModel.post.postId != "" ?
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF000000),
                    width: 1.w
                  )
                ),
                width: 100.w,
                height: 100.w,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 57.w,
                  color: Color(0xFF000000),
                ),
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
                            hintText: "오늘의 한 마디",
                            hintStyle: TextStyle(
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
                    _postViewModel.dateTimeNow,
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
  getImageDialogWidget() {
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
                  Navigator.pop(_context);
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
                  Navigator.pop(_context);
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
                  Navigator.pop(_context);
                },
              )
            ],
          );
        }
    );
  }

   */
}

class CashedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit? boxFit;
  const CashedNetworkImageWidget({Key? key, required this.imageUrl, required this.width, required this.height, this.boxFit}) : super(key: key);

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
  final Function postInputTextOnChanged;
  late TextEditingController _postTextController;
  PostTextFormWidget({Key? key, this.initialPostText, required this.weatherImagePath, required this.dateTimeNow, required this.weatherButtonOnTap, required this.placeButtonOnTap, required this.postInputTextOnChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postTextController = TextEditingController()..text = initialPostText ?? "";
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Weather button
            InkWell(
              onTap: () => weatherButtonOnTap,
              child: SvgPicture.asset(
                weatherImagePath,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
            ),
            // Place button
            InkWell(
              onTap: () => placeButtonOnTap,
              child: Icon(
                Icons.place_outlined,
                size: 24.w,
                color: Color(0xFFAAAAAA),
              ),
            )
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
                controller: _postTextController,
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
                onChanged: (value) => postInputTextOnChanged,
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
            dateTimeNow,
            style: TextStyle(
                fontSize: 9.w,
                fontWeight: FontWeight.w400,
                color: Color(0xFFC4C4C4)
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherDialogWidget extends StatelessWidget {
  final int nWeathers;
  const WeatherDialogWidget({Key? key,  required this.nWeathers, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "날씨 선택",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: nWeathers,
            itemBuilder: (BuildContext context, int index) {
              return WeatherButton(indexWeather: index);
            },
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
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Provider.of<PostViewModel>(context).setPostWeather(indexWeather);
      },
      child: SvgPicture.asset(
        "assets/images/weathers/weather_" + indexWeather.toString() + ".svg",
        width: 24.w,
        height: 24.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class LocationDialogWidget extends StatelessWidget {
  const LocationDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        TextInputWidget(
            maxLines: 1,
            maxLength: 8,
            obscureText: false,
            onFieldSubmitted: (value) {
              Provider.of<PostViewModel>(context).setPostLocation(value);
            }
        )
      ],
    );
  }
}