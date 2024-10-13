import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/ApplyHome/AptBasicInfo.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ContentBoxWidget.dart';

//TODO 데이터를 불러오지 못했거나, 없거나, 취합중일때 어떻게 표현할지
class BasicInfoWidget extends StatelessWidget {
  const BasicInfoWidget({super.key, required this.info});
  final AptBasicInfo? info;

  String formatPhoneNumber(String phoneNumber) {
    // 숫자만 남기기 (하이픈, 공백 등 제거)
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanedNumber.length == 8) {
      // 8자리 전화번호: 0000-0000
      return '${cleanedNumber.substring(0, 4)}-${cleanedNumber.substring(4, 8)}';
    } else if (cleanedNumber.length == 9) {
      // 9자리 전화번호: 00-000-0000
      return '${cleanedNumber.substring(0, 2)}-${cleanedNumber.substring(2, 5)}-${cleanedNumber.substring(5, 9)}';
    } else if (cleanedNumber.length == 10) {
      // 10자리 전화번호: 000-000-0000
      return '${cleanedNumber.substring(0, 3)}-${cleanedNumber.substring(3, 6)}-${cleanedNumber.substring(6, 10)}';
    }

    // 위 조건에 해당하지 않으면 원래 전화번호 반환
    return phoneNumber;
  }


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
            text: "기본 정보",
            leftPadding: 12.w
          ),
          Gap(11.w),
          ContentBoxWidget(
            title: "공급 위치",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w , horizontal: 15.w),
              child: Center(child: Text(location)),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "공급 규모",
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
            title: "입주 시기",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 9.w),
              child:  Text(moveIn),
            ),
          ),
          Gap(2.w),
          ContentBoxWidget(
            title: "문의처",
            titleWidth: 70.w,
            contentWidth: 188.w,
            content: Padding(
              padding : EdgeInsets.symmetric(vertical: 9.w),
              child: Builder(
                builder: (context) {
                  if(info?.inquiryTelephone == null){
                    return Text("정보없음");
                  }
                  else{
                    return GestureDetector(
                      onTap: () async {
                        bool? result = await CustomDialog.showConfirmationDialog(
                            context: context,
                            content: "전화 앱으로 연결할까요?"
                        );

                        if(result == true){
                          final Uri telUri = Uri(scheme: 'tel', path: info!.inquiryTelephone!);
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri); // 전화 앱을 엽니다.
                          } else {
                            CustomSnackbar.show("오류", "전화앱을 열 수 없습니다.");
                          }
                        }
                      },
                      child: Text(
                        formatPhoneNumber(info!.inquiryTelephone!),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          color: Theme.of(context).primaryColor
                        ),
                      )
                    );
                  }
                }
              ),
            ),
          ),
          Gap(15.w),
        ],
      )
    );
  }
}
