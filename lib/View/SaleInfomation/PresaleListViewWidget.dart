import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Model/PresaleDataSet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ProfileWidget.dart';

class PresaleListViewWidget extends StatefulWidget {
  const PresaleListViewWidget({super.key, required this.region, required this.category});
  final String region;
  final String category;

  @override
  State<PresaleListViewWidget> createState() => _PresaleListViewWidgetState();
}

class _PresaleListViewWidgetState extends State<PresaleListViewWidget> with AutomaticKeepAliveClientMixin {
  SaleInformationPageController saleInformationController = Get.find<SaleInformationPageController>();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<PreSaleData> presaleDataList = [];
  PreSaleDataSet? dataSet;
  GlobalKey footerKey = GlobalKey();
  late ListViewFooter listViewFooter;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listViewFooter = ListViewFooter(key : footerKey, refreshController: refreshController);
  }



  Future<void> _onLoad() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final bool hasItem = saleInformationController.addLimit(widget.category , widget.region);
    if(hasItem){
      refreshController.loadComplete();
    }
    else{
      refreshController.loadNoData();
      StaticLogger.logger.i("데이터 없음");
    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetX<SaleInformationPageController>(
        builder: (controller) {
          dataSet = controller.findDataSet(widget.category , widget.region);
          final int itemCount;
          if(dataSet != null){
            presaleDataList = dataSet!.dataList;
            itemCount = dataSet!.getRowCount();
          }
          else{
            presaleDataList = [];
            itemCount = 0;
          }

          return RefreshConfiguration(
            footerTriggerDistance: 200.h,
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: false,
              enablePullUp: true,
              onLoading: _onLoad,
              physics: const BouncingScrollPhysics(),
              footer: CustomFooter(
                onModeChange: (mode){
                  footerKey.currentState!.setState(() {});
                },
                builder: (BuildContext context,LoadStatus? mode){
                  return const SizedBox();
                },
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemCount + 1,
                itemBuilder: (BuildContext context, int index) {
                  if(index == itemCount){
                    return listViewFooter;
                  }
                  else{
                    try{
                      if(index * 2 + 1 >= presaleDataList.length){
                        return  ProfileRowWidget(
                          region: widget.region,
                          data0: presaleDataList[index * 2] ,
                          data1: null,
                        );
                      }
                      else {
                        return  ProfileRowWidget(
                          region: widget.region,
                          data0: presaleDataList[index * 2] ,
                          data1: presaleDataList[index * 2 + 1],
                        );
                      }
                    }catch(e){
                      return ProfileRowWidget(
                        region: widget.region,
                        data0: null ,
                        data1: null,
                      );
                    }
                  }
                },
              )
            ),
          );
        }
    );
  }
}

class ListViewFooter extends StatefulWidget {
  const ListViewFooter({super.key, required this.refreshController});
  final RefreshController refreshController;

  @override
  State<ListViewFooter> createState() => _ListViewFooterState();
}

class _ListViewFooterState extends State<ListViewFooter> {

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      final String str;
      if(widget.refreshController.footerStatus != null){
        switch(widget.refreshController.footerStatus!){
          case LoadStatus.idle : str = "위로 당겨서 더 많은 공고 보기";
          case LoadStatus.loading : str = "로딩중..";
          case LoadStatus.failed : str = "데이터를 가져올수 없습니다.";
          case LoadStatus.canLoading : str = "위로 당겨서 더 많은 공고 보기";
          case LoadStatus.noMore : str = "마지막 공고입니다.";
        }
      }
      else{
        str = "";
      }

      if(widget.refreshController.footerStatus == LoadStatus.loading){
        return const Center(child: CupertinoActivityIndicator(),);
      }
      else{
        return SizedBox(
          height: 50.h,
          child: Center(
              child:Text(
                str,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                ),
              )
          ),
        );
      }
    });
  }
}

