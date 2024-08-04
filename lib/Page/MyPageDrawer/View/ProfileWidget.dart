import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/TestImages.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
        builder: (service) {
          if(service.userDto.value == null){
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "청약홈런에 로그인해서 \n다양한 청약 정보를 받아보세요.",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(height: 20.w,),
                InkWell(
                  onTap: (){
                    Get.to(const LoginPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      "로그인하기",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.w,),
              ],
            );
          }
          else{
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
                  service.userDto.value!.displayName!,
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
    );
  }
}