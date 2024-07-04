import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Palette{
  static Color light = const Color(0xffEAEEF1);
  static Color background = const Color(0xffF7F7F9);
  static const Color defaultBlue = Color.fromRGBO(46, 60, 107, 1);
  static const Color defaultGrey = Color.fromRGBO(239, 238, 238, 1);
  static final AssessmentPagePalette assessmentPage = AssessmentPagePalette();
  static final FontPalette font = FontPalette();
  static const Color defaultSkyBlue =  Color(0xff35C5F0);
  static const primary = Color(0xff35C5F0);
  static ColorMode brightMode = BrightMode();

}

class AssessmentPagePalette{
 final Color questionWidgetBackground = const Color.fromRGBO(243, 242, 242, 1);
 final Color questionNumber = const Color.fromRGBO(35, 68, 177, 1);
}

class FontPalette{
  final Color grey = const Color.fromRGBO(164, 164, 166, 1);
  final Color blue = const Color.fromRGBO(46, 60, 107, 1);
}

abstract class ColorMode{
  Color get darkText;
  set darkText(Color value);

  Color get mediumText;
  set mediumText(Color value);

  Color get lightText;
  set lightText(Color value);
}

class BrightMode implements ColorMode{
  @override
  Color darkText = const Color(0xff555555);

  @override
  Color mediumText = const Color(0xff767676);

  @override
  Color lightText = const Color(0xffD9D9D9);

}