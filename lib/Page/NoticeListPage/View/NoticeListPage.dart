import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Common/Widget/CustomSearchBar.dart';
import 'package:homerun/Page/NoticeListPage/Value/SortType.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

import 'NoticePagedListView.dart';
import 'SortDropDownButtonWidget.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key, required this.supplyMethod});
  final SupplyMethod supplyMethod;

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  late final Map<SortType, NoticePagedListView> noticePagedListViewMap = {
    SortType.applicationDateUpcoming : NoticePagedListView(supplyMethod: widget.supplyMethod, sortType: SortType.applicationDateUpcoming),
    SortType.announcementDate : NoticePagedListView(supplyMethod: widget.supplyMethod, sortType: SortType.announcementDate),
    SortType.popularity : NoticePagedListView(supplyMethod: widget.supplyMethod, sortType: SortType.popularity),
  };

  SortType sortType = SortType.announcementDate;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: SortType.values.indexOf(sortType));
  }

  @override
  void dispose() {
    _pageController.dispose();

    for (var pagedListView in noticePagedListViewMap.values) {
      pagedListView.controller.pagingController.dispose();
    }
    super.dispose();
  }

  void _onSortTypeChanged(SortType newSortType) {
    setState(() {
      sortType = newSortType;
    });
    _pageController.jumpToPage(SortType.values.indexOf(newSortType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "분양정보",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.defaultSkyBlue,
              fontFamily: Fonts.title
          ),
        ),
        actions: [
          SortDropDownButtonWidget(
            startValue: sortType,
            onChanged: (value) {
              _onSortTypeChanged(value);
            },
          ),
          Gap(25.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Gap(8.w),
            const CustomSearchBar(),
            Gap(2.w),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    sortType = SortType.values[index];
                  });
                },
                children: noticePagedListViewMap.values.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
