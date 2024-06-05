import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LargeIconButton extends StatelessWidget {
  const LargeIconButton({super.key, required this.text, required this.iconPath, required this.onTap});
  final String iconPath;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap(),
      child: Column(
        children: [
          SizedBox(
            width: 18.sp,
            height: 18.sp,
            child: Image.asset(
              iconPath,
            ),
          ),
          SizedBox(height: 3.w,),
          Text(
            text,
            style: TextStyle(
                fontSize: 7.sp
            ),
          )
        ],
      ),
    );
  }
}