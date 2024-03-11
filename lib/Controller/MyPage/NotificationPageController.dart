
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/NotificationData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Service/SharedPreferencesService.dart';

class NotificationPageController extends GetxController{
  RxList<NotificationData> notificationList = <NotificationData>[].obs;

  Future<void> getNotificationData()async {
    //await _getNotificationDataFromFirestore();
    Map<String , dynamic>? localResult = await _getNotificationDataFromLocal();
    if(localResult == null){
      StaticLogger.logger.i("저장된 정보 없음");
      
      await _getNotificationDataFromFirestore();
      if(notificationList.isNotEmpty){
        await _saveNotificationData();
      }
    }
    else{
      StaticLogger.logger.i("저장된 정보 있음");
      
      DateTime saveTime = localResult['time'];
      List<NotificationData> dataList = localResult['data'];

      if(DateTime.now().difference(saveTime).inSeconds > 120){
        StaticLogger.logger.i("저장된 정보 시간 경과");

        await _getNotificationDataFromFirestore();
        if(notificationList.isNotEmpty){
          await _saveNotificationData();
        }
      }
      else{
        StaticLogger.logger.i("저장된 정보 유효");
        
        notificationList.assignAll(dataList);
      }
    }
  }

  Future<void> _getNotificationDataFromFirestore()async {
    List<NotificationData>? list = await FirebaseFirestoreService.instance.getNotificationData(5);
    if(list != null){
      notificationList.assignAll(list.obs);
    }
  }

  Future<void> _saveNotificationData() async {
    String jsonString = jsonEncode({
      "time" : DateTime.now().toString(),
      "data" : notificationList.value
    });
    SharedPreferencesService.instance.saveData("notification", jsonString);
  }

  Future<Map<String , dynamic>?> _getNotificationDataFromLocal() async{
    String? jsonString = await SharedPreferencesService.instance.loadData("notification");
    if(jsonString != null){
      var jsonObject = json.decode(jsonString);
      List<dynamic> jsonDataList = jsonObject['data'];
      List<NotificationData> dataObjects = jsonDataList
          .map((jsonData) => NotificationData.fromJson(jsonData))
          .toList();
      return {
        'time' : DateTime.parse(jsonObject['time']),
        'data' : dataObjects,
      };
    }
    else {
      return null;
    }
  }

  Duration _calculateTimeDifference(DateTime start, DateTime end) {
    // 두 개의 DateTime 객체 간의 시간 차이를 계산합니다.
    return end.difference(start);

  }


  @override
  void onInit() {
    super.onInit();
    if(notificationList.isEmpty) {
      getNotificationData();
    }
  }
}