import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Palette.dart';

class CommentTabBarWidget extends StatelessWidget {
  const CommentTabBarWidget({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 28.w,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
        ),
        labelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        unselectedLabelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Palette.brightMode.mediumText
        ),
        tabs: const [
          Tab(
            text: '청약자격 댓글',
          ),

          Tab(
            text: '자유 댓글',
          ),
        ],
      ),
    );
  }
}
