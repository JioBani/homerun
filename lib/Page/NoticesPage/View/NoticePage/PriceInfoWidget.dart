import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/ContentBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Style/Palette.dart';

import 'SubTitleWidget.dart';

//TODO 디자인 수정 및 실제 데이터 가져와야함
//TODO 데이터 취합중일때 반응형 표현
class PriceInfoWidget extends StatelessWidget {
  const PriceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoBoxWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(17.w),
            SubTitleWidget(
              text: "분양가",
              leftPadding: 17.w,
              rightPadding: 20.w,
            ),
            Gap(13.w),
            Row(
              children: [
                Gap(25.w),
                Text(
                  "분양가 상한제 : ",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Palette.brightMode.darkText
                  ),
                ),
                Text(
                  "적용 비적용",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Gap(37.w),
                Text(
                  "공급금액 (단위: 만원)",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Palette.brightMode.darkText
                  ),
                )
              ],
            ),
            Gap(12.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentTitleBoxWidget(
                  title: "공급규모",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
                ContentTitleBoxWidget(
                  title: "공급규모",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
                ContentTextBoxWidget(
                  text: "084.9958A",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
              ],
            ),
            Gap(17.w)
          ],
        )
    );
  }
}
