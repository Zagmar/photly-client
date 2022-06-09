import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OneBlockTopWidget extends StatelessWidget {
  final String topText;
  final String bottomText;
  const OneBlockTopWidget({Key? key, required this.topText, required this.bottomText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 170.w,
      padding: EdgeInsetsDirectional.fromSTEB(25.w, 0, 25.w, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 375.w,
            height: 130.w,
            alignment: Alignment.centerLeft,
            child: Text(
              topText,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 375.w,
            height: 20.w,
            alignment: Alignment.centerLeft,
            child: Text(
              bottomText,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class OneBlockTopWidgetKeyboardOn extends StatelessWidget {
  final String text;
  const OneBlockTopWidgetKeyboardOn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.w,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
