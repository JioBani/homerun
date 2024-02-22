import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Controller/main_page_controller.dart';
import 'package:homerun/Style/FirebaseStorageImages.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/View/HomePage/NewsWidget.dart';
import 'package:homerun/View/HomePage/basic_guide_widge.dart';
import 'package:homerun/View/HomePage/search_bar_widget.dart';
import 'package:homerun/View/buttom_nav.dart';
import '../../Style/Palette.dart';
import 'TypeGuideButtonWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final MainPageController mainPageController = Get.put( MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 18.w , right: 18.w),
            child: ListView(
              children: [
                SizedBox(height: 10.h,),
                Align(
                  alignment: Alignment.center,
                  child: Text("청약홈런",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.defaultBlue
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: CustomTextField(),
                    ),
                    InkWell(
                      onTap: (){},
                      child: Column(
                        children: [
                          Image.asset(
                            HomeImages.ad,
                            width: 25.sp,
                            height: 25.sp,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            "제휴광고",
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w,),
                    InkWell(
                      onTap: (){},
                      child: Column(
                        children: [
                          Image.asset(
                            HomeImages.myPage,
                            width: 25.sp,
                            height: 25.sp,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            "마이페이지",
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w,),
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r) , topRight: Radius.circular(10.r)),
                  child: FireStorageImage(
                    path: "images/ad/ad1.png",
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 120.h,
                    ),
                  ), // #. image
                SizedBox(height: 9.w,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("#청약길잡이",
                    style: TextStyle(
                      fontSize: 20.sp,
                      //TODO w600 -> w700
                      fontWeight: FontWeight.w600,
                      color: Palette.defaultBlue
                    ),
                  ),
                ),
                SizedBox(height: 15.w,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BasicGuideWidget(
                      imagePath: FirebaseStorageImages.guideImages.public,
                      name : "국민주택" ,
                      description: "LH, SH 등 국가에서 건설 공급하는 분양주택",
                    ),
                    BasicGuideWidget(
                      imagePath: FirebaseStorageImages.guideImages.private,
                      name : "민영주택" ,
                      description: "민간사업주체 분양주택.",
                    ),
                    BasicGuideWidget(
                      imagePath: FirebaseStorageImages.guideImages.newlywed,
                      name : "신혼홈타운" ,
                      description: "신혼부부 특화형 공공주택.",
                    ),
                  ],
                ),
                SizedBox(height: 10.w,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("#유형별 길잡이",
                    style: TextStyle(
                        fontSize: 20.sp,
                        //TODO w600 -> w700
                        fontWeight: FontWeight.w600,
                        color: Palette.defaultBlue
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.youth,
                      name: "청년",
                    ),
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.newlyweds,
                      name: "신혼부부",
                    ),
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.firetime,
                      name: "기관추천",
                    ),
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.firetime,
                      name: "생애최초",
                    ),
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.senior,
                      name: "노부모",
                    ),
                    TypeGuideButtonWidget(
                      imagePath: FirebaseStorageImages.typeImages.family,
                      name: "다자녀",
                    ),
                  ],
                ),
                SizedBox(height: 10.w,),
                NewsWidget()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar()
    );
  }
}
