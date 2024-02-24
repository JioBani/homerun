import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HousingNumberWidget extends StatelessWidget {
  const HousingNumberWidget({super.key, required this.name, required this.number});
  final String name;
  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 13.sp,
                color: const Color.fromRGBO(118, 118, 118, 1),
                fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Divider(
              color: Color.fromRGBO(118, 118, 118, 1),
            ),
          ),
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 18.sp,
                color: const Color.fromRGBO(118, 118, 118, 1),
                fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
