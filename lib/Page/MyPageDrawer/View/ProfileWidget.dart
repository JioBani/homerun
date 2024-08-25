import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: GetX<AuthService>(
          builder: (service) {
            //#. 로그인 x
            if(service.userDto.value == null){
              return Column(
                children: [
                  Gap(20.w),
                  //#. 사용자 아이콘
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Palette.brightMode.lightText,
                      borderRadius: BorderRadius.circular(80.w)
                    ),
                    child: Center(
                      //TODO 아이콘 변경
                      child: Icon(
                        Icons.perm_identity_rounded,
                        size: 45.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gap(16.w),
                  //#. 로그인 안내 문구
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      "로그인 후 사용 가능합니다.",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Palette.brightMode.mediumText,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const Spacer(),
                  //#. 로그인 버튼
                  InkWell(
                    onTap: (){
                      Get.to(const LoginPage());
                    },
                    child: Container(
                      height: 30.w,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 25.w),
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: Gradients.skyBlueOrange,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(30.w),
                        color:Palette.baseColor,
                      ),
                      child: Center(
                        child: Text(
                          "로그인 / 회원가입",
                          style: TextStyle(
                            color: Palette.brightMode.darkText,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(15.h),
                ],
              );
            }
            //#. 로그인 o
            else{
              return Column(
                children: [
                  Gap(20.w),
                  //#. 프로필 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.w),
                    child: Image.asset(
                      TestImages.ashe_43,
                      width: 80.w,
                      height: 80.w,
                    ),
                  ),
                  Gap(15.h),
                  //#. 닉네임,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(21.w), //Icon과 Gap을 더한 만큼 오른쪽으로 보내기
                      //#. 닉네임
                      Flexible(
                        child: AutoSizeText(
                          service.userDto.value!.displayName!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: const Color(0xff2E3C6B), //TODO 어떤 색임?
                          ),
                          maxLines: 1,
                          minFontSize: 10, // Set the minimum font size
                          overflow: TextOverflow.ellipsis, // Handles overflow
                        ),
                      ),
                      Gap(5.w),
                      //#. 수정버튼
                      InkWell(
                        onTap: (){},
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffD9D9D9),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 11.sp,
                            color: Colors.white,
                          )
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          }
      ),
    );
  }
}