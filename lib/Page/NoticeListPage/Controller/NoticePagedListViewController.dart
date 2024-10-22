import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
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
  final SortType sortType;
  final int pageSize = 5;
  final Duration delay = const Duration(seconds: 1);

  LoadingState loadingState = LoadingState.before;

  bool isSearch = false;
  List<Region>? regions;
  List<HouseType>? houseType;


  PagingController<int,Notice> pagingController = PagingController(
    firstPageKey: 0,
    invisibleItemsThreshold: 1
  );

  NoticePagedListViewController({required this.supplyMethod , required this.sortType}){
    pagingController.addPageRequestListener(loadNoticeAction);
  }

  void loadNoticeAction(pageKey) => loadNotice(pageKey);

  Future<void> loadNotice(int pageKey) async {
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
      startAfter: pagingController.itemList?.isNotEmpty == true ? pagingController.itemList!.last : null,
      supplyMethod : supplyMethod,
      descending: sortType != SortType.applicationDateUpcoming,
      applicationDateUpcoming: sortType == SortType.applicationDateUpcoming ?  DateTime.now() : null,
      regions: regions,
      //houseType
    );

    if(result.isSuccess){
      //#. 덜가져온 경우 noMoreData
      if(result.content!.length < pageSize){
        pagingController.appendLastPage(result.content!);

        loadingState = LoadingState.noMoreData;
      }
      else{
        pagingController.appendPage(result.content!, pageKey + result.content!.length);

        loadingState = LoadingState.success;
      }
    }
    else{
      StaticLogger.logger.e(result.exception);
      pagingController.error = result.exception;
      loadingState = LoadingState.fail;
      //update();
    }
  }

  void setSearch(List<Region>? regions, List<HouseType>? houseType){
    isSearch = !(regions == null && houseType == null);

    this.regions = regions;
    this.houseType = houseType;

    pagingController.refresh();
  }
}