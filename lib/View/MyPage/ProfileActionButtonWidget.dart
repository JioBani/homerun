import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/View/MyPage/ScrapPage/ScrapPage.dart';

class ProfileActionButtonWidget extends StatelessWidget {
  ProfileActionButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.page
  });

  final double iconSize = 100.w;
  final IconData icon;
  final String title;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: (){
              Get.to(page);
            },
            icon: Icon(
              icon,
              size: iconSize,
              color: Colors.black,
            )
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25.w
          ),
        )
      ],
    );
  }
}
