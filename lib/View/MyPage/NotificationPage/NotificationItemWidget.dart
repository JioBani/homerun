import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Model/NotificationData.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    super.key,
    required this.notificationData
  });

  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 30.h, 50.w, 30.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide( // POINT
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notificationData.content,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 35.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20.h,),
          Text(
            notificationData.time.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30.sp,
                color: Colors.black45
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}