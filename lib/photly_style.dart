import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotlyStyle {
  final MediaQueryData _mediaQueryData;
  var _appBarSize = 0;
  late final ThemeData _photlyThemeData;

  PhotlyStyle(this._mediaQueryData){
    // Design based on 375 X 667 : Iphone 8
    _photlyThemeData = ThemeData(
      fontFamily: 'Roboto',
      backgroundColor: Color(0xFFFFFFFF),
      splashColor: Color(0xFF000000),
      scaffoldBackgroundColor: Color(0xFFFFFFFF),
      brightness: Brightness.light,
      primaryColor: Color(0xFFFFFFFF),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            fontSize: 28.w,
            color: Color(0xFF000000),
            overflow: TextOverflow.ellipsis
        ),
        headlineMedium: TextStyle(
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            fontSize: 24.w,
            color: Color(0xFF000000),
            overflow: TextOverflow.ellipsis
        ),
        headlineSmall: TextStyle(
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 16.w,
            color: Color(0xFF000000).withOpacity(0.5),
            overflow: TextOverflow.ellipsis
        ),
        // font for question
        titleLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 21.w,
            color: Color(0xFF000000),
            overflow: TextOverflow.ellipsis
        ),
        titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.w,
            decoration: TextDecoration.underline,
            color: Color(0xFF000000),
            overflow: TextOverflow.ellipsis
        ),
        titleSmall:TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10.w,
          color: Color(0xFF000000),
          overflow: TextOverflow.ellipsis,
        ),
        // font for hint text
        labelLarge: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.w,
            color: Color(0xFFC4C4C4),
            overflow: TextOverflow.ellipsis
        ),
        // font for single text button label
        labelSmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.w,
            color: Color(0xFF000000).withOpacity(0.5),
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0
        ),
        // font for large button lable
        labelMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.w,
            color: Color(0xFFFFFFFF),
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0
        ),
        bodyLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.w,
            color: Color(0xFF000000),
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0
        ),
      ),
    );
  }

  get fullWidth => _mediaQueryData.size.width;
  get fullHeight => _mediaQueryData.size.height;
  get fullLayoutHeight => _mediaQueryData.size.height - _appBarSize;

  get photlyThemeData => _photlyThemeData;
  get headlineLarge => _photlyThemeData.textTheme.headlineLarge;
  get headlineMedium => _photlyThemeData.textTheme.headlineMedium;
  get headlineSmall => _photlyThemeData.textTheme.headlineSmall;
}