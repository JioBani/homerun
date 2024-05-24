import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Palette.dart';

class HousingSaleNoticesPage extends StatelessWidget {
  const HousingSaleNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text("청약홈런",
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.defaultBlue
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
