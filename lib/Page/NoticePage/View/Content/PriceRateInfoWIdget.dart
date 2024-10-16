import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/NoticePage/View/Content/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/SubTitleWidget.dart';
import 'package:homerun/Style/Palette.dart';

//TODO 실제 데이터 가져오기 및 취합중일때 반응형
class PriceRateInfoWidget extends StatelessWidget {
  const PriceRateInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoBoxWidget(
        child: Center(
          child: SizedBox(
            width: 260.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(15.w),
                SubTitleWidget(
                  text: "계약금 납부 비율",
                  leftPadding: 12.w,
                  width: 260.w,
                ),
                Gap(17.w),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Palette.brightMode.darkText
                  ),
                  child: Row(
                    children: [
                      const Text("계약금"),
                      Gap(4.w),
                      Text(
                        "20%",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Palette.defaultRed,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Gap(4.w),
                      const Text("+"),
                      Gap(4.w),
                      const Text("중도금"),
                      Gap(4.w),
                      Text(
                        "60%",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Palette.defaultRed,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Gap(4.w),
                      const Text("+"),
                      Gap(4.w),
                      const Text("잔금"),
                      Gap(4.w),
                      Text(
                        "20%",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Palette.defaultRed,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(17.w),
              ],
            ),
          ),
        )
    );
  }
}
