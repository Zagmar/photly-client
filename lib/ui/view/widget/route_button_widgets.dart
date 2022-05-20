import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteButton extends StatelessWidget {
  final Widget? leftButton;
  final Widget? rightButton;
  const RouteButton({Key? key, this.leftButton, this.rightButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 60.w,
      alignment: Alignment.centerRight,
      padding: EdgeInsetsDirectional.fromSTEB(25.w, 0, 25.w, 20.w),
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

class SingleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const SingleButton({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.w),
            border: Border.all(
              width: 2.w,
              color: Color(0xFF050505),
            )
        ),
        width: 90.w,
        height: 48.w,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
              color: Color(0xFF050505)
          ),
          textAlign: TextAlign.center,
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
    return RouteButton(leftButton: SingleButton(onTap: onTap, buttonText: buttonText,),);
  }
}

class RightButtonOnlyWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const RightButtonOnlyWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouteButton(rightButton: SingleButton(onTap: onTap, buttonText: buttonText,),);
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
      leftButton: SingleButton(onTap: onTapLeft, buttonText: buttonTextLeft,),
      rightButton: SingleButton(onTap: onTapRight, buttonText: buttonTextRight,),
    );
  }
}

class LargeButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final String buttonText;
  const LargeButtonWidget({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        width: 390.w,
        height: 60.w,
        color: Color(0xFF050505),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E5E5)
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

