import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/ApplyHome/AptBasicInfo.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/SubTitleWidget.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:homerun/Style/Palette.dart';

class CheckListInfoWidget extends StatelessWidget {
  const CheckListInfoWidget({super.key, this.announcement});
  final AptBasicInfo? announcement;

  @override
  Widget build(BuildContext context) {
    final String selectionText;
    bool hasSelectionData = true;

    if(announcement == null){
      selectionText = APTAnnouncementStrings.couldNotGetData;
      hasSelectionData = false;
    }
    else if(announcement!.houseDetailSectionName == null){
      selectionText = APTAnnouncementStrings.collectionData;
      hasSelectionData = false;
    }
    else{
      selectionText = announcement!.houseDetailSectionName!;
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
                  text: "청약 체크리스트",
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
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          Text("주택 유형 : "),
                          Text(
                            "대규모 택지 지구",
                            style: TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Gap(3.w),
                      Text(
                        "*수도권내 민영공공주택지구, 공공주택 특별법 적용",
                        style: TextStyle(
                          fontSize: 9.sp
                        ),
                      ),
                      Gap(17.w),

                      //#. 규제 지역 여부
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle , color: Colors.amberAccent,
                            size: 16.sp,
                          ), //TODO 이미지 적용
                          Gap(6.w),
                          Text("규제 지역 여부: "),
                          Text(
                            "비규제 지역",
                            style: TextStyle(
                                color: Palette.defaultRed,
                                fontWeight: FontWeight.w600
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
