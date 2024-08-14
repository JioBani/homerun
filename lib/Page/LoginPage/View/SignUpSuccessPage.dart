import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Style/Palette.dart';

class SignUpSuccessPage extends StatelessWidget {
  const SignUpSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(100.w),
              Text(
                "임강현님 환영합니다.",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(10.w),
              Text(
                "청약홈런에 가입이 완료되었습니다. 이제 청약에 대한 모든 정보를 확인 할 수 있어요.",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Palette.brightMode.mediumText
                ),
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
                    color: Theme.of(context).primaryColor
                  ),
                  child: Center(
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Gap(20.w),
            ],
          ),
        )
      ),
    );
  }
}
