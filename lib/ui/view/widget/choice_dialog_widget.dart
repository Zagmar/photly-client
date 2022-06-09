import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThreeOptionsDialogWidget extends StatelessWidget {
  final String title;
  final Widget firstDialogOption;
  final Widget secondDialogOption;
  final Widget thirdDialogOption;
  const ThreeOptionsDialogWidget({Key? key,  required this.title, required this.firstDialogOption, required this.secondDialogOption, required this.thirdDialogOption,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.w),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.w,
          color: Colors.black,
        ),
      ),
      children: <Widget>[
        firstDialogOption,
        secondDialogOption,
        thirdDialogOption
      ],
    );
  }
}

class SingleDialogOption extends StatelessWidget {
  final String dialogText;
  final GestureTapCallback onPressed;
  final Color? textColor;
  const SingleDialogOption({Key? key, required this.dialogText, required this.onPressed, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: Text(
        dialogText,
        style: TextStyle(
          fontSize: 14.w,
          color: textColor
        ),
      ),
      onPressed: onPressed,
    );
  }
}

