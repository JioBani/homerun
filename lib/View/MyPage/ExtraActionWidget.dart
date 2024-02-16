import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExtraActionWidget extends StatelessWidget {
  const ExtraActionWidget({
    super.key,
    required this.iconData,
    required this.content,
    required this.page
  });

  final IconData iconData;
  final String content;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 5.h, 10.w, 5.h),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 24.sp,
            color: const Color.fromARGB(255, 153, 153, 153),
          ),
          SizedBox(width: 30.w,),
          Text(
            content,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.normal
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: (){
              Get.to(page);
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20.w,
              color: Colors.black,
            )
          )
        ],
      ),
    );
  }
}
