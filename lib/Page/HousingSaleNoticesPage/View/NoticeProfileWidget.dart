import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/ApplyHome/AptBasicInfo.dart';
import 'package:homerun/Common/ApplyHome/SupplyMethod.dart';
import 'package:homerun/Common/PriceFormatter.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/Widget/HouseDetailTypeBoxWidget.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/Model/NoticeDto.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/AdNoticePage.dart';
import 'package:homerun/String/APTAnnouncementStrings.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

//TODO 특별공급 알림 박스 색 변경
class NoticeProfileWidget extends StatelessWidget {
  NoticeProfileWidget({super.key, required this.notice , required this.supplyMethod});

  final Notice notice;
  final SupplyMethod supplyMethod;

  late final String announcementDateText;
  late final String specialDateText;
  late final String generalDateText;
  late final String priceText;

  late final DateTime? announcementDate;
  late final DateTime? specialDate;
  late final DateTime? general1Data;
  late final DateTime? general2Data;
  late final DateTime? generalDate;

  void initData(){
    //#. 데이터 초기화
    var aptBasicInfo = notice.noticeDto?.applyHomeDto.aptBasicInfo;
    announcementDate = aptBasicInfo?.recruitmentPublicAnnouncementDate?.toDate();
    specialDate =  aptBasicInfo?.specialSupplyReceptionStartDate?.toDate();
    generalDate = aptBasicInfo?.generalSupplyReceptionStartDate?.toDate();
    general1Data = aptBasicInfo?.generalRank1CorrespondingAreaReceptionStartDate?.toDate();
    general2Data = aptBasicInfo?.generalRank2CorrespondingAreaReceptionStartDate?.toDate();

    announcementDateText = formatDate(announcementDate);
    specialDateText =  formatDate(specialDate);
    generalDateText = formatDate(generalDate);

    if(notice.noticeDto?.applyHomeDto != null){
      if(notice.noticeDto?.applyHomeDto.maxSupplyPrice == null || notice.noticeDto?.applyHomeDto.minSupplyPrice == null){
        priceText = APTAnnouncementStrings.collectionData;
      }
      else{
        priceText = "${PriceFormatter.formatToEokThousand(notice.noticeDto!.applyHomeDto.minSupplyPrice!.toDouble())} ~ "
            "${PriceFormatter.formatToEokThousand(notice.noticeDto!.applyHomeDto.maxSupplyPrice!.toDouble())}";
      }
    }
    else{
      priceText = APTAnnouncementStrings.couldNotGetData;
    }
  }

  String formatDate(DateTime? date){
    return TimeFormatter.tryDateToDatString(date) ?? "";
  }

  /// 왼쪽 상단 알림 박스 리스트 제작
  List<Widget> generateAlertBox(){
    List<Widget> result = [];

    //#. 중복될 가능성이 있지만 ui overflow를 방지하기 위해서 하나만 활성화 되도록 함
    if(announcementDate != null && TimeFormatter.calculateDaysDifference(announcementDate!) == 0){
      result.add(const AlertBoxWidget(text: "오늘공고",color: Palette.defaultRed,));
    }
    else if(specialDate != null && TimeFormatter.calculateDaysDifference(specialDate!) == 0){
      if(TimeFormatter.calculateDaysDifference(specialDate!) == 0){
        result.add(const AlertBoxWidget(text: "오늘 특별공급 접수",color: Palette.defaultOrange,));
      }
    }
    else if(generalDate != null && TimeFormatter.calculateDaysDifference(generalDate!) == 0){
      result.add(const AlertBoxWidget(text: "오늘 일반공급 접수",color: Colors.deepPurple,));

    }
    else if(general1Data != null && TimeFormatter.calculateDaysDifference(general1Data!) == 0){
      result.add(const AlertBoxWidget(text: "오늘 일반공급 1순위 접수",color: Colors.deepPurple,));

    }
    else if(general2Data != null && TimeFormatter.calculateDaysDifference(general2Data!) == 0){
      result.add(const AlertBoxWidget(text: "오늘 일반공급 2순위 접수",color: Colors.deepPurple,));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {

    initData();

    if(notice.noticeDto == null || notice.noticeDto!.applyHomeDto.aptBasicInfo == null){
      return Container(
        height: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.r),
          color : const Color(0xffF5F5F5),
        )
      );
    }

    NoticeDto noticeDto = notice.noticeDto!;
    AptBasicInfo aptInfo = notice.noticeDto!.applyHomeDto.aptBasicInfo!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.sp),
      child: InkWell(
        onTap: (){
          if(notice.hasError){
            CustomSnackbar.show("오류", "데이터를 가져오지 못했습니다.");
          }
          else{
            Get.to(AdNoticePage(notice: notice));
          }
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: const Color(0xffF9F9F9),
            //color : Color.fromRGBO(249, 249, 249, 1),
            boxShadow: [BoxShadow(offset: Offset(0, 2.w) , blurRadius: 2.r,color: Colors.black.withOpacity(0.25))]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //#. 상단 정보
              Row(
                children: [
                  //#. 청약상세 구분
                  HouseDetailTypeBoxWidget(text: aptInfo.houseDetailSectionName ?? '없음'),
                  //#. 알림 박스 리스트
                  ...generateAlertBox(),
                  const Spacer(),
                  //#. 좋아요
                  Icon(
                    Icons.favorite,
                    color: Palette.defaultRed,
                    size: 10.sp,
                  ), //TODO 이미지로 변경
                  Gap(4.w),
                  Text(
                    "좋아요 ${noticeDto.likes}",
                    style: TextStyle(
                        fontSize: 10.sp, //TODO 디자인은 8인데 10으로 키움
                        color: Palette.brightMode.darkText
                    ),
                  ),
                  Gap(6.w),
                  //#. 조회수
                  Image.asset(NoticePageImages.star),
                  Gap(4.w),
                  Text(
                    "조회수 ${noticeDto.views}",
                    style: TextStyle(
                      fontSize: 10.sp, //TODO 디자인은 8인데 10으로 키움
                      color: Palette.brightMode.darkText
                    ),
                  )
                ],
              ),
              Gap(8.w),
              //#. 주택 이름
              Row(
                children: [
                  Image.asset(
                    HousingSaleNoticesPageImages.home,
                    width: 12.sp,
                    height: 12.sp,
                  ),
                  Gap(5.w),
                  Text(
                    noticeDto.houseName,
                    style: TextStyle(
                      color: const Color(0xff3F3D3D),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp
                    ),
                  ),
                ],
              ),
              Gap(15.w),
              //#. 사진 및 상세 정보
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //#. 사진
                  Image.asset(
                    TestImages.apt,
                    width: 110.w,
                    height: 125.w,
                    fit: BoxFit.fitHeight,
                  ),
                  Gap(10.w),
                  //#. 상세 정보
                  Expanded(
                    child: SizedBox(
                      height: 125.w,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        ),
                        child: Column(
                          children: [
                            //#. 일정
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.w),
                              decoration: BoxDecoration(
                                color : Theme.of(context).primaryColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(2.r)
                              ),
                              child: Column(
                                children: [
                                  //#. 공오 일자
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.primary,),
                                      Gap(4.w),
                                      const Text("공고일자"),
                                      const Spacer(),
                                      Text(announcementDateText), //#. 공고 일자는 지나는 것이 의미가 없기 때문에
                                    ],
                                  ),
                                  //#. 특별공급 접수일
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.defaultRed,),
                                      Gap(4.w),
                                      const Text("특별공급 접수"),
                                      const Spacer(),
                                      DateText(dateTime : specialDate),
                                    ],
                                  ),
                                  //#. 일반공급 1순위 접수
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.defaultRed,),
                                      Gap(4.w),
                                      Text(noticeDto.supplyMethod == SupplyMethod.General ? "일반공급 1순위 접수" : "일반공급 접수"),
                                      const Spacer(),
                                      DateText(dateTime : noticeDto.supplyMethod == SupplyMethod.General ? general1Data : generalDate),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(8.w),
                            //#. 주소
                            Row(
                              children: [
                                Gap(5.sp + 8.w),
                                Expanded(
                                  child: Text(
                                    aptInfo.supplyLocationAddress ?? "",
                                    maxLines: 3,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            //#. 분양 가격
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "분양가",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.defaultRed
                                  ),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    priceText,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Palette.defaultRed
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Gap(15.w),
            ],
          ),
        ),
      ),
    );
  }
}

class StarImage extends StatelessWidget {
  const StarImage({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return  Image.asset(
      NoticePageImages.star,
      width: 5.sp,
      height: 5.sp,
      color: color,
    );
  }
}

//TODO 블러 radius 회의
class AlertBoxWidget extends StatelessWidget {
  const AlertBoxWidget({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.r),
        boxShadow: [BoxShadow(offset: Offset(0, 4.w), blurRadius: 10.r , color: Colors.black.withOpacity(0.25))]
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white
        ),
      ),
    );
  }
}

/// 청약 일정의 지남에 따라서 Text색을 변경하는 Text 위젯
class DateText extends StatelessWidget {
  const DateText({super.key, this.dateTime});
  final DateTime? dateTime;

  bool checkOver(){
    if(dateTime != null && dateTime!.difference(DateTime.now()) > Duration.zero){
      return false;
    }
    else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var text = dateTime == null ? "" : TimeFormatter.dateToDatString(dateTime!);
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: checkOver() ? Palette.brightMode.mediumText : Colors.black
      ),
    );
  }
}



