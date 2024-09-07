import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Palette.dart';

class ContentBoxWidget extends StatefulWidget {
  const ContentBoxWidget({
    super.key,
    required this.title,
    required this.titleWidth,
    required this.content,
    required this.contentWidth,
    this.titleFontSize,
    this.gap,
  });

  final Widget content;
  final String title;
  final double titleWidth;
  final double contentWidth;
  final double? gap; // 제목 박스와 컨텐츠 박스 사이의 간격, 기본값은 2.w
  final double? titleFontSize;

  @override
  State<ContentBoxWidget> createState() => _ContentBoxWidgetState();
}

class _ContentBoxWidgetState extends State<ContentBoxWidget> {
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  double _maxHeight = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxHeight();
    });
    super.initState();
  }

  void _calculateMaxHeight() {
    final titleHeight = _titleKey.currentContext?.size?.height ?? 0;
    final contentHeight = _contentKey.currentContext?.size?.height ?? 0;
    setState(() {
      _maxHeight = titleHeight > contentHeight ? titleHeight : contentHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          key: _titleKey, // 제목 컨테이너에 키 할당
          width: widget.titleWidth,
          height: _maxHeight > 0 ? _maxHeight : null, // 최대 높이 설정
          color: const Color(0xff014FAB),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Center(
            child: AutoSizeText(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.titleFontSize ?? 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 8,
            ),
          ),
        ),
        Gap(widget.gap ?? 2.w),
        Container(
          key: _contentKey, // 내용 컨테이너에 키 할당
          width: widget.contentWidth,
          height: _maxHeight > 0 ? _maxHeight : null, // 최대 높이 설정
          color: const Color(0xffF7F7F7),
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Palette.brightMode.darkText,
              fontSize: 11.sp,
            ),
            child: widget.content,
          ),
        ),
      ],
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


