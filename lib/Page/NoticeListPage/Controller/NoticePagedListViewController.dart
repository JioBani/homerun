import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Feature/Notice/NoticeService.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../Value/SortType.dart';

class NoticePagedListViewController{
  final SupplyMethod supplyMethod;
  final List<Notice> noticeList = [];
  LoadingState loadingState = LoadingState.before;
  final SortType sortType;
  final int pageSize = 5;
  final Duration delay = const Duration(seconds: 1);

  PagingController<int,Notice> pagingController = PagingController(
    firstPageKey: 0,
    invisibleItemsThreshold: 1
  );

  NoticePagedListViewController({required this.supplyMethod , required this.sortType}){
    pagingController.addPageRequestListener((pageKey) => loadNotice(pageKey , 2));
  }

  Future<void> loadNotice(int pageKey, int count) async {
    loadingState = LoadingState.loading;

    //#. 딜레이
    await Future.delayed(delay);

    OrderType orderType;
    switch(sortType){
      case SortType.announcementDate : orderType = OrderType.announcementDate;
      case SortType.applicationDateUpcoming : orderType = OrderType.applicationDate;
      case SortType.popularity : orderType = OrderType.views;
    }

    Result<List<Notice>> result = await NoticeService.instance.getNotices(
      count: pageSize,
      orderType: orderType,
      startAfter: noticeList.isNotEmpty ? noticeList.last : null,
      supplyMethod : supplyMethod,
      descending: sortType != SortType.applicationDateUpcoming,
      applicationDateUpcoming: sortType == SortType.applicationDateUpcoming ?  DateTime.now() : null
    );

    if(result.isSuccess){
      //#. 덜가져온 경우 noMoreData
      if(result.content!.length < count){
        pagingController.appendLastPage(result.content!);

        loadingState = LoadingState.noMoreData;
      }
      else{
        pagingController.appendPage(result.content!, pageKey + result.content!.length);

        loadingState = LoadingState.success;
      }


      noticeList.addAll(result.content!);
    }
    else{
      StaticLogger.logger.e(result.exception);
      pagingController.error = result.exception;
      loadingState = LoadingState.fail;
      //update();
    }
  }
}