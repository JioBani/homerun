import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/View/KakaoLogin/KakaoLoginPage.dart';

class ExtraGuideWidget extends StatelessWidget {
  const ExtraGuideWidget({super.key, required this.name, required this.description});

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.w , left: 10.w),
      child: SizedBox(
        height: 120.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 5.w,),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: SizedBox(
                      height: 70.w,
                      width: 70.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0.w),
                        child: Image.asset(Images.homeTemp),
                      ),
                    ),
                    onTap: ()=>{Get.to(KakaoLoginPage(title: "gd"))},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: Text(
                            description,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: Text(
                            description,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
