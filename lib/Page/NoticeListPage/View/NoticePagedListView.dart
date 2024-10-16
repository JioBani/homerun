import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Page/NoticeListPage/Controller/NoticePagedListViewController.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../HousingSaleNoticesPage/View/NoticeProfileWidget.dart';
import '../Value/SortType.dart';

class NoticePagedListView extends StatelessWidget {
  NoticePagedListView({super.key , required this.supplyMethod, required this.sortType}){
    controller = NoticePagedListViewController(
        supplyMethod : supplyMethod,
        sortType: sortType
    );
  }

  late final NoticePagedListViewController controller;
  final SupplyMethod supplyMethod;
  final SortType sortType;

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Notice>(
      pagingController: controller.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Notice>(
        itemBuilder: (context, item, index) =>
            NoticeProfileWidget(
              notice: item,
              supplyMethod: supplyMethod,
            ),
        noMoreItemsIndicatorBuilder : (_) => Center(
            child: Padding(
              padding: EdgeInsets.only(top:10.w , bottom: 20.w),
              child: Text(
                "마지막 공고입니다.",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
                ),
              ),
            )
        ),
        //#. 새 페이지 오류
        newPageErrorIndicatorBuilder: (_) => Center(
            child: Padding(
              padding: EdgeInsets.only(top:10.w , bottom: 20.w),
              child: Text(
                "데이터를 가져 올 수 없습니다.",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
                ),
              ),
            )
        ),
        //#. 첫 페이지 오류
        firstPageErrorIndicatorBuilder: (_) => Center(
            child: Padding(
              padding: EdgeInsets.only(top:10.w , bottom: 20.w),
              child: Text(
                "데이터를 가져 올 수 없습니다.",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
                ),
              ),
            )
        ),
      ),
    );
  }
}