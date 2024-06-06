import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/Common/Widget/LargetIconButton.dart';
import 'package:homerun/Page/Common/Widget/SmallIconButton.dart';
import 'package:homerun/Style/Images.dart';

class AdNoticePage extends StatelessWidget {
  const AdNoticePage({super.key});

  final Color typeColor = const Color(0xffFF4545);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 17.w,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 25.w,),
                InkWell(
                  onTap: ()=>Get.back(),
                  child: SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: Image.asset(
                      Images.backIcon,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                LargeIconButton(iconPath: Images.partnershipAd, text: "제휴광고",onTap: (){},),
                SizedBox(width: 7.w,),
                LargeIconButton(iconPath: Images.adInquiry, text: "광고문의",onTap: (){},),
                SizedBox(width: 25.w,)
              ],
            ),
            SizedBox(height: 22.w,),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Row(
                children: [
                  Text("서울"),
                  SizedBox(width: 4.w,),
                  Container(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: typeColor),
                      borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
                    ),
                    child: Text(
                      "민간분양",
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w700 //폰트 굵기가 미디움인데 작게 보여서 bold로 변경
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.w,),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 12.sp,
                    height: 12.sp,
                    child: Image.asset(
                      HousingSaleNoticesPageImages.pinMap
                    ),
                  ),
                  SizedBox(width: 4.w,),
                  Text(
                    "서대문구 월드 메리앙",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallIconButton(iconPath: Images.heart, text: "좋아요", onTap: (){}),
                SizedBox(width: 4.w,),
                SmallIconButton(iconPath: Images.scrap, text: "스크랩", onTap: (){}),
                SizedBox(width: 4.w,),
                SmallIconButton(iconPath: Images.share, text: "공유", onTap: (){}),
                SizedBox(width: 17.w,)
              ],
            ),
            SizedBox(height: 6.w,)
          ],
        ),
      ),
    );
  }
}


