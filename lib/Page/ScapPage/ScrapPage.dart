import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

class ScrapPage extends StatelessWidget {
  const ScrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "공고 스크랩",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.defaultSkyBlue,
              fontFamily: Fonts.title
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w , vertical: 0.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Palette.brightMode.mediumText,
                        width: 0.5.w
                      )
                    ),
                    child: Text(
                      "전체삭제",
                      style: TextStyle(
                        color: Palette.brightMode.mediumText
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
