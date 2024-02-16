import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Model/PresaleDataReferenceData.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class LocationTabBarWidget extends StatelessWidget {
  const LocationTabBarWidget({super.key});

  List<Tab> tabBuilder(){
    return PresaleDataReferenceData.locations.map((location) =>
        Tab(
          child: SizedBox(
            width: 100.w,
            child: Center(
              child: Text(
                location,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                ),
              ),
            ),
          ),
        )
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabs: tabBuilder(),
      labelColor: Colors.blue, // 선택된 탭의 텍스트 색상 변경
      unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상 변경
      indicatorColor: Colors.blue, // 선택된 탭 아래의 밑줄 색상 변경
    );
  }
}