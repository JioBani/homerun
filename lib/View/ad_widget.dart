import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              content,
              style: TextStyle(
                  fontSize: 35.w,
                  fontWeight: FontWeight.bold
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: Image.asset(
                "assets/images/Ahri_15.jpg",
                width: 120.w,
                height: 120.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
