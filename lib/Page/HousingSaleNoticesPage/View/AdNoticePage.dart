import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Style/Images.dart';

class AdNoticePage extends StatelessWidget {
  const AdNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 17.w,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 25.w,),
                InkWell(
                  onTap: ()=>Get.back(),
                  child: SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: Image.asset(
                      Images.backIcon,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                InkWell(
                  onTap: ()=>Get.back(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: Image.asset(
                          Images.partnershipAd,
                        ),
                      ),
                      SizedBox(height: 3.w,),
                      Text(
                        "제휴공고",
                        style: TextStyle(
                          fontSize: 7.sp
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 7.w,),
                InkWell(
                  onTap: ()=>Get.back(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: Image.asset(
                          Images.adInquiry,
                        ),
                      ),
                      SizedBox(height: 3.w,),
                      Text(
                        "광고문의",
                        style: TextStyle(
                            fontSize: 7.sp
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 25.w,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
