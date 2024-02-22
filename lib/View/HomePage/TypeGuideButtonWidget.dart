import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/GuidePage/guide_page.dart';

class TypeGuideButtonWidget extends StatelessWidget {
  const TypeGuideButtonWidget({
    super.key,
    required this.imagePath,
    required this.name
  });

  final String imagePath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          InkWell(
            onTap: ()=>Get.to(GuidePage()),
            child: Container(
              decoration: BoxDecoration(
                color: Palette.defaultGrey,
                borderRadius: BorderRadius.circular(109.w),
              ),
              width: 100.w,
              height: 100.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: FireStorageImage(
                      path: imagePath,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.w),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                color: Palette.defaultBlue
              ),
            ),
          ),
          SizedBox(height: 10.h,)
        ],
      ),
    );
  }
}
