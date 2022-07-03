import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/choice_dialog_widget.dart';
import 'package:couple_seflie_app/ui/view/widget/loading_widget.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../theme/ui_setting.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../widget/post/post_daily_info_widget.dart';
import '../../widget/post/post_appbar_widget.dart';

bool _onPressed = false;

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
            physics: BouncingScrollPhysics(),
            child: Column(
                children: <Widget>[
                  PostScreensAppbar(
                    onTap: () async {
                      if(_onPressed == false) {
                        _onPressed = true;
                        await _postViewModel.clearAll();
                        Navigator.of(context).pop((route) => PostMainScreen());
                        _onPressed = false;
                      }
                    },
                  ),
                  PostDailyInfoWidget(
                    bottomButton: RightTextButtonWidget(
                      buttonText: "저장",
                      onTap: () async {
                        if(_onPressed == false) {
                          _onPressed = true;
                          FocusScope.of(context).unfocus();
                          await _postViewModel.checkIsPostOk();
                          //_postViewModel.isPostReady ?
                          _postViewModel.inputOk ?
                          {
                            await _postViewModel.postPost(),
                            //_postViewModel.isNewPost ?
                            //await _postViewModel.createPost() : await _postViewModel.editPost(),

                            //_postViewModel.isPostOk ?
                            _postViewModel.resultSuccess ?
                            {
                              await _dailyCouplePostViewModel.refreshTodayCouplePost(),
                              await _postViewModel.clearCheck(),
                              Navigator.pushReplacement(context, PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => PostDetailScreen(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero
                              ),),
                            }
                                :
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _postViewModel.resultMessage!
                                  //_postViewModel.postFailMessage!
                                ),
                              ),
                            ),
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _postViewModel.inputErrorMessage!
                                  //_postViewModel.postErrorMessage!
                              ),
                            ),
                          );
                          _onPressed = false;
                        }

                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      // Image area
                      Container(
                        width: FULL_WIDTH.w,
                        height: FULL_WIDTH.w * IMAGE_RATIO,
                        child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: (){
                              if(_onPressed == false) {
                                _onPressed = true;
                                FocusScope.of(context).unfocus();
                                // show dialog to pick the way to get image
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      bool _onPressed2 = false;
                                      return ThreeOptionsDialogWidget(
                                        title: "이미지 추가",
                                        // Get image from Gallery
                                        firstDialogOption: SingleDialogOption(
                                          dialogText: "갤러리에서 이미지 추가하기",
                                          onPressed: (){
                                            if(_onPressed2 == false) {
                                              _onPressed2 = true;
                                              Navigator.pop(context);
                                              _postViewModel.pickImage(ImageSource.gallery);
                                              _onPressed2 = false;
                                            }
                                          },
                                        ),
                                        // Take a picture with camera
                                        secondDialogOption: SingleDialogOption(
                                          dialogText: "카메라로 이미지 촬영하기",
                                          onPressed: (){
                                            if(_onPressed2 == false) {
                                              _onPressed2 = true;
                                              Navigator.pop(context);
                                              _postViewModel.pickImage(ImageSource.camera);
                                              _onPressed2 = false;
                                            }

                                          },
                                        ),
                                        // cancel
                                        thirdDialogOption: SingleDialogOption(
                                          dialogText: "취소",
                                          textColor: Colors.red,
                                          onPressed: (){
                                            if(_onPressed2 == false) {
                                              _onPressed2 = true;
                                              Navigator.pop(context);
                                              _onPressed2 = false;
                                            }
                                          },
                                        ),
                                      );
                                    }
                                );
                                _onPressed = false;
                              }
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
                        weatherButtonOnTap: (){
                          if(_onPressed == false) {
                            _onPressed = true;
                            FocusScope.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return WeatherDialogWidget();
                                }
                            );
                            _onPressed = false;
                          }
                        },
                        placeButtonOnTap: (){
                          if(_onPressed == false) {
                            _onPressed = true;
                            FocusScope.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return LocationDialogWidget();
                                }
                            );
                            _onPressed = false;
                          }
                        },
                        postInputTextOnChanged: (value) {
                          _postViewModel.setPostText(value);
                        },
                      )
                    ],
                  ),
                  //AddBannerWidget()
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
  final GestureTapCallback weatherButtonOnTap;
  final GestureTapCallback placeButtonOnTap;
  final ValueChanged<String> postInputTextOnChanged;
  late PostViewModel _postViewModel;
  PostTextFormWidget({Key? key, required this.weatherButtonOnTap, required this.placeButtonOnTap, required this.postInputTextOnChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: Column(
        children: <Widget>[
          _postViewModel.post!.postLocation == null || _postViewModel.post!.postLocation == ""?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Weather button
              InkWell(
                splashColor: Colors.transparent,
                onTap: weatherButtonOnTap,
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: Image.asset(
                    "assets/images/weather${(_postViewModel.post!.postWeather??0).toString()}.png",
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 10.w)),
              // Place button
              PostButtonWidget(
                onTap: placeButtonOnTap,
                iconData: Icons.place_outlined,
              ),
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
                  PostButtonWidget(
                    onTap: placeButtonOnTap,
                    iconData: Icons.place_outlined,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10.w)),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: placeButtonOnTap,
                    child: Text(
                      _postViewModel.post!.postLocation!,
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
              // Weather button
              InkWell(
                splashColor: Colors.transparent,
                onTap: weatherButtonOnTap,
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: Image.asset(
                    "assets/images/weather${(_postViewModel.post!.postWeather??0).toString()}.png",
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Container(height: 10.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.w),
                child: Icon(
                  Icons.edit,
                  size: 24.w,
                  color: Color(0xFF000000),
                ),
              ),
              Container(width: 10.w,),
              Container(
                width: 300.w,
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  initialValue: _postViewModel.post!.postText ?? "",
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
          Container(height: 10.w,),
          Container(
            margin: EdgeInsets.only(top: 10.w),
            alignment: Alignment.centerRight,
            child: Text(
              _postViewModel.dateTimeNow,
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
            shrinkWrap: false,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return WeatherButton(indexWeather: index);
            },
            itemCount: 4,
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
        splashColor: Colors.transparent,
        onTap: () {
          if(_onPressed == false) {
            _onPressed = true;
            Navigator.pop(context);
            Provider.of<PostViewModel>(context, listen: false).setPostWeather(indexWeather);
            _onPressed = false;
          }
        },
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: Image.asset(
            "assets/images/weather${(indexWeather).toString()}.png",
            width: 24.w,
            height: 24.w,
            fit: BoxFit.contain,
          ),
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
          fontSize: 16,
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
                  splashColor: Colors.transparent,
                  onTap: (){
                    if(_onPressed == false) {
                      _onPressed = true;
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                      _onPressed = false;
                    }

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

class PostButtonWidget extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback onTap;
  const PostButtonWidget({Key? key, required this.iconData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.w,
      width: 24.w,
      child: InkWell(
          splashColor: Colors.transparent,
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