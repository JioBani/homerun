import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryButtonWidget extends StatelessWidget {
  const CategoryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150.w,
          height: 150.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: Image.asset("assets/images/Ahri_15.jpg")
          ),
        ),
        Text("노부모")
      ],
    );
  }
}
