import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Model/AptDetailsInfo.dart';
import 'package:homerun/Common/PriceFormatter.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Feature/Notice/Model/NoticeDto.dart';
import 'package:homerun/Page/NoticePage/View/Content/ContentBoxWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/InfoBoxWidget.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:homerun/Style/Palette.dart';

import 'SubTitleWidget.dart';

class PriceInfoWidget extends StatelessWidget {
  const PriceInfoWidget({super.key, this.noticeDto});
  final NoticeDto? noticeDto;

  Widget makePriceListWidget(){
    if(noticeDto == null){
      return SizedBox(
        height: 80.w,
        child: const Center(child: Text(APTAnnouncementStrings.couldNotGetData)),
      );
    }
    else if(noticeDto?.applyHomeDto.detailsList == null){
      return SizedBox(
        height: 80.w,
        child: const Center(child: Text(APTAnnouncementStrings.couldNotGetData)),
      );
    }
    else{
      return Column(
        children: noticeDto!.applyHomeDto.detailsList!.map((e)=>
          PriceItemWidget(aptAnnouncementByHouseType : e)
        ).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoBoxWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(17.w),
            //#. 소제목
            SubTitleWidget(
              text: "분양가",
              leftPadding: 17.w,
              rightPadding: 20.w,
            ),
            Gap(12.w),
            //#. 항목
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
                  title: "분양가(최고가 기준)",
                  width: 120.w,
                  height: 30.w,
                  margin: EdgeInsets.all(1.w),
                ),
              ],
            ),
            //#. 분양가 목록
            makePriceListWidget(),
            Gap(17.w)
          ],
        )
    );
  }
}

/// 분양가 목록 아이템
class PriceItemWidget extends StatelessWidget {
  const PriceItemWidget({super.key, this.aptAnnouncementByHouseType});
  final AptDetailsInfo? aptAnnouncementByHouseType;

  @override
  Widget build(BuildContext context) {
    final String typeText; //#. 공급 규모
    final String priceText; //#. 분양가

    if(aptAnnouncementByHouseType == null){
      typeText = APTAnnouncementStrings.couldNotGetData;
      priceText = APTAnnouncementStrings.couldNotGetData;
    }
    else{
      if(aptAnnouncementByHouseType!.houseType == null){
        typeText = "알 수 없음";
        priceText = "알 수 없음";
      }
      else{
        typeText = aptAnnouncementByHouseType!.houseType!;

        if(aptAnnouncementByHouseType!.topAmount == null){
          priceText = "취합 중";
        }
        else{
          priceText = PriceFormatter.tryFormatToEokThousand(
              aptAnnouncementByHouseType!.topAmount!.toDouble()
          ) ?? "알 수 없음";
        }
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContentTextBoxWidget(
          text: typeText,
          width: 120.w,
          height: 30.w,
          margin: EdgeInsets.all(1.w),
          maxLines: 1,
        ),
        ContentTextBoxWidget(
          text: priceText,
          width: 120.w,
          height: 30.w,
          margin: EdgeInsets.all(1.w),
          maxLines: 1,
        ),
      ],
    );
  }
}

