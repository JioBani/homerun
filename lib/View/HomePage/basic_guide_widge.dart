import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/GuidePage/GuidePage.dart';

class BasicGuideWidget extends StatelessWidget {
  const BasicGuideWidget({super.key,
    required this.imagePath,
    required this.name,
    required this.description,
  });

  final String name;
  final String imagePath;
  final String description;

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
          Text(
            description,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
              color: Color.fromRGBO(164, 164, 166, 1)
            ),
          )
        ],
      ),
    );
  }
}