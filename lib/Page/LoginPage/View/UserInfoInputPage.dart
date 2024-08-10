import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class UserInfoInputPage extends StatelessWidget {
  const UserInfoInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 53.w,),
                //#. 정보 입력해주세요.
                Text(
                  "나의 정보를 입력해주세요.",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.w,),
                //#. 정보 관리 문구
                Text(
                  "청약 공고 추천등에 활용되며 입력한 정보는 외부에 표시되지 않습니다.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 15.w,),
                //#. 프로필 설정
                Center(
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: Stack(
                      children: [
                        //#. 프로필 이미지
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.w),
                          child: Image.asset(
                            TestImages.irelia_6,
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //#. 프로필 설정 버튼
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white , width: 1.w),
                              borderRadius: BorderRadius.circular(25.w),
                              color: Colors.black
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //#. 닉네임
                Text(
                  "닉네임",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
