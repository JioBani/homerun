import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/View/KakaoLogin/KakaoLoginPage.dart';

class ExtraGuideWidget extends StatelessWidget {
  const ExtraGuideWidget({super.key, required this.name, required this.description});

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.w , left: 20.w),
      child: SizedBox(
        height: 250.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: TextStyle(
                fontSize: 30.w,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10.w,),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: SizedBox(
                      height: 175.w,
                      width: 175.w,
                      child: ClipRRect(
                        child: Image.asset('assets/images/Ahri_15.jpg'),
                        borderRadius: BorderRadius.circular(20.0.w),
                      ),
                    ),
                    onTap: ()=>{Get.to(KakaoLoginPage(title: "gd"))},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.w),
                          child: Text(
                            description,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.w
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: Text(
                            description,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25.w
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
