import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/AnnouncementPage/View/AnnouncementPage.dart';
import 'package:homerun/Page/ScapPage/View/ScrapPage.dart';
import 'package:homerun/Style/Palette.dart';

import 'ProfileWidget.dart';

class MyPageDrawer extends StatelessWidget {
  const MyPageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.w,),
            const ProfileWidget(),
            Expanded(
              child: ListView(
                children: [
                  MenuItemWidget(iconData: Icons.bookmark_border_outlined, text: "스크랩", onTap: (){},),
                  MenuItemWidget(iconData: Icons.folder_outlined, text: "공고스크랩", onTap: (){
                    Get.to(ScrapPage());
                  },),
                  MenuItemWidget(iconData: Icons.assignment_turned_in_outlined, text: "청약자격진단", onTap: (){},),
                  MenuItemWidget(iconData: Icons.settings_outlined, text: "설정", onTap: (){},),
                  MenuItemWidget(iconData: Icons.notifications_none_outlined, text: "알림설정", onTap: (){},),
                  MenuItemWidget(iconData: Icons.logout_outlined, text: "로그아웃", onTap: (){},),
                  MenuItemWidget(iconData: Icons.notifications_none_outlined, text: "공지사항", onTap: ()=>Get.to(const AnnouncementPage())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({super.key, required this.iconData, required this.text, required this.onTap});
  final IconData iconData;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    //TODO 아이콘 및 글자 크기 회의
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w , vertical: 5.w),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 20.sp,
              color: Palette.brightMode.mediumText
            ),
            SizedBox(width: 5.w,),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Palette.brightMode.mediumText
              ),
            )
          ],
        ),
      ),
    );
  }
}


