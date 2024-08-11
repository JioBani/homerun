import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:homerun/Page/LoginPage/Controller/UserInfoPageController.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

import 'SelectBoxWidget.dart';

class UserInfoInputPage extends StatelessWidget {
  UserInfoInputPage({super.key});

  final SelectBoxController<String> genderController = SelectBoxController<String>();
  final SelectBoxController<String> ageController = SelectBoxController<String>();
  final SelectBoxController<String> locationController = SelectBoxController<String>(isCanSelectMulti: true);

  final List<String> ages = ["20대","30대","40대","50대","60대"];
  final List<String> locations = ["서울","경기·인천","부산","대구·울산","충청","강원","경북"];

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserInfoPageController());

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
                          child: GetBuilder<UserInfoPageController>(
                            builder: (controller) {
                              if(controller.profileImage == null){
                                return Container(
                                  color: Colors.grey,
                                  width: 100.w,
                                  height: 100.w,
                                );
                              }
                              else{
                                return Image.file(
                                  File(controller.profileImage!.path),
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                );
                              }
                            }
                          )
                        ),
                        //#. 프로필 설정 버튼
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: (){
                              controller.setProfileImage();
                            },
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.w,),
                
                //#. 닉네임
                Text(
                  "닉네임",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 10.w,),
                TextFormField(
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
                    hintText: "영문·한글 최대 10자까지 가능해요.",
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 25.sp,
                      minHeight: 25.sp,
                    ),
                    border: GradientOutlineInputBorder(
                      gradient: const LinearGradient(colors: [Palette.defaultSkyBlue, Color(0xffFF9C32)]),
                      width: 2.w,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    hintStyle: TextStyle(
                      color: Palette.brightMode.lightText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 20.w,),

                //#. 성별
                Text(
                  "성별을 알려주세요!",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 10.w,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SelectBoxWidget<String>(
                      value: "남자",
                      width: 130.w,
                      text: "남자",
                      onTap: (_){},
                      letterSpacing: 3.w,
                      controller: genderController,
                      textPadding: EdgeInsets.only(left: 22.w),
                    ),
                    SelectBoxWidget<String>(
                      value: "여자",
                      width: 130.w,
                      text: "여자",
                      onTap: (_){},
                      letterSpacing: 3.w,
                      controller: genderController,
                      textPadding: EdgeInsets.only(left: 22.w),
                    ),
                  ],
                ),
                SizedBox(height: 20.w,),
                
                //#. 연령대
                Text(
                  "연령대를 알려주세요!",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 10.w,),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70.w,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 9.w,
                    children : [
                     ...ages.map((age) => SelectBoxWidget(
                        value: age,
                        width: 84.w,
                        text: age,
                        onTap: (_){},
                        letterSpacing: 3.w,
                        controller: ageController,
                      )).toList(),
                      SizedBox(width: 84.w,height: 40.w,)
                    ]
                  ),
                ),
                SizedBox(height: 20.w,),

                //#. 관심 지역
                Text(
                  "관심 지역을 알려주세요!(최대 3개)",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 10.w,),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70.w,
                  child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 9.w,
                      children : [
                        ...locations.map((location) => SelectBoxWidget(
                          value: location,
                          width: 86.w,
                          text: location,
                          onTap: (_){},
                          controller: locationController,
                          hasIcon: false,
                          textPadding: EdgeInsets.zero,
                        )).toList(),
                        SizedBox(width: 84.w,height: 40.w,)
                      ]
                  ),
                ),
                SizedBox(height: 22.w,),

                //#. 다음 버튼
                InkWell(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 45.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [BoxShadow(offset: Offset(0,2.w),blurRadius: 2.r, color: Colors.black.withOpacity(0.25))]
                    ),
                    child: Center(
                      child: Text(
                        "다음으로",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.w,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



