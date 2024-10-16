import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/RegionGyeonggi.dart';
import 'package:homerun/Feature/Notice/Value/RegionSeoul.dart';

class AnnouncementNotificationService{
  static FirebaseMessaging? _messagingManager;
  static FirebaseMessaging get messagingManage{
    _messagingManager ??= FirebaseMessaging.instance;
    return _messagingManager!;
  }

  static Future<bool> subscribe(String topic) async{
    bool isSuccess = true;
    if(topic == "서울전지역"){
      await Future.wait(RegionSeoul.values.map((region) async {
        try{
          return await messagingManage.subscribeToTopic(region.toString());
        }catch(e,s){
          StaticLogger.logger.e("[AnnouncementNotificationService.subscribe()] topic : $topic , region : $region\n$e\n$s");
          isSuccess = false;
        }
      }));
    }
    else if(topic == "경기전지역"){
      await Future.wait(RegionGyeonggi.values.map((region) async {
        try{
          return await messagingManage.subscribeToTopic(region.toString());
        }catch(e,s){
          StaticLogger.logger.e("[AnnouncementNotificationService.subscribe()] topic : $topic , region : $region\n$e\n$s");
          isSuccess = false;
        }
      }));
    }
    else{
      try{
        await messagingManage.subscribeToTopic(topic);
      }catch(e,s){
        StaticLogger.logger.e("[AnnouncementNotificationService.subscribe()] $topic : $e\n$s");
        isSuccess = false;
      }
    }
    StaticLogger.logger.i("[AnnouncementNotificationService.subscribe()] $topic 구독 완료");
    return isSuccess;
  }

  static Future<bool> unsubscribe(String topic)async {
    bool isSuccess = true;
    if(topic == "서울전지역"){
      await Future.wait(RegionSeoul.values.map((region) async {
        try{
          return await messagingManage.unsubscribeFromTopic(region.toString());
        }catch(e,s){
          StaticLogger.logger.e("[AnnouncementNotificationService.unsubscribe()] topic : $topic , region : $region\n$e\n$s");
          isSuccess = false;
        }
      }));
    }
    else if(topic == "경기전지역"){
      await Future.wait(RegionGyeonggi.values.map((region) async {
        try{
          return await messagingManage.unsubscribeFromTopic(region.toString());
        }catch(e,s){
          StaticLogger.logger.e("[AnnouncementNotificationService.unsubscribe()] topic : $topic , region : $region\n$e\n$s");
          isSuccess = false;
        }
      }));
    }
    else{
      try{
        await messagingManage.unsubscribeFromTopic(topic);
      }catch(e,s){
        StaticLogger.logger.e("[AnnouncementNotificationService.unsubscribe()] $topic : $e\n$s");
        isSuccess = false;
      }
    }

    StaticLogger.logger.i("[AnnouncementNotificationService.unsubscribe()] $topic 구독 취소 완료");
    return isSuccess;
  }

  static void resetSubscribe(){
    for (var houseType in HouseType.values) {
      messagingManage.unsubscribeFromTopic(houseType.toString());
    }

    for (var region in RegionSeoul.values) {
      messagingManage.unsubscribeFromTopic(region.toString());
    }

    for (var region in RegionGyeonggi.values) {
      messagingManage.unsubscribeFromTopic(region.toString());
    }
  }
}