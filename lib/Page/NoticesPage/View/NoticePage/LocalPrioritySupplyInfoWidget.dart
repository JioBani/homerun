import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'ContentBoxWidget.dart';
import 'InfoBoxWidget.dart';
import 'SubTitleWidget.dart';

//TODO 실제 데이터 가져오기 및 취합중일때 반응형
class LocalPrioritySupplyInfoWidget extends StatelessWidget {
  const LocalPrioritySupplyInfoWidget({super.key});
  @override

  Widget build(BuildContext context) {
    return InfoBoxWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(15.w),
            SubTitleWidget(
                text: "지역우선 공급 비율",
                leftPadding: 12.w
            ),
            Gap(11.w),
            ContentBoxWidget(
              title: "해당 지역",
              titleWidth: 70.w,
              contentWidth: 188.w,
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 9.w , horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("고양시 1년 이상 계속 거주자 30%"),
                  ],
                ),
              ),
            ),
            Gap(2.w),
            ContentBoxWidget(
              title: "기타 경기",
              titleWidth: 70.w,
              contentWidth: 188.w,
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 9.w),
                child: Text("경기도 6개월 이상 계속 거주자 20%"),
              ),
            ),
            Gap(2.w),
            ContentBoxWidget(
              title: "기타 지역",
              titleWidth: 70.w,
              contentWidth: 188.w,
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 9.w,horizontal: 10.w),
                child: Text("경기도 6개월 미만 · 서울특별시 · 인천광역시 거주자에게 50%"),
              ),
            ),
            Gap(17.w),
          ],
        )
    );
  }
}
