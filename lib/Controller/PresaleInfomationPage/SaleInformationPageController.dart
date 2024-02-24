import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Model/PresaleDataSet.dart';


class SaleInformationPageController extends GetxController{

  final ScrollController scrollController = ScrollController();
  RxList<HousingData> presaleDataAllList = List<HousingData>.empty().obs;
  List<DocumentSnapshot> preSaleSnapshotList = List<DocumentSnapshot>.empty();
  RxMap<String , int> limits = RxMap();
  RxMap<String , RxMap<String , PreSaleDataSet>> dataList = RxMap.from(
    {
      '없음' :  RxMap<String , PreSaleDataSet>(),
      '분양중' :  RxMap<String , PreSaleDataSet>(),
      '분양예정' :  RxMap<String , PreSaleDataSet>(),
      '분양완료' :  RxMap<String , PreSaleDataSet>(),
    }
  );


  PreSaleDataSet? findDataSet(String category , String region){
    try{
      return dataList[category]![region]!;
    }catch(e){
      return null;
    }
  }

  int getRowCount(String category , String region){
    var dataSet = findDataSet(category , region);
    if(dataSet != null){
      return dataSet.getRowCount();
    }
    else{
      return 0;
    }
  }

  void refreshAllData(List<HousingData> datas){

    presaleDataAllList.assignAll(datas);

    dataList.forEach((key, listByRegion) {
      listByRegion.forEach((key, value) {
        value.resetDataList();
      });
    });

    datas.forEach((element) {
      try{
        RxMap<String , PreSaleDataSet> targetList = dataList[element.category]!;

        if(targetList.containsKey(element.region)){
          targetList[element.region]!.dataList.add(element);
        }
        else{
          var data = PreSaleDataSet(<HousingData>[]);
          data.dataList.add(element);
          targetList[element.region] = data;
        }
      }
      catch(e){
        StaticLogger.logger.e(e);
      }
    });

    dataList.forEach((key, listByRegion) {
      listByRegion.forEach((key, value) {
        value.resetViewCount();
      });
    });

  }

  PreSaleDataSet? findDataList(String category , String region){
    if(dataList.containsKey(category)){
      if(dataList[category]!.containsKey(region)){
        return dataList[category]![region]!;
      }
    }
    return null;
  }

  bool addLimit(String category , String region){
    var list = findDataList(category , region);
    if(list != null){
      return list.addViewCount();
    }
    else{
      return false;
    }
  }

}