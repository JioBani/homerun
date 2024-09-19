import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class SignUpSuccessPage extends StatelessWidget {
  const SignUpSuccessPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(72.w),
              Image.asset(
                SignUpSuccessPageImages.success,
                width: 200.w,
                height: 200.w,
              ),
              Gap(62.w),
              Text(
                "회원가입 완료!",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.brightMode.mediumText
                ),
              ),
              Gap(37.w),
              Text(
                "'${name}' 님,\n청약홈런에 오신것을\n환영합니다!",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.BCCard
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              InkWell(
                onTap: (){
                  Get.back(result: true);
                },
                child: Container(
                  width: double.infinity,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [ShadowPalette.defaultShadow]
                  ),
                  child: Center(
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Gap(36.w),
            ],
          ),
        )
      ),
    );
  }
}
