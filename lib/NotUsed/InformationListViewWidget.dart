/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/SaleInfomation/SaleInformationPageController.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'CategoryTabbarViewPageWidget.dart';
import 'ProfileWidget.dart';

class InformationListViewWidget extends StatefulWidget {
  const InformationListViewWidget({super.key, required this.region});
  final String region;

  @override
  State<InformationListViewWidget> createState() => _InformationListViewWidgetState();
}

class _InformationListViewWidgetState extends State<InformationListViewWidget>  with AutomaticKeepAliveClientMixin{
   SaleInformationPageController saleInformationController = Get.find<SaleInformationPageController>();

   @override
   bool get wantKeepAlive => true;

   @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreService.instance.getDataStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // 데이터가 도착하면 화면에 표시
        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        saleInformationController.refreshData(
            documents.map((document) => PreSaleData.fromDocumentSnapshot(document)).toList()
        );

        return PreSaleInfoList(region: widget.region,);
      },
    );
  }
}

class PreSaleInfoList extends StatefulWidget {
  const PreSaleInfoList({super.key, required this.region});
  final String region;

  @override
  State<PreSaleInfoList> createState() => _PreSaleInfoListState();
}

class _PreSaleInfoListState extends State<PreSaleInfoList>   with AutomaticKeepAliveClientMixin{

  SaleInformationPageController saleInformationController = Get.find<SaleInformationPageController>();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;


  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1));
    StaticLogger.logger.i("_onLoad");
    saleInformationController.addLimitRegion(widget.region);
    setState(() {

    });
    refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    return GetX<SaleInformationPageController>(
      builder: (controller) {
        return Scrollbar(
          child: SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            onLoading: _onLoad,
            physics: BouncingScrollPhysics(),
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            child: ListView.builder(
              itemCount: controller.getItemCount(widget.region),
              itemBuilder: (BuildContext context, int index) {
                if( index * 2 + 1 >= controller.dataByRegion[widget.region]!.dataList.length){
                  return  ProfileRowWidget(index: [index * 2 , -1], region: widget.region,);
                }
                else {
                  return ProfileRowWidget(index: [index * 2 , index * 2 + 1],region: widget.region);
                }
              },
            ),
          ),
        );
      }
    );
  }
}

*/
