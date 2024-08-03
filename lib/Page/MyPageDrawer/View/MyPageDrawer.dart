import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/TestImages.dart';

class MyPageDrawer extends StatelessWidget {
  const MyPageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.w,),
            const ProfileWidget(),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //#. 프로필 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(60.w),
          child: Image.asset(
            TestImages.ashe_43,
            width: 60.w,
            height: 60.w,
          ),
        ),
        SizedBox(height: 7.w,),
        //#. 닉네임,
        Text(
          "크리스티나",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp
          ),
        ),
        SizedBox(height: 20.w,),
        const Divider(color: Color(0xff767676),)
      ],
    );
  }
}

