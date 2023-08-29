import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/MyPage/ExtraActionWidget.dart';
import 'package:homerun/View/MyPage/ProfileActionButtonWidget.dart';
import 'package:homerun/View/MyPage/QuestionPage/QuestionPage.dart';
import 'package:homerun/View/MyPage/ScrapPage/ScrapPage.dart';
import 'package:homerun/View/buttom_nav.dart';

import 'NotificationPage/NotificationPage.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});

  final double iconSize = 96.w;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/Ahri_15.jpg",
                      width: 200.w,
                      height: 200.w,
                    ),
                  ),
                  SizedBox(width: 20.w,),
                  Text(
                    "닉네임",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 50.w
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50.h,),
            Padding(
              padding: EdgeInsets.fromLTRB(50.w,  0, 50.w, 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileActionButtonWidget(
                    icon: Icons.notifications_none,
                    title: "알림설정",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.bookmark_border,
                    title: "스크랩 ? 북마크",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.notifications_none,
                    title: "알림설정",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.notifications_none,
                    title: "알림설정",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.notifications_none,
                    title: "알림설정",
                    page: ScrapPage(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            SizedBox(height: 30.h,),
            ExtraActionWidget(
              iconData: Icons.campaign,
              content: "공지사항",
              page: NotificationPage(),
            ),
            ExtraActionWidget(
              iconData: Icons.help_outline,
              content: "자주묻는 질문",
              page: QuestionPage(),
            ),
            ExtraActionWidget(
              iconData: Icons.campaign,
              content: "공지사항",
              page: NotificationPage(),
            ),
            ExtraActionWidget(
              iconData: Icons.campaign,
              content: "공지사항",
              page: NotificationPage(),
            ),
            ExtraActionWidget(
              iconData: Icons.campaign,
              content: "공지사항",
              page: NotificationPage(),
            ),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
