import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Page/NoticePage/View/ScrapIconButton.dart';

import 'LikeIconButton.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.notice});
  final Notice notice;

  final Color typeColor = const Color(0xffFF4545);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 58,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor : Colors.white,
      titleSpacing: 0,
      shadowColor: Colors.black.withOpacity(0.5),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //#. 아파트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                //#. 아파트 정보
                Row(
                  children: [
                    Text(
                      notice.noticeDto?.applyHomeDto.aptBasicInfo?.subscriptionAreaName ?? "알수없음",
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    Container(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: typeColor),
                        borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
                      ),
                      child: Text(
                        notice.noticeDto?.applyHomeDto.aptBasicInfo?.houseDetailSectionName ?? "알수없음",
                        style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.w700, //폰트 굵기가 미디움인데 작게 보여서 bold로 변경,
                            fontSize: 10.sp
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.w,),
                //#. 주택 이름
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AutoSizeText(
                    notice.noticeDto?.houseName ?? "알수없음",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Theme.of(context).primaryColor
                    ),
                    minFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ]
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LikeIconButton(noticeId: notice.id, width: 30, height: 30,iconSize: 30,),
              Gap(5.w),
              ScrapIconButton(noticeId: notice.id, width: 30, height: 30,iconSize: 30,),
              Gap(5.w),
              InkWell(
                onTap: (){},
                child: const Icon(
                  Icons.share_outlined,
                  size: 30,
                ),
              ),
              Gap(5.w),
              InkWell(
                onTap: (){},
                child: const Icon(
                  Icons.download_outlined,
                  size: 30,
                ),
              ),
              Gap(20.w),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58 + 40);
}


