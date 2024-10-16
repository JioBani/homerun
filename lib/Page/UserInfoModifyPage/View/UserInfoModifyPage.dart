import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/FirebaseReferences/UserInfoReferences.dart';
import 'package:homerun/Common/Widget/SelectBoxWidget.dart';
import 'package:homerun/Page/UserInfoModifyPage/Controller/UserInfoModifyPageController.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';

import '../../LoginPage/View/UserInfoInputPage/UserInfoSelectBoxWidget.dart';

class UserInfoModifyPage extends StatelessWidget {
  UserInfoModifyPage({super.key});

  @override
  Widget build(BuildContext context) {

    UserDto? userDto = Get.find<AuthService>().userDto.value;

    //#. 유저 정보가 없는 경우
    if(userDto == null){
      CustomDialog.showConfirmationDialog(
          context: context,
          content: "사용자 정보를 불러 올 수 없습니다."
      ).then((value){
        if(context.mounted && Navigator.canPop(context)){
          Navigator.pop(context);
        }
      });

      return const Scaffold(
        body: SafeArea(
          child: Column(
            children: [],
          ),
        ),
      );
    }

    //#. 유저 정보가 있는 경우
    UserInfoModifyPageController controller = Get.put(UserInfoModifyPageController(userDto: userDto));

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
                  "프로필 수정",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
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
                          child: GetBuilder<UserInfoModifyPageController>(
                            builder: (controller) {
                              if(controller.modifiedProfileImage == null){
                                return FireStorageImage(
                                  path: UserInfoReferences.getUserProfileImagePath(userDto.uid ?? ''),
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                );
                              }
                              else{
                                return Image.file(
                                  File(controller.modifiedProfileImage!.path),
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
                              //controller.setProfileImage();
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
                  focusNode: controller.nickNameFocusNode,
                  controller: controller.nickNameController,
                  onChanged: controller.onNickNameEdit,
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
                    suffix: InkWell(
                      onTap: (){
                        controller.checkNickName(context);
                      },
                      child: Text(
                        "확인",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ),
                ),
                SizedBox(height: 20.w,),

                //#. 생년월일
                Text(
                  "생년월일",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
                SizedBox(height: 10.w,),
                TextFormField(
                  controller: controller.birthController,
                  keyboardType: TextInputType.datetime,
                  focusNode: controller.birthFocusNode,
                  onChanged: controller.onBirthTextChange,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500
                  ),
                  inputFormatters: [
                    //#. .을 포함해서 10글자로 제한
                    LengthLimitingTextInputFormatter(10),
                  ],
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
                    UserInfoSelectBoxWidget<Gender>(
                      value: Gender.male,
                      width: 130.w,
                      text: "남자",
                      onTap: (_){},
                      letterSpacing: 3.w,
                      controller: controller.genderController,
                      textPadding: EdgeInsets.only(left: 22.w),
                    ),
                    UserInfoSelectBoxWidget<Gender>(
                      value: Gender.female,
                      width: 130.w,
                      text: "여자",
                      onTap: (_){},
                      letterSpacing: 3.w,
                      controller: controller.genderController,
                      textPadding: EdgeInsets.only(left: 22.w),
                    ),
                  ],
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
                        ...Region.values.map((region) => UserInfoSelectBoxWidget<Region>(
                          value: region,
                          width: 86.w,
                          text: region.koreanString,
                          onTap: (_){},
                          controller: controller.regionController,
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
                  onTap: () async {
                    controller.updateUserInfo(context);
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
                        "저장하기",
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
