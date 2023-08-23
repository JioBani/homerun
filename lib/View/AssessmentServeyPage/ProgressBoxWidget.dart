import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class ProgressBoxWidget extends StatelessWidget {
  const ProgressBoxWidget({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 100.w,
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [ShadowPalette.defaultShadowLight]
      ),
      child: Center(
        child: Text(
            content,
          style: TextStyle(
            fontSize: 30.w,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }
}