import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';

class SiteReviewListItemWidget extends StatelessWidget {
  const SiteReviewListItemWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.r),
          child: Image.asset(
            TestImages.irelia_6,
            fit: BoxFit.fitWidth,
            width: 145.w,
            height: 180.w,
          ),
        ),
        SizedBox(height: 11.w,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.w),
              child: Image.asset(
                TestImages.ashe_43,
                width: 30.w,
                height: 30.w,
              ),
            ),
            SizedBox(width: 7.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  siteReview.writer,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                        NoticePageImages.star
                    ),
                    SizedBox(width: 3.w,),
                    Text(
                      "조회수 ${siteReview.view}",
                      style: TextStyle(
                          fontSize: 8.sp,
                          color: Color(0xff767676)
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }
}