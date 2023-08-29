import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class ScrapItemWidget extends StatelessWidget {
  const ScrapItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
      padding: EdgeInsets.only(right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [ShadowPalette.defaultShadowLight],
        borderRadius: BorderRadius.circular(10.w)
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(15.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: Image.asset(
                "assets/images/Ahri_15.jpg",
                width: 150.w,
                height: 150.w,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "위 예제에서",
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 10.h,),
                Text(
                  "라는 값을 사용하여 그림자를 만들었지만, 이 값을 조정하여 원하는 그림자 크기로 설정할 수 있습니다.",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
