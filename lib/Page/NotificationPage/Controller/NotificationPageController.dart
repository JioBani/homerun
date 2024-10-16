import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/SelectBoxWidget.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NotificationPage/NotificationReferences.dart';
import 'package:homerun/Service/AnnouncementNotificationService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/LocalNotificationService.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:homerun/Feature/Notice/Value/RegionGyeonggi.dart';
import 'package:homerun/Feature/Notice/Value/RegionSeoul.dart';

import '../AptAnnouncementNotificationSetting.dart';
import '../AptAnnouncementNotificationSettingFields.dart';

class NotificationPageController extends GetxController{
  final SelectBoxController<Region> regionController = SelectBoxController(isCanSelectMulti: true);
  final SelectBoxController<RegionSeoul> regionSeoulController = SelectBoxController(isCanSelectMulti: true);
  final SelectBoxController<RegionGyeonggi> regionGyeonggiController = SelectBoxController(isCanSelectMulti: true);
  final SelectBoxController<HouseType> houseTypeController = SelectBoxController(isCanSelectMulti: true);

  bool seoulSelect = false;
  bool gyeonggiSelect = false;

  Random random = Random();

  AptAnnouncementNotificationSetting? setting;

  Rx<LoadingState> loadingState = Rx(LoadingState.before);

  void reset(){
    regionController.reset();
    regionSeoulController.reset();
    regionGyeonggiController.reset();
    houseTypeController.reset();
    seoulSelect = false;
    gyeonggiSelect = false;
  }

  bool checkChange(){
    if(setting != null){
      const DeepCollectionEquality equality = DeepCollectionEquality.unordered();

      return !equality.equals(regionController.values,setting!.region) ||
             !equality.equals(regionSeoulController.values,setting!.seoul) ||
             !equality.equals(regionGyeonggiController.values,setting!.gyeonggi) ||
             !equality.equals(houseTypeController.values,setting!.houseType) ||
              seoulSelect != setting!.seoulAll ||
              gyeonggiSelect != setting!.gyeonggiAll;

    }

    return false;
  }

  //#. 알림설정 데이터 가져오기
  Future<void> fetchSetting() async {
    loadingState.value = LoadingState.loading;
    var result = await Result.handleFuture(action: () async {
      DocumentSnapshot documentSnapshot = await NotificationReferences.getAnnouncementNotificationReferences(
          Get.find<AuthService>().getUser().uid
      ).get();

      if(documentSnapshot.exists){
        var setting = AptAnnouncementNotificationSetting.fromMap(documentSnapshot.data() as Map<String, dynamic>);

        this.setting = setting;

        for (var value in setting.houseType) {
          houseTypeController.setValue(value, true);
        }

        for (var value in setting.seoul) {
          regionSeoulController.setValue(value, true);
        }

        for (var value in setting.gyeonggi) {
          regionGyeonggiController.setValue(value, true);
        }

        seoulSelect = setting.seoulAll;
        gyeonggiSelect = setting.gyeonggiAll;
      }
    });

    if(result.isSuccess){
      loadingState.value = LoadingState.success;
    }
    else{
      loadingState.value = LoadingState.fail;
    }
  }

  //#. 알림설정 데이터베이스에 저장하기
  Future<Result> uploadSetting() async{
    return Result.handleFuture(action: () async{
      DocumentReference doc = NotificationReferences.getAnnouncementNotificationReferences(
          Get.find<AuthService>().getUser().uid
      );

      await doc.set({
        AptAnnouncementNotificationSettingFields.houseType : houseTypeController.values.map((e) => e.toString()).toList(),
        AptAnnouncementNotificationSettingFields.region : regionController.values.map((e)=>e.toString()).toList(),
        AptAnnouncementNotificationSettingFields.seoulAll : seoulSelect,
        AptAnnouncementNotificationSettingFields.seoul : regionSeoulController.values.map((e) => e.toString()).toList(),
        AptAnnouncementNotificationSettingFields.gyeonggiAll : gyeonggiSelect,
        AptAnnouncementNotificationSettingFields.gyeonggi : regionGyeonggiController.values.map((e) => e.toString()).toList(),
      });

      setting = AptAnnouncementNotificationSetting(
          houseType: houseTypeController.values,
          region: regionController.values,
          seoulAll: seoulSelect,
          seoul: regionSeoulController.values,
          gyeonggiAll: gyeonggiSelect,
          gyeonggi: regionGyeonggiController.values
      );
    });
  }

  //#. 알림설정 적용
  Future<void> save(BuildContext context) async{

    Result uploadResult = await uploadSetting();

    if(!uploadResult.isSuccess){
      if(context.mounted){
        String msg = "변경사항을 저장하지 못했습니다.";
        if(uploadResult.exception is FirebaseException){
          FirebaseException e = uploadResult.exception as FirebaseException;
          if(e.code == "permission-denied"){
            msg = "로그인 정보가 없거나, 권한이 없습니다.";
          }
        }
        else if(uploadResult.exception is ApplicationUnauthorizedException){
          msg = "로그인이 필요합니다.";
        }

        CustomDialog.defaultDialog(
          context: context, title: msg,
          buttonText: "확인"
        );
      }
      return;
    }
    else{
      if(context.mounted){
        CustomDialog.defaultDialog(
          context: context,
          title: "알림 설정을 저장하였습니다.\n설정이 적용되기 까지 최대 5분의 시간이 소요 될 수 있습니다.",
          buttonText: "확인",
        );
      }
    }

    int hasError = 0;

    //#. 지역
    await Future.wait(Region.withoutSeoulGyeonggi().map((region) async {
      if(regionController.values.contains(region)){
        if(!await AnnouncementNotificationService.subscribe(region.toEngString())){
          hasError++;
        }

      }
      else{
        if(!await AnnouncementNotificationService.unsubscribe(region.toEngString())){
          hasError++;
        }
      }
    }));

    StaticLogger.logger.i("지역 적용 완료");


    if(seoulSelect){
      //#. 서울 전지역 구독
      await AnnouncementNotificationService.subscribe(Region.seoul.toEngString());

      //#. 서울 지역구 구독 해제
      await Future.wait(RegionSeoul.values.map((region) async {
        if(!await AnnouncementNotificationService.unsubscribe(region.toEngString())){
          hasError++;
        }
      }));
    }
    else{
      //#. 서울 전지역 구독 해제
      await AnnouncementNotificationService.unsubscribe(Region.seoul.toEngString());

      //#. 서울 행정구역
      await Future.wait(RegionSeoul.values.map((region) async {
        if(regionSeoulController.values.contains(region)){
          if(!await AnnouncementNotificationService.subscribe(region.toEngString())){
            hasError++;
          }

        }
        else{
          if(!await AnnouncementNotificationService.unsubscribe(region.toEngString())){
            hasError++;
          }
        }
      }));
    }
    
    StaticLogger.logger.i("서울 행정 구역 적용 완료");

    if(gyeonggiSelect){
      //#. 경기 전지역 구독
      await AnnouncementNotificationService.subscribe(Region.gyeonggi.toEngString());

      //#. 경기 헹정구역 구독 해제
      await Future.wait(RegionGyeonggi.values.map((region) async {
        if(!await AnnouncementNotificationService.unsubscribe(region.toEngString())){
          hasError++;
        }
      }));
    }
    else{
      //#. 경기 전지역 해제
      await AnnouncementNotificationService.unsubscribe(Region.gyeonggi.toEngString());

      //#. 경기 행정구역
      await Future.wait(RegionGyeonggi.values.map((region) async {
        if(regionGyeonggiController.values.contains(region)){
          if(!await AnnouncementNotificationService.subscribe(region.toEngString())){
            hasError++;
          }

        }
        else{
          if(!await AnnouncementNotificationService.unsubscribe(region.toEngString())){
            hasError++;
          }
        }
      }));
    }
    StaticLogger.logger.i("경기 행정 구역 적용 완료");

    //#. 주택 타입
    await Future.wait(HouseType.values.map((houseType) async {
      if(houseTypeController.values.contains(houseType)){
        if(!await AnnouncementNotificationService.subscribe(houseType.toEngString())){
          hasError++;
        }
      }
      else{
        if(!await AnnouncementNotificationService.unsubscribe(houseType.toEngString())){
          hasError++;
        }
      }
    }));
    StaticLogger.logger.i("주택 타입 적용 완료");

    StaticLogger.logger.i("알림 설정 완료");

    LocalNotificationService.displayLocal(
      title: hasError == 0 ? "알림 설정 적용 완료" : "알림 설정 적용 실패",
      body:  hasError == 0 ? "알림 설정 적용이 완료되었습니다." : "알림 설정 적용중 오류가 발생하였습니다. 알림 설정이 제대로 적용되지 않을 수 있습니다."
    );
  }
}