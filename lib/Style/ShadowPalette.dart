import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShadowPalette{
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 2.w,
    blurRadius: 5.w,
    offset: Offset(0, 2.w), // changes position of shadow
  );

  static BoxShadow defaultShadowLight = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 1.w,
    blurRadius: 2.w,
    offset: Offset(0, 2.w), // changes position of shadow
  );
}