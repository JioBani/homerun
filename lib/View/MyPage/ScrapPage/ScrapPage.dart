import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/View/MyPage/ScrapPage/ScrapItemWidget.dart';

class ScrapPage extends StatelessWidget {
  const ScrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          "스크랩",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 42.sp
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){},
              child: Text(
                "편집",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35.sp
                ),
              )
          )
        ],
      ),
      backgroundColor: Palette.light,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: Column(
            children: [
              ScrapItemWidget(),
              ScrapItemWidget(),
              ScrapItemWidget(),
              ScrapItemWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
