import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/ApplyHome/AptBasicInfo.dart';
import 'package:homerun/Common/ApplyHome/SupplyMethod.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Page/NoticesPage/Model/NoticeDto.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/ContentBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:homerun/Style/Palette.dart';

//TODO 오늘접수 이미지 넣기 - 공간이 부족해서 디자인 보고 작업해야할듯
class ScheduleInfoWidget extends StatelessWidget {
  ScheduleInfoWidget({super.key, this.noticeDto}){
    if(noticeDto?.applyHomeDto.aptBasicInfo != null){
      AptBasicInfo info = noticeDto!.applyHomeDto.aptBasicInfo!;
      supplyMethod = noticeDto!.supplyMethod;

      announcementLeft = makeDaysLeftTextWidget(info.recruitmentPublicAnnouncementDate?.toDate());
      specialLeft = makeDaysLeftTextWidget(info.specialSupplyReceptionStartDate?.toDate());

      announcementData = TimeFormatter.tryDateToKoreanString(info.recruitmentPublicAnnouncementDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      specialData = TimeFormatter.tryDateToKoreanString(info.specialSupplyReceptionStartDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      generalData1st = TimeFormatter.tryDateToKoreanString(info.generalRank1CorrespondingAreaReceptionEndDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      generalData2nd = TimeFormatter.tryDateToKoreanString(info.generalRank2CorrespondingAreaReceptionStartDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      winnerDate = TimeFormatter.tryDateToKoreanString(info.prizeWinnerAnnouncementDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      signData = TimeFormatter.tryDateToKoreanString(info.contractConclusionStartDate?.toDate()) ?? APTAnnouncementStrings.collectionData;
      generalDate = TimeFormatter.tryDateToKoreanString(info.generalSupplyReceptionStartDate?.toDate()) ?? APTAnnouncementStrings.collectionData;


      if(supplyMethod == SupplyMethod.General){
        generalData1stLeft = makeDaysLeftTextWidget(info.generalRank1CorrespondingAreaReceptionEndDate?.toDate());
        generalData2ndLeft = makeDaysLeftTextWidget(info.generalRank2CorrespondingAreaReceptionStartDate?.toDate());
      }
      else{
        generalDateLeft =  makeDaysLeftTextWidget(info.generalSupplyReceptionStartDate?.toDate());
      }
    }
    else{
      announcementData =
          specialData =
          generalData1st =
          generalData2nd =
          winnerDate =
          signData =
          generalDate =
          announcementLeft =
          specialLeft =
          generalData1stLeft =
          generalData2ndLeft =
          generalDateLeft =
          supplyMethod = null;
    }
  }

  final NoticeDto? noticeDto;

  late final String? announcementData; //#. 입주자 모집 공고일
  late final String? specialData; //#. 특별 공급 접수일
  late final String? generalData1st; //#. 일반 공급 1차
  late final String? generalData2nd; //#. 일반 공급 2차
  late final String? winnerDate; //#. 당첨자 발표일
  late final String? signData; //#. 계약 체결
  late final String? generalDate;

  late final Widget? announcementLeft;
  late final Widget? specialLeft;
  late final Widget? generalData1stLeft;
  late final Widget? generalData2ndLeft;
  late final Widget? generalDateLeft;

  late final SupplyMethod? supplyMethod;

  /// 남은 일에 따라 마감, 오늘접수, x일 남음 반환
  String makeDaysLeftText(int days){
    if(days < 0){
      return "마감"; //TODO 어떤 단어 쓸지 회의
    }
    else if(days == 0){
      return "오늘접수";
    }
    else{
      return "$days일 남음";
    }
  }

  /// 남은 일자 위젯 제작 함수
  Widget makeDaysLeftTextWidget(DateTime? dateTime){
    if(dateTime == null){
      return const SizedBox();
    }

    int days = TimeFormatter.calculateDaysDifference(dateTime);

    if(0 <= days && days <= 3){ //#. 0 ~ 3일 남았을떄
      return Expanded(
        child: Center(
          child: Container(
            width: 35.w,
            height: 13.w,
            decoration: BoxDecoration(
                color: Palette.defaultRed,
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: [BoxShadow(
                    offset: Offset(0, 4.w),
                    blurRadius: 4.r,
                    color: Colors.black.withOpacity(0.25)
                )]
            ),
            child: Text(
              makeDaysLeftText(days),
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp
              ),
            ),
          ),
        ),
      );
    }
    else{
      return Expanded( //#. 3일 초과
        child: Text(
          makeDaysLeftText(days),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 9.sp,
              color: Palette.defaultRed,
              fontWeight: FontWeight.w600
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(noticeDto?.applyHomeDto.aptBasicInfo == null){
      return InfoBoxWidget(
        child: Column(
          children: [
            Gap(17.w),
            SubTitleWidget(
                text: "청약 일정", //TODO 이야기하기
                leftPadding: 12.w
            ),
            SizedBox(
              height: 100.w,
              child: Center(
                child: Text(
                  APTAnnouncementStrings.couldNotGetData,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.brightMode.darkText
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return InfoBoxWidget(
          child: DefaultTextStyle(
            style: TextStyle(
                fontSize: 11.sp,
                color: Palette.brightMode.darkText
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(15.w),
                SubTitleWidget(
                    text: "청약 일정", //TODO 이야기하기
                    leftPadding: 12.w
                ),
                Gap(11.w),
                //#. 입주자모집 공고일
                ContentBoxWidget(
                  title: "입주자모집 공고일",
                  titleWidth: 100.w,
                  titleFontSize: 10.sp,
                  contentWidth: 160.w,
                  content: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 8.5.w, 0, 8.5.w),
                    child: Row(
                      children: [
                        Text(announcementData!),
                        announcementLeft!,
                      ],
                    ),
                  ),
                ),
                Gap(5.w),
                //#. 특별 공급 접수일
                ContentBoxWidget(
                  title: "특별 공급 접수일",
                  titleWidth: 100.w,
                  titleFontSize: 10.sp,
                  contentWidth: 160.w,
                  content: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 8.5.w, 0, 8.5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(specialData!),
                        specialLeft!
                      ],
                    ),
                  ),
                ),
                Gap(5.w),
                Builder(builder: (_){
                  if(supplyMethod! == SupplyMethod.General){
                    return Column(
                      children: [
                        ContentBoxWidget(
                          title: "일반 공급 1순위 접수일",
                          titleWidth: 100.w,
                          titleFontSize: 10.sp,
                          contentWidth: 160.w,
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 8.5.w, 0, 8.5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(generalData1st!),
                                generalData1stLeft ?? const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                        Gap(5.w),
                        //#. 일반 공급 2순위 접수일
                        ContentBoxWidget(
                          title: "일반 공급 2순위 접수일",
                          titleWidth: 100.w,
                          titleFontSize: 10.sp,
                          contentWidth: 160.w,
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 8.5.w, 0, 8.5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(generalData2nd!),
                                generalData2ndLeft ?? const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  else{
                    return Column(
                      children: [
                        //#. 일반 공급 2순위 접수일
                        ContentBoxWidget(
                          title: "일반 공급 접수일",
                          titleWidth: 100.w,
                          titleFontSize: 10.sp,
                          contentWidth: 160.w,
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 8.5.w, 0, 8.5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(generalDate!),
                                generalDateLeft ?? const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
                //#. 일반 공급 1순위 접수일
                Gap(5.w),
                //#. 당첨자 발표일
                ContentBoxWidget(
                  title: "당첨자 발표일",
                  titleWidth: 100.w,
                  titleFontSize: 10.sp,
                  contentWidth: 160.w,
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.5.w , horizontal: 18.w),
                    child: Text(
                      winnerDate!,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Gap(5.w),
                //#. 계약 체결
                ContentBoxWidget(
                  title: "계약 체결",
                  titleWidth: 100.w,
                  titleFontSize: 10.sp,
                  contentWidth: 160.w,
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.5.w , horizontal: 18.w),
                    child: Text(
                      signData!,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Gap(17.w),
              ],
            ),
          )
      );
    }
  }
}
