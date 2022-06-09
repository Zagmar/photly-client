import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInputWidget extends StatelessWidget {
  final String? hintText;
  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final FormFieldSetter<String> onSaved;
  final TextInputType? keyboardType;
  final Function? onFieldSubmitted;
  final String? initialValue;
  const TextInputWidget({Key? key, this.hintText, required this.maxLines, this.maxLength, required this.obscureText, required this.onSaved, this.keyboardType, this.onFieldSubmitted, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.w,
      width: 325.w,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
        initialValue: initialValue??"",
        decoration: hintText != null ?
        InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelLarge,
        ) : null,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        onFieldSubmitted: (value) => onFieldSubmitted ?? FocusScope.of(context).unfocus(),
        obscureText: obscureText,
        onSaved: onSaved,
      ),
    );
  }
}
