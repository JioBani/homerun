import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';

import 'ContentBoxWidget.dart';

//TODO 데이터를 불러오지 못했거나, 없거나, 취합중일때 어떻게 표현할지
class BasicInfoWidget extends StatelessWidget {
  const BasicInfoWidget({super.key, required this.info});
  final APTAnnouncement? info;

  @override
  Widget build(BuildContext context) {
    String location = "";
    String size = "";
    String company = "";
    String moveIn = "";

    if(info == null){
      location = APTAnnouncementStrings.couldNotGetData;
      size = APTAnnouncementStrings.couldNotGetData;
      company = APTAnnouncementStrings.couldNotGetData;
      moveIn = APTAnnouncementStrings.couldNotGetData;
    }
    else{
      location = info!.supplyLocationAddress ?? APTAnnouncementStrings.collectionData;
      size =  info?.totalSupplyHouseholdCount == null ? APTAnnouncementStrings.collectionData : "${info?.totalSupplyHouseholdCount}세대";
      company = info!.constructionEnterpriseName ?? APTAnnouncementStrings.collectionData;
      moveIn = info!.moveInPrearrangeYearMonth ?? APTAnnouncementStrings.collectionData;
    }

    return InfoBoxWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(15.w),
          SubTitleWidget(
            text: "공급 규모",
            leftPadding: 12.w
          ),
          Gap(11.w),
          ContentBoxWidget(
            title: "공급위치",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w , horizontal: 15.w),
              child: Center(child: Text(location)),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "공급규모",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child: Text(size),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "건설사",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child: Text(company),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "입주시기",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child:  Text(moveIn),
            ),
          ),
          Gap(15.w),
        ],
      )
    );
  }
}
