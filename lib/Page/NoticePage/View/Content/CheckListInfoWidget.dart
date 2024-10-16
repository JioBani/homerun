import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Model/AptBasicInfo.dart';
import 'package:homerun/Page/NoticePage/View/Content/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/SubTitleWidget.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:homerun/Style/Palette.dart';

//TODO overflow
class CheckListInfoWidget extends StatelessWidget {
  CheckListInfoWidget({super.key, this.announcement});

  final AptBasicInfo? announcement;

  late final String largeScale;
  late final String redevelopment;
  late final String privatePublicHousing ;
  late final String specialLaw;
  String? overheat;
  String? adjustTarget;
  String? priceCanApp;

  @override
  Widget build(BuildContext context) {
    final String selectionText;
    bool hasSelectionData = true;

    if(announcement == null){
      selectionText = APTAnnouncementStrings.couldNotGetData;
      hasSelectionData = false;
    }
    else{
      if(announcement!.houseDetailSectionName == null){
        selectionText = APTAnnouncementStrings.collectionData;
        hasSelectionData = false;
      }
      else{
        selectionText = announcement!.houseDetailSectionName!;
      }

      //#. 대규모 택지지구
      if(announcement!.largeScaleDevelopmentDistrict != null){
        largeScale = announcement!.largeScaleDevelopmentDistrict == "Y" ? "대규모 택지 지구" : "대규모 택지 지구 아님";
      }
      else{
        largeScale = "대규모 택지 여부 취합중";
      }
      
      //#. 정비사업
      if(announcement!.redevelopmentBusiness != null){
        redevelopment = announcement!.redevelopmentBusiness == "Y" ? ", 정비사업" : "";
      }
      else{
        redevelopment = "정비사업 여부 취합중";
      }

      //#. 수도권내 민영 공공주택지구
      if(announcement!.capitalRegionPrivatePublicHousingDistrict != null){
        privatePublicHousing = announcement!.capitalRegionPrivatePublicHousingDistrict != "Y" ? "수도권내 민영공공주택지구" : "";
      }
      else{
        privatePublicHousing = "수도권내 면경 공공주택지구 여부 취합중";
      }

      //#. 공공주택 특별법
      if(announcement!.publicHousingSpecialLawApplication != null){
        specialLaw = announcement!.publicHousingSpecialLawApplication == "Y" ?
        (privatePublicHousing == "" ? "공공주택 특별법 적용" : ", 공공주택 특별법 적용") :
        "";
      }
      else{
        specialLaw = "공공주택 특별법 적용 여부 취합중";
      }

      //#. 투기과열지구
      if(announcement!.speculationOverheatedDistrict == "Y"){
        overheat = "투기과열지구";
      }

      //#. 조정대상지역
      if(announcement!.marketAdjustmentTargetAreaSection == "Y"){
        adjustTarget = overheat == null ? "조정대상지역" : " ,조정대상지역";
      }

      //#. 분양가 상한제
      if(announcement!.priceCapApplication == "Y"){
        priceCanApp = (overheat == null && adjustTarget == null)  ? "조정대상지역" : " ,조정대상지역";
      }

    }

    return InfoBoxWidget(
        child: Center(
          child: SizedBox(
            width: 260.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(15.w),
                SubTitleWidget(
                  text: "청약홈런 청약 가이드",
                  leftPadding: 12.w,
                  width: 260.w,
                ),
                Gap(17.w),
                DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black
                  ),
                  child: Column(
                    children: [
                      //#. 주택 유형
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          const Text("주택 유형 : "),
                          Text(
                            selectionText,
                            style: TextStyle(
                              color: hasSelectionData ? Palette.defaultRed : Palette.brightMode.darkText,
                              fontWeight: hasSelectionData ?  FontWeight.w600 : FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                      Gap(17.w),

                      //#. 택지 유형
                      //TODO 너무 길어서 짤림
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          const Text("주택 유형 : "),
                          Builder(
                              builder: (context) {
                                if(privatePublicHousing == "" && specialLaw == ""){
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            largeScale,
                                            style: const TextStyle(
                                                color: Palette.defaultRed,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            redevelopment,
                                            style: const TextStyle(
                                                color: Palette.defaultRed,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(17.w),
                                    ],
                                  );
                                }
                                else{
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            largeScale,
                                            style: const TextStyle(
                                                color: Palette.defaultRed,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            redevelopment,
                                            style: const TextStyle(
                                                color: Palette.defaultRed,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.w, bottom: 10.w),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                             Text(
                                              "* ",
                                              style: TextStyle(
                                                fontSize: 9.sp
                                              ),
                                            ),
                                            Text(
                                              privatePublicHousing,
                                              style: TextStyle(
                                                  fontSize: 9.sp
                                              ),
                                            ),
                                            // Text(
                                            //   specialLaw,
                                            //   style: TextStyle(
                                            //       fontSize: 9.sp
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                          ),
                        ],
                      ),
                      //#. 규제 지역 여부
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          const Text("규제 지역 여부: "),
                          DefaultTextStyle(
                            style: const TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
                            ),
                            child: Builder(
                              builder: (context) {
                                if(overheat == null && adjustTarget == null && priceCanApp == null){
                                  return const Text("비규제 지역");
                                }
                                else{
                                  return Row(
                                    children: [
                                      Text(overheat ?? ""),
                                      Text(adjustTarget ?? ""),
                                      Text(priceCanApp ?? ""),
                                    ]
                                  );
                                }
                              }
                            ),
                          ),
                        ],
                      ),
                      Gap(17.w),

                      //#. 재당첨 제한
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          Text("재당첨 제한 : "),
                          Text(
                            "10년",
                            style: TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Gap(17.w),

                      //#. 전매 기한
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          Text("전매 기한 : "),
                          Text(
                            "3년",
                            style: TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Gap(17.w),

                      //#. 거주의무기간
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          Text("거주의무기간 : "),
                          Text(
                            "5년",
                            style: TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
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
