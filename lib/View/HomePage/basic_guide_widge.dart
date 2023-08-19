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
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 2), // 세로 및 가로 오프셋
                ),
              ],
            ),
            width: 280.w,
            height: 280.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
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
                        fontSize: 30.w,
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
                fontSize: 25.w,
                fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}