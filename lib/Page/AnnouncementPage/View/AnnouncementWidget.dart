import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:intl/intl.dart';

import '../Model/AnnouncementDto.dart';

class AnnouncementWidget extends StatefulWidget {
  final AnnouncementDto announcement;

  const AnnouncementWidget({Key? key, required this.announcement}) : super(key: key);

  @override
  State<AnnouncementWidget> createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  /// 박스와 아이콘이 공통적으로 사용하는 애니메이션 컨트롤러
  late AnimationController _animationController;

  late Animation<double> _boxAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _boxAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    /// 아이콘 애니메이션은 180도만
    _iconAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w , vertical: 7.5.w),
      decoration: BoxDecoration(
          color: const Color(0xffFBFBFB),
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: const Color(0xffA4A4A6))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //#. 제목
          GestureDetector(
            onTap: _toggleExpand,
            child: Container(
              padding: EdgeInsets.fromLTRB(15.w, 7.w, 10.w, 7.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //#. 제목
                  Text(
                    widget.announcement.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  //#. 날짜
                  Text(
                    "(${DateFormat('yyyy.MM.dd').format(widget.announcement.date.toDate())})",
                    style: TextStyle(
                        fontSize: 10.sp, // 디자인 크기는 8인데 너무 작은거 같아서 조금 키움
                        fontWeight: FontWeight.w500,
                        color: Palette.brightMode.mediumText
                    ),
                  ),
                  Gap(5.w),
                  //#. 아이콘
                  RotationTransition(
                    turns: _iconAnimation,
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
          //#. 본문
          SizeTransition(
            sizeFactor: _boxAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Gap(1.w),
                  const Divider(indent: 0,height: 0,thickness : 1),
                  Gap(14.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(widget.announcement.content),
                  ),
                  Gap(14.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}