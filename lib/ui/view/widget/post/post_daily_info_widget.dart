import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/ui_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/daily_couple_post_model.dart';
import '../../../view_model/daily_couple_post_view_model.dart';

/// Screen Split Ratio
/// 295 : 1 : 94

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
      height: 190.w,
      child: Row(
        children: <Widget>[
          Container(
            width: MAIN_SPACE_WIDTH.w,
            margin: EdgeInsets.only(bottom: 30.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date
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
                  bottomButton ?? Container(),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  const IconButtonWidget({Key? key, required this.onTap, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        iconData,
        size: 24.w,
        color: Color(0xFF666666),
      ),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const TextButtonWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: 18.w,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000)
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}