import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/ApplyHome/AptBasicInfo.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/ContentBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/Style/Palette.dart';

//TODO 오늘접수 이미지 넣기 - 공간이 부족해서 디자인 보고 작업해야할듯
class ScheduleInfoWidget extends StatelessWidget {
  ScheduleInfoWidget({super.key, required this.info});
  final AptBasicInfo? info;
  final String failText = "데이터를 가져 올 수 없습니다.";
  final String collectingText = "데이터 취합 중 입니다.";


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
    final String announcementData; //#. 입주자 모집 공고일
    final String specialData; //#. 특별 공급 접수일
    final String generalData1st; //#. 일반 공급 1차
    final String generalData2nd; //#. 일반 공급 2차
    final String winnerDate; //#. 당첨자 발표일
    final String signData; //#. 계약 체결

    final Widget announcementLeft = makeDaysLeftTextWidget(info!.recruitmentPublicAnnouncementDate?.toDate());
    final Widget specialLeft = makeDaysLeftTextWidget(info!.specialSupplyReceptionStartDate?.toDate());
    final Widget generalData1stLeft = makeDaysLeftTextWidget(info!.generalRank1CorrespondingAreaReceptionEndDate?.toDate());
    final Widget generalData2ndLeft = makeDaysLeftTextWidget(info!.generalRank2CorrespondingAreaReceptionStartDate?.toDate());

    if(info == null){
      announcementData = failText;
      specialData = failText;
      generalData1st = failText;
      generalData2nd = failText;
      winnerDate = failText;
      signData = failText;
    }
    else{
      announcementData = TimeFormatter.tryDateToKoreanString(info!.recruitmentPublicAnnouncementDate?.toDate()) ?? collectingText;
      specialData = TimeFormatter.tryDateToKoreanString(info!.specialSupplyReceptionStartDate?.toDate()) ?? collectingText;
      generalData1st = TimeFormatter.tryDateToKoreanString(info!.generalRank1CorrespondingAreaReceptionEndDate?.toDate()) ?? collectingText;
      generalData2nd = TimeFormatter.tryDateToKoreanString(info!.generalRank2CorrespondingAreaReceptionStartDate?.toDate()) ?? collectingText;
      winnerDate = TimeFormatter.tryDateToKoreanString(info!.prizeWinnerAnnouncementDate?.toDate()) ?? collectingText;
      signData = TimeFormatter.tryDateToKoreanString(info!.contractConclusionStartDate?.toDate()) ?? collectingText;
    }

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
                  text: "분양 일정",
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
                      Text(announcementData),
                      announcementLeft,
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
                      Text(specialData),
                      specialLeft
                    ],
                  ),
                ),
              ),
              Gap(5.w),
              //#. 일반 공급 1순위 접수일
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
                      Text(generalData1st),
                      generalData1stLeft
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
                      Text(generalData2nd),
                      generalData2ndLeft
                    ],
                  ),
                ),
              ),
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
                    winnerDate,
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
                    signData,
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
