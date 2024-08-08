import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HouseDetailTypeBoxWidget extends StatelessWidget {
  const HouseDetailTypeBoxWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffFF4545)),
        borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Color(0xffFF4545),
            fontWeight: FontWeight.w600 //폰트 굵기가 미디움인데 작게 보여서 bold로 변경
        ),
      ),
    );
  }
}
