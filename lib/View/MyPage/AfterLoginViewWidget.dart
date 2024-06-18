import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Controller/KakaoLoginPageController.dart';
import 'package:homerun/Controller/LoginController.dart';
import 'package:homerun/Service/LoginService.dart';

import 'ProfileActionButtonWidget.dart';
import 'ScrapPage/ScrapPage.dart';
import 'package:get/get.dart';

class AfterLoginViewWidget extends StatelessWidget {
  AfterLoginViewWidget({super.key});

  LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        height: 600.h,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 25.h,),
            Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      LoginService.instance.user?.kakaoAccount?.profile?.profileImageUrl ?? "",
                      errorBuilder: (context , exception ,stackTrace,){
                        return SizedBox(
                          width: 50.w,
                          height: 50.w,
                        );
                      },
                      width: 50.w,
                      height: 50.w,
                    )
                  ),
                  SizedBox(width: 10.w,),
                  Text(
                    LoginService.instance.user?.kakaoAccount?.profile?.nickname ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  ElevatedButton(
                      onPressed: (){
                        controller.logout();
                      },
                      child: Text("로그아웃")
                  ),
                  SizedBox(width: 50.w,)
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
                    icon: Icons.favorite_border,
                    title: "좋아요",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.attach_money,
                    title: "유료이용",
                    page: ScrapPage(),
                  ),
                  ProfileActionButtonWidget(
                    icon: Icons.headset_mic_outlined,
                    title: "컨설팅 신청",
                    page: ScrapPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
