import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/View/GuidePage/guide_page.dart';

class BasicGuideWidget extends StatelessWidget {
  const BasicGuideWidget({super.key,
    required this.imageUrl,
    required this.overlayText,
    required this.description,
  });

  final String imageUrl;
  final String overlayText;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: ()=>Get.to(GuidePage()),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3.r,
                  blurRadius: 10.r,
                  offset: Offset(0, 2.sp), // 세로 및 가로 오프셋
                ),
              ],
            ),
            width: 100.w,
            height: 100.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(imageUrl),
                ),
                Positioned(
                  top: 10.w,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                    child: Text(
                      overlayText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.w),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            ),
          ),
        )
      ],
    );
  }
}