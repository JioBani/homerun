import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/HouseDetailTypeBoxWidget.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Page/NoticePage/View/AdNoticePage.dart';
import 'package:homerun/Page/ScapPage/Controller/ScrapPageController.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrap.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class NoticeScrapItemWidget extends StatefulWidget {
  const NoticeScrapItemWidget({super.key, required this.noticeScrap});
  final NoticeScrap noticeScrap;

  @override
  State<NoticeScrapItemWidget> createState() => _NoticeScrapItemWidgetState();
}

class _NoticeScrapItemWidgetState extends State<NoticeScrapItemWidget> {
  @override
  Widget build(BuildContext context) {
    Notice? notice = widget.noticeScrap.notice;
    var controller = Get.find<ScrapPageController>();

    final String dayAndSupplyMethodText =
        "${TimeFormatter.dateToKoreanString(widget.noticeScrap.noticeScrapDto.date.toDate())} "
        "| "
        "${widget.noticeScrap.notice?.noticeDto?.supplyMethod.koreanName ?? "알 수 없음"}";

    return Padding(
      padding: EdgeInsets.only(bottom: 25.w),
      child: InkWell(
        onTap : (){
          if(notice != null){
            Get.to(AdNoticePage(notice: notice));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //#. 아파트 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                TestImages.apt,
                width: 106.w,
                height: 64.w,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 7.w,),
            //#. 정보
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //#. 내용
                  SizedBox(
                    height: 64.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //#. 지역 및 분양 상세 정보
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              //#. 분양상세정보
                              HouseDetailTypeBoxWidget(text: notice?.noticeDto?.applyHomeDto.aptBasicInfo?.houseDetailSectionName ?? '없음',),
                              Gap(4.w),
                              //#. 지역
                              Text( //TODO 텍스트가 너무 작은듯?
                                notice?.noticeDto?.region?.koreanString ?? "알 수 없음",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.brightMode.darkText
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 9.w,),
                        //#. 아파트명
                        Expanded(
                          child: AutoSizeText(
                            notice?.noticeDto?.houseName ?? "",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Palette.brightMode.darkText,
                            ),
                            maxLines: 2,
                            minFontSize: 9,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        //#. 스크랩 날짜 및 청약 상태
                        Text( //TODO 텍스트가 너무 작은듯?
                          dayAndSupplyMethodText,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Palette.brightMode.mediumText
                          ),
                        ),
                      ],
                    ),
                  ),
                  //#. 삭제버튼
                  InkWell(
                    onTap: (){
                      CustomDialog.showConfirmationDialog(
                          context: context,
                          content: "삭제하시겠습니까?",
                          onConfirm: ()=>controller.deleteScrap(widget.noticeScrap)
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: Palette.brightMode.mediumText),
                          borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Text(
                        "삭제",
                        style: TextStyle(fontSize: 9.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width : 7.w),
          ],
        ),
      ),
    );
  }
}
