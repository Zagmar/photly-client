import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OneBlockTop extends StatelessWidget {
  final String topText;
  final String bottomText;
  const OneBlockTop({Key? key, required this.topText, required this.bottomText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.w,
      padding: EdgeInsetsDirectional.fromSTEB(25.w, 0, 25.w, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topText,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            bottomText,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
