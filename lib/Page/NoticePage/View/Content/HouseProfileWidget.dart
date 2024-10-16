import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Feature/Notice/Model/NoticeDto.dart';
import 'package:homerun/Page/NoticePage/View/Content/SubTitleWidget.dart';
import 'package:homerun/Style/Palette.dart';

/// 공고 페이지에 가장 처음에 나오는 이미지 및 공고 일자, 아파트 명을 표시하는 프로필 위젯
class HouseProfileWidget extends StatelessWidget {
  const HouseProfileWidget({super.key, this.noticeDto});
  final NoticeDto? noticeDto;

  @override
  Widget build(BuildContext context) {
    
    String dateText = TimeFormatter.tryDateToDatString(noticeDto?.recruitmentPublicAnnouncementDate.toDate()) ?? "";
    
    return UnconstrainedBox(
      child: Container(
        height: 100.w,
        width: 310.w,
        color: const Color(0xffE7F2FF),
        child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r)
            ),
          ),
          child: Column(
            children: [
              Gap(8.w),
              //#. 공고일자
              SizedBox(
                width: 260.w,
                height: 20.w,
                child: Stack(
                  children: [
                    SubTitleWidget(
                      text: "공고 일자",
                      leftPadding: 13.w,
                      rightPadding: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 87.w),
                      child: Text(
                        dateText,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Palette.defaultDarkBlue
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //#. 주택명
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "고양 장향",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(10.w),
                    Text(
                      "아 테 라",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
