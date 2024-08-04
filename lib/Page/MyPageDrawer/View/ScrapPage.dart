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
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
