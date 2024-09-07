import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Palette.dart';

class ContentBoxWidget extends StatelessWidget {
  const ContentBoxWidget({
    super.key,
    required this.title,
    required this.titleWidth,
    required this.content,
    required this.contentWidth,
    this.gap
  });
  final Widget content;
  final String title;
  final double titleWidth;
  final double contentWidth;
  final double? gap; /// 제목 박스와 컨텐츠 박스 사이의 간격 , 기본값은 2.w

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Palette.brightMode.darkText,
          fontSize: 11.sp
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: titleWidth,
                color: const Color(0xff014FAB),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              Gap(gap ?? 2.w),
              Container(
                width: contentWidth,
                color: const Color(0xffF7F7F7),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentTitleBoxWidget extends StatelessWidget {
  const ContentTitleBoxWidget({super.key, required this.title, required this.width, required this.height, this.margin});
  final String title;
  final double width;
  final double height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: margin,
      width: width,
      height: height,
      color: const Color(0xff014FAB),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}

class ContentTextBoxWidget extends StatelessWidget {
  const ContentTextBoxWidget({super.key, required this.text, required this.width, required this.height, this.margin});
  final String text;
  final double height;
  final double width;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      color: const Color(0xffF7F7F7),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Palette.brightMode.darkText
          ),
        ),
      ),
    );
  }
}


