import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Style/ShadowPalette.dart';

class TapBarWidget extends StatefulWidget {
  const TapBarWidget({super.key});

  @override
  State<TapBarWidget> createState() => _TapBarWidgetState();
}

class _TapBarWidgetState extends State<TapBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      decoration: BoxDecoration(
          color: Colors.white, // 배경색을 하얀색으로 설정
          boxShadow: [
            ShadowPalette.defaultShadowLight,
          ],
          borderRadius: BorderRadius.circular(10.w)
      ),
      child: TabBar(
        tabs: [
          Tab(child: Text(
            '국민주택',
            style: TextStyle(
                fontSize: 30.0.w,
                fontWeight: FontWeight.bold,
                color: Colors.black87
            ),
          )),
          Tab(child: Text(
            '민영주택',
            style: TextStyle(
                fontSize: 30.0.w,
                fontWeight: FontWeight.bold,
                color: Colors.black87
            ),
          )),
          Tab(child: Text(
            '신혼홈타운',
            style: TextStyle(
                fontSize: 30.0.w,
                fontWeight: FontWeight.bold,
                color: Colors.black87
            ),
          )),
        ],
        labelColor: Colors.blue, // 선택된 탭의 텍스트 색상 변경
        unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상 변경
        indicatorColor: Colors.blue, // 선택된 탭 아래의 밑줄 색상 변경
      ),
    );
  }
}
