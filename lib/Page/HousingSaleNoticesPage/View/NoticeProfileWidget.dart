import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/HouseDetailTypeBoxWidget.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Page/NoticesPage/ApplyhomeCodeConverter.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/Model/NoticeDto.dart';
import 'package:homerun/Page/NoticesPage/View/AdNoticePage.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NoticeProfileWidget extends StatelessWidget {
  const NoticeProfileWidget({super.key, required this.notice});
  final Notice notice;

  @override
  Widget build(BuildContext context) {

    if(notice.noticeDto == null || notice.noticeDto!.info == null){
      return Container(
        height: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.r),
          color : const Color(0xffF5F5F5),
        )
      );
    }

    NoticeDto noticeDto = notice.noticeDto!;
    APTAnnouncement aptInfo = notice.noticeDto!.info!;

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
              //#. 청약상세 구분 및 조회수
              Row(
                children: [
                  //#. 청약상세 구분
                  HouseDetailTypeBoxWidget(text: aptInfo.houseDetailSectionName ?? '없음'),
                  const Spacer(),
                  Image.asset(NoticePageImages.star),
                  Gap(4.w),
                  //#. 조회수
                  Text(
                    "조회수 ${noticeDto.views}",
                    style: TextStyle(
                      fontSize: 10.sp, //TODO 디자인은 8인데 10으로 키움
                      color: Palette.brightMode.darkText
                    ),
                  )
                ],
              ),
              Gap(12.w),
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
                            //#. 오늘공고
                            Container(
                              padding : EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.w),
                              decoration: BoxDecoration(
                                color : Theme.of(context).primaryColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(2.r)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.primary,),
                                      Gap(4.w),
                                      const Text("오늘공고"),
                                      const Spacer(),
                                      const Text("2024.06.30"),
                                    ],
                                  ),
                                  //#. 특별공급 접수일
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.defaultRed,),
                                      Gap(4.w),
                                      const Text("특별공급 접수"),
                                      const Spacer(),
                                      const Text("2024.06.30"),
                                    ],
                                  ),
                                  //#. 일반공급 1순위 접수
                                  Row(
                                    children: [
                                      const StarImage(color: Palette.defaultRed,),
                                      Gap(4.w),
                                      const Text("일반공급 1순위 접수"),
                                      const Spacer(),
                                      const Text("2024.06.30"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(8.w),
                            Row(
                              children: [
                                Gap(5.sp + 8.w),
                                Text(
                                  "APT/공급규모: 200세대\n"
                                      "서울 서대문구 영천동 60-20 120필지\n"
                                      "건설사: 현대엔지니어링",
                                  style: TextStyle(
                                      color: Palette.brightMode.darkText,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.normal
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Gap(5.sp + 8.w),
                                Text(
                                  "분양가격",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.defaultRed
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "1.9 ~ 2.5 억",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.defaultRed
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

