import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/theme/ui_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/daily_couple_post_model.dart';
import '../../../view_model/daily_couple_post_view_model.dart';

/// Screen Split Ratio
/// 292 : 1 : 82

/// Top widgets: date, suggested question, emoji
class PostDailyInfoWidget extends StatelessWidget {
  final Widget? topButton;
  final Widget? bottomButton;

  const PostDailyInfoWidget({Key? key, this.topButton, this.bottomButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PostDailyInfoWidget 실행");
    final DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
    return Container(
      width: FULL_WIDTH.w,
      height: 205.w,
      child: Row(
        children: <Widget>[
          Container(
            width: MAIN_SPACE_WIDTH.w,
            padding: EdgeInsets.only(left: 30.w,right: 20.w),
            margin: EdgeInsets.only(top: 10.w,bottom: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Container(
                      width: 50.w,
                      height: 120.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /// year
                          Container(
                            height: 25.w,
                            color: Color(0xFF000000),
                            alignment: Alignment.center,
                            child: Text(
                              _dailyCouplePostViewModel.dailyCouplePost.year!,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w300,
                                fontSize: 17.w,
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
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.w,
                                    color: Color(0xFF000000)
                                ),
                              ),
                            ),
                            child: Text(
                              _dailyCouplePostViewModel.dailyCouplePost.month!,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 11.w,
                                fontStyle: FontStyle.normal,
                                //height: 12.w
                                //fontFamily:
                              ),
                            ),
                          ),
                          /// day
                          Container(
                            height: 50.w,
                            alignment: Alignment.center,
                            child: Text(
                              _dailyCouplePostViewModel.dailyCouplePost.day!,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 40.w,
                                fontStyle: FontStyle.normal,
                                //height: 45.w
                                //fontFamily:
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _dailyCouplePostViewModel.dailyCouplePost.questionType! == 0 ?
                    Container()
                        :
                    Container(
                      width: 100.w,
                      height: 100.w,
                      child: CachedNetworkImage(
                        imageUrl: _dailyCouplePostViewModel.dailyCouplePost.questionImageUrl!,
                        width: 100.w,
                        height: 100.w,
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
                  height: 25.w,
                  child: Text(
                    _dailyCouplePostViewModel.dailyCouplePost.questionText1!,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  height: 25.w,
                  child: Text(
                    _dailyCouplePostViewModel.dailyCouplePost.questionText2!,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFF000000),
            width: BORDER_WIDTH.w,
          ),
          Container(
              width: EMPTY_SPACE_WIDTH.w,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  topButton ?? Container(),
                  bottomButton == null ? Container() : Padding(padding: EdgeInsets.only(bottom: 20.w)),
                  bottomButton ?? Container(),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class RightIconButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  const RightIconButtonWidget({Key? key, required this.onTap, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        child: Icon(
          iconData,
          size: 30.w,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
}

class RightTextButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const RightTextButtonWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: 16.w,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}