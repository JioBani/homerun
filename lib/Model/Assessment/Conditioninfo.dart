import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Vocabulary/EnumList.dart';

import 'Condition.dart';

class ConditionInfo{
  Condition condition;
  List<ProjectOwnerType> projectOwnerTypes;
  List<HousingType> housingTypes;
  List<SupplyType> supplyTypes;
  List<SupplyPriority> supplyPriorities;
  DateTime updateTime;
  String version;

  ConditionInfo({
    required this.condition,
    required this.projectOwnerTypes,
    required this.housingTypes,
    required this.supplyTypes,
    required this.supplyPriorities,
    required this.updateTime,
    required this.version,
  });

  Map<String, dynamic> toMap() {
    return {
      'condition': condition.toMap(),
      'projectOwnerTypes': projectOwnerTypes.map((type) => type.toString()).toList(),
      'housingTypes': housingTypes.map((type) => type.toString()).toList(),
      'supplyTypes': supplyTypes.map((type) => type.toString()).toList(),
      'supplyPriorities': supplyPriorities.map((priority) => priority.toString()).toList(),
      'updateTime': updateTime,
      'version': version,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'condition': condition.toFirestoreDocMap(),
      'projectOwnerTypes': projectOwnerTypes.map((type) => type.toKoreanString()).toList(),
      'housingTypes': housingTypes.map((type) => type.toKoreanString()).toList(),
      'supplyTypes': supplyTypes.map((type) => type.toKoreanString()).toList(),
      'supplyPriorities': supplyPriorities.map((priority) => priority.toKoreanString()).toList(),
      'updateTime': Timestamp.fromDate(updateTime),
      'version': version,
    };
  }

  factory ConditionInfo.fromMap(Map<String, dynamic> map) {
    try{
      return ConditionInfo(
        condition: Condition.fromMap(map['condition']),
        projectOwnerTypes: List<String>.from(map['projectOwnerTypes']).map(ProjectOwnerExtension.fromKoreanString).toList(),
        housingTypes: List<String>.from(map['housingTypes']).map(HousingTypeExtension.fromKoreanString).toList(),
        supplyTypes: List<String>.from(map['supplyTypes']).map(SupplyTypeExtension.fromKoreanString).toList(),
        supplyPriorities: List<String>.from(map['supplyPriorities']).map(SupplyPriorityExtension.fromKoreanString).toList(),
        updateTime: (map['updateTime'] as Timestamp).toDate(),
        version: map['version'],
      );
    }catch(e , s){
      StaticLogger.logger.e('[ConditionInfo.fromMap()] $e\n$s');
      rethrow;
    }
  }
}