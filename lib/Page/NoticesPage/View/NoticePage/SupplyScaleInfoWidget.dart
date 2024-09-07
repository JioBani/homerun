import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/Style/Palette.dart';

//TODO 디자인 수정 및 데이터 불러오기 적용해야함 (회의 필요)
class SupplyScaleInfoWidget extends StatelessWidget {
  const SupplyScaleInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoBoxWidget(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              Gap(17.w),
              SubTitleWidget(
                text: "공급 세대수",
                frontPadding: 10.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(17.w),
                    Text(
                      "아파트 지하 2층, 지상 29층 8개동",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Palette.brightMode.darkText
                      ),
                    ),
                    Gap(12.w),
                    Row(
                      children: [
                        Text(
                          "아파트 총 760 대 중",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Palette.brightMode.darkText
                          ),
                        ),
                        Gap(5.w),
                        Text(
                          "총 300세대 분양",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Gap(12.w),
                    Text(
                      "특별공급 150세대 / 일반공급 150세대",
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Palette.brightMode.darkText
                      ),
                    ),
                    Gap(17.w),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
