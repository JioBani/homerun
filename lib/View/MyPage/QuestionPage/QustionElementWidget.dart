import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionElementWidget extends StatelessWidget {
  const QuestionElementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 20.h),
            child: Row(
              children: [
                Text(
                  "Q",
                  style: TextStyle(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueAccent
                  ),
                ),
                SizedBox(width: 35.w,),
                Text(
                  "주문내역은 어떻게 확인 할 수 있나요?",
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 75, 75, 75)
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
