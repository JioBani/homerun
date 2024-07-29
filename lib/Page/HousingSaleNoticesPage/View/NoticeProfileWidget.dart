import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Page/NoticesPage/ApplyhomeCodeConverter.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/View/AdNoticePage.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NoticeProfileWidget extends StatelessWidget {
  const NoticeProfileWidget({super.key, required this.notice});
  final Notice notice;

  @override
  Widget build(BuildContext context) {
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
          height: 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: const Color(0xffFBFAFA),
          ),
          child: Row(
            children: [
              Image.asset(
                TestImages.ashe_43,
                width: 120.w,
                height: 120.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w , vertical: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          //지역 텍스트
                          Text(
                            ApplyhomeCodeConverter.tryConvertRegionCode(notice.noticeDto?.info?.subscriptionAreaCode),
                            style: TextStyle(
                              fontSize: 8.sp,
                            ),
                          ),
                          SizedBox(width: 2.w,),
                          //분양 유형
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xffFF4545)),
                              borderRadius: BorderRadius.circular(2.r)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              notice.noticeDto?.info?.houseDetailSectionName ?? '',
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: const Color(0xffFF4545)
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "조회수 ${notice.noticeDto?.views}",
                            style: TextStyle(
                              fontSize: 8.sp,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 6.w,),
                      Row(
                        children: [
                          Image.asset(
                            HousingSaleNoticesPageImages.pinMap,
                            width: 10.sp,
                            height: 10.sp,
                          ),
                          SizedBox(width: 4.w,),
                          Expanded(
                            child: AutoSizeText(
                              notice.noticeDto?.houseName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13.sp),
                              minFontSize: 10,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "- ${notice.noticeDto?.info?.houseSectionName} | "
                        "공급규모 : ${notice.noticeDto?.info?.totalSupplyHouseholdCount}세대",
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                      ),
                      AutoSizeText(
                        "- 청약접수 : ${notice.noticeDto?.info?.applicationReceptionStartDate} ~ ${notice.noticeDto?.info?.applicationReceptionEndDate}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp),
                        minFontSize: 2,
                        maxLines: 1,
                      ),
                      Text(
                        "- 건설사 : ${notice.noticeDto?.info?.constructionEnterpriseName}",
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
