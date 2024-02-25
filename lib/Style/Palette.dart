import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Palette{
  static Color light = const Color(0xffEAEEF1);
  static Color background = const Color(0xffF7F7F9);
  static const Color defaultBlue = Color.fromRGBO(46, 60, 107, 1);
  static const Color defaultGrey = Color.fromRGBO(239, 238, 238, 1);
  static final AssessmentPagePalette assessmentPage = AssessmentPagePalette();
}

class AssessmentPagePalette{
 final Color questionWidgetBackground = const Color.fromRGBO(243, 242, 242, 1);
 final Color questionNumber = const Color.fromRGBO(35, 68, 177, 1);
}