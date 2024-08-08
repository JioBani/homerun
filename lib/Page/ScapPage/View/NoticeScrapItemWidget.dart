import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/Widget/HouseDetailTypeBoxWidget.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrap.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class NoticeScrapItemWidget extends StatelessWidget {
  const NoticeScrapItemWidget({super.key});
  //final NoticeScrap noticeScrap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //#. 아파트 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            TestImages.irelia_6,
            width: 106.w,
            height: 64.w,
            fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(width: 7.w,),
        //#. 정보
        Expanded(
          child: SizedBox(
            height: 64.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //#. 지역 및 분양 상세 정보
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      //#. 지역
                      Text( //TODO 텍스트가 너무 작은듯?
                        "서울",
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(width:  2.w),
                      //#. 분양상세정보
                      HouseDetailTypeBoxWidget(text: "민간분양",)
                    ],
                  ),
                ),
                SizedBox(height: 9.w,),
                //#. 아파트명
                AutoSizeText(
                  "서울 서대문구 경희궁 유보라",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.brightMode.darkText,
                  ),
                  maxLines: 2,
                  minFontSize: 9,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                //#. 스크랩 날짜 및 청약 상태
                Text( //TODO 텍스트가 너무 작은듯?
                  "2024년 5월 01일 | 무순위 줍줍",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Palette.brightMode.mediumText
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width : 7.w),
        //#. 삭제버튼
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          decoration: BoxDecoration(
            border: Border.all(color: Palette.brightMode.mediumText),
            borderRadius: BorderRadius.circular(10.r)
          ),
          child: Text(
            "삭제",
            style: TextStyle(fontSize: 9.sp),
          ),
        )
      ],
    );
  }
}
