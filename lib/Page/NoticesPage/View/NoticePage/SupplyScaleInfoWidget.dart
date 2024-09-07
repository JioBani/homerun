import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';

import 'ContentBoxWidget.dart';

class SupplyScaleInfoWidget extends StatelessWidget {
  const SupplyScaleInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoBoxWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(15.w),
          SubTitleWidget(
            text: "공급 규모",
            frontPadding: 12.w
          ),
          Gap(11.w),
          ContentBoxWidget(
            title: "공급위치",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w , horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "경기도 고양시 일산동구 장항동 529-26번지 일원",
                  ),
                  Text(
                    "(고양 장항지구 B-3BL)",
                    style: TextStyle(
                      fontSize: 10.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "공급규모",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child: Text(
                "300세대",
              ),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "건설사",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child: Text(
                "현대건설",
              ),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "공급위치",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child:  Text(
                "2027년 9월 예정",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Gap(15.w),
        ],
      )
    );
  }
}
