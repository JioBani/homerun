import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //#. 뒤로가기 아이콘
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new)
              ),
            ),
            SizedBox(height: 90.w,),
            //#. 청약홈런 텍스트
            Text(
              "청약홈런",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                fontFamily: Fonts.BCCard,
              ),
            ),
            SizedBox(height: 30.w,),
            //#. 안내 테스트
            Text(
              "간편하게 로그인하고\n 다양한 서비스를 이용하세요",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 57.w,),
            //#. 카카오로 시작하기
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFEE500),
                  borderRadius: BorderRadius.circular(20.r)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble), //TODO 카카오 아이콘으로 변경
                      SizedBox(width: 8.w,),
                      Text(
                        "카카오로 시작",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 17.w,),
            //#. 네이버로 시작하기
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xff00C53B),
                    borderRadius: BorderRadius.circular(20.r)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( //TODO 네이버 아이콘으로 변경
                        "N",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        "네이버로 시작",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            //#. 회원가입
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                height: 45.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [BoxShadow(
                    blurRadius: 2.sp,
                    offset: Offset(0,2.w),
                    color: Colors.black.withOpacity(0.25)
                  )]
                ),
                child: Center(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 13.w,),
            //#. 로그인 없이 계속하기
            InkWell(
              onTap: (){},
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 5.w
                ),
                child: Text(
                  "로그인 없이 계속하기",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: const Color(0xfffA4A4A6)
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.w,),
          ],
        ),
      ),
    );
  }
}
