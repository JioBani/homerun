import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../Controller/AnnouncementPageController.dart';
import '../Model/Announcement.dart';
import 'AnnouncementWidget.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  AnnouncementPageController controller = AnnouncementPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO abbar 높이가 디자인 보다 낮음
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.black.withOpacity(0.5), //#. elevation 효과를 위해
        centerTitle: true,
        title: Text(
          "공지사항",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.BCCard,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: PagedListView<int, Announcement>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Announcement>(
            itemBuilder: (context, item, index) => AnnouncementWidget(announcement: item.announcementDto!,),
            noMoreItemsIndicatorBuilder : (_) => Gap(50.w),
            noItemsFoundIndicatorBuilder : (_) => Gap(50.w),
            firstPageErrorIndicatorBuilder: (_) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5.w),
                child: Text(
                  "데이터를 불러 올 수 없습니다.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Palette.brightMode.mediumText
                  ),
                ),
              ),
            ),
            newPageErrorIndicatorBuilder: (_) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5.w),
                child: Text(
                  "데이터를 불러 올 수 없습니다.",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Palette.brightMode.mediumText
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
