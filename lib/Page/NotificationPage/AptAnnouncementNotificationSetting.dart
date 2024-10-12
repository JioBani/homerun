import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Value/HouseType.dart';
import 'package:homerun/Value/Region.dart';
import 'package:homerun/Value/RegionGyeonggi.dart';
import 'package:homerun/Value/RegionSeoul.dart';

import 'AptAnnouncementNotificationSettingFields.dart';

class AptAnnouncementNotificationSetting {
  final List<HouseType> houseType;
  final List<Region> region;
  final bool seoulAll;
  final List<RegionSeoul> seoul;
  final bool gyeonggiAll;
  final List<RegionGyeonggi> gyeonggi;

  AptAnnouncementNotificationSetting({
    required this.houseType,
    required this.region,
    required this.seoulAll,
    required this.seoul,
    required this.gyeonggiAll,
    required this.gyeonggi,
  });

  Map<String, dynamic> toMap() {
    return {
      AptAnnouncementNotificationSettingFields.houseType: houseType,
      AptAnnouncementNotificationSettingFields.region: region,
      AptAnnouncementNotificationSettingFields.seoulAll: seoulAll,
      AptAnnouncementNotificationSettingFields.seoul: seoul,
      AptAnnouncementNotificationSettingFields.gyeonggiAll: gyeonggiAll,
      AptAnnouncementNotificationSettingFields.gyeonggi: gyeonggi,
    };
  }

  factory AptAnnouncementNotificationSetting.fromMap(Map<String, dynamic> map) {
    return AptAnnouncementNotificationSetting(
      houseType:  List<String>.from(map[AptAnnouncementNotificationSettingFields.houseType] ?? []).map((e)=>HouseType.fromKoreanString(e)!).toList(),
      region: List<String>.from(map[AptAnnouncementNotificationSettingFields.region] ?? []).map((e)=>Region.fromKoreanString(e)!).toList(),
      seoulAll: map[AptAnnouncementNotificationSettingFields.seoulAll] ?? false,
      seoul: List<String>.from(map[AptAnnouncementNotificationSettingFields.seoul] ?? []).map((e)=>RegionSeoul.fromKoreanString(e)!).toList(),
      gyeonggiAll: map[AptAnnouncementNotificationSettingFields.gyeonggiAll] ?? false,
      gyeonggi: List<String>.from(map[AptAnnouncementNotificationSettingFields.gyeonggi] ?? []).map((e)=>RegionGyeonggi.fromKoreanString(e)!).toList(),
    );
  }

  static AptAnnouncementNotificationSetting? tryFromMap(Map<String, dynamic> map){
    try{
      return AptAnnouncementNotificationSetting.fromMap(map);
    }catch(e,s){
      StaticLogger.logger.e("[AptAnnouncementNotificationSetting.tryFromMap()] $e\n$s");
      return null;
    }
  }
}
