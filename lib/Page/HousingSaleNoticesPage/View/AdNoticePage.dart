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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
