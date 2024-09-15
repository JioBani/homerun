import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/HousingSaleNoticesPage.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Style/Fonts.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({super.key}){
    enterApp();
  }

  Future<void> enterApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if(FirebaseAuth.instance.currentUser == null){
      Get.to(const LoginPage(goHomeAfterLogin: true,));
    }
    else{
      Get.to(const HousingSaleNoticesPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "청약 정보의 모든것!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30.sp,
                fontFamily: Fonts.BCCard
              ),
            ),
            Gap(30.w),
            Text(
              "청약 홈런",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40.sp,
                fontFamily: Fonts.BCCard
              ),
            )
          ],
        ),
      ),
    );
  }
}
