import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteButton extends StatelessWidget {
  final Widget? leftButton;
  final Widget? rightButton;
  const RouteButton({Key? key, this.leftButton, this.rightButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      alignment: Alignment.centerRight,
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftButton??Container(),
          rightButton??Container()
        ],
      ),
    );
  }
}

class SingleTextButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const SingleTextButton({Key? key, required this.onTap, required this.buttonText,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.w),
            border: Border.all(
              width: 2.w,
              color: Color(0xFF050505),
            )
        ),
        width: 90.w,
        height: 48.w,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buttonText == "이전" ? Icon(Icons.chevron_left_outlined, size: 30.w, color: Color(0xFF050505),) : Container(width: 20.w,),
            Text(
              buttonText,
              style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF050505)
              ),
              textAlign: TextAlign.center,
            ),
            buttonText == "다음" ? Icon(Icons.chevron_right_outlined, size: 30.w, color: Color(0xFF050505),) : Container(width: 20.w),
          ],
        ),
      ),
    );
  }
}

class LeftButtonOnlyWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const LeftButtonOnlyWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouteButton(leftButton: SingleTextButton(onTap: onTap, buttonText: buttonText,),);
  }
}

class RightButtonOnlyWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const RightButtonOnlyWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouteButton(rightButton: SingleTextButton(onTap: onTap, buttonText: buttonText,),);
  }
}

class BothButtonsWidget extends StatelessWidget {
  final GestureTapCallback onTapLeft;
  final String buttonTextLeft;
  final GestureTapCallback onTapRight;
  final String buttonTextRight;
  const BothButtonsWidget({Key? key, required this.onTapLeft, required this.buttonTextLeft, required this.onTapRight, required this.buttonTextRight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouteButton(
      leftButton: SingleTextButton(onTap: onTapLeft, buttonText: buttonTextLeft,),
      rightButton: SingleTextButton(onTap: onTapRight, buttonText: buttonTextRight,),
    );
  }
}

class BottomLargeButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const BottomLargeButtonWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 375.w,
        height: 60.w,
        color: Color(0xFF000000),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

