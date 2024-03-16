//#. 사업주체분류
/// 사업주체분류: '공공분양'과 '민간분양'을 포함합니다.
enum ProjectOwnerType{
  /// 공공분양
  publicDistribution,

  /// 민간분양
  privateDistribution
}

extension ProjectOwnerExtension on ProjectOwnerType {
  /// 사업주체분류를 한국어 문자열로 반환합니다.
  String toKoreanString(){
    switch (this) {
      case ProjectOwnerType.publicDistribution:
        return '공공분양';
      case ProjectOwnerType.privateDistribution:
        return '민간분양';
    }
  }

  static ProjectOwnerType fromKoreanString(String string) {
    switch (string) {
      case '공공분양':
        return ProjectOwnerType.publicDistribution;
      case '민간분양':
        return ProjectOwnerType.privateDistribution;
      default:
        throw Exception('Unknown ProjectOwnerType string: $string');
    }
  }
}

//#. 주택유형
/// 주택유형: '일반형', '이익공유', '토지임대부', '선택형', '신혼희망타운', '10년분양공공임대주택'을 포함합니다.
enum HousingType{
  /// 일반형
  general,
  /// 이익공유
  profitSharing,
  /// 토지임대부
  landLeasehold,
  /// 선택형
  optional,
  /// 신혼희망타운
  newlywedHopeTown,
  /// 10년분양공공임대주택
  tenTearRental,
}

extension HousingTypeExtension on HousingType {
  /// 주택유형을 한국어 문자열로 반환합니다.
  String toKoreanString(){
    switch (this) {
      case HousingType.general:
        return '일반형';
      case HousingType.profitSharing:
        return '이익공유';
      case HousingType.landLeasehold:
        return '토지임대부';
      case HousingType.optional:
        return '선택형';
      case HousingType.newlywedHopeTown:
        return '신혼희망타운';
      case HousingType.tenTearRental:
        return '10년분양공공임대주택';
    }
  }

  static HousingType fromKoreanString(String string) {
    switch (string) {
      case '일반형':
        return HousingType.general;
      case '이익공유':
        return HousingType.profitSharing;
      case '토지임대부':
        return HousingType.landLeasehold;
      case '선택형':
        return HousingType.optional;
      case '신혼희망타운':
        return HousingType.newlywedHopeTown;
      case '10년분양공공임대주택':
        return HousingType.tenTearRental;
      default:
        throw Exception('Unknown HousingType string: $string');
    }
  }

}

//#. 공급유형
/// 공급유형: '기관추천', '청년', '다자녀', '노부모부양', '생애최초', '신혼부부', '일반'을 포함합니다.
enum SupplyType{
  /// 기관추천
  institutional,
  /// 청년
  youth,
  /// 다자녀
  multipleChildren,
  /// 노부모부양
  elderlyParents,
  /// 생애최초
  firstTime,
  /// 신혼부부
  newlyweds,
  /// 일반
  general
}

extension SupplyTypeExtension on SupplyType {
  /// 공급유형을 한국어 문자열로 반환합니다.
  String toKoreanString(){
    switch (this) {
      case SupplyType.institutional:
        return '기관추천';
      case SupplyType.youth:
        return '청년';
      case SupplyType.multipleChildren:
        return '다자녀';
      case SupplyType.elderlyParents:
        return '노부모부양';
      case SupplyType.firstTime:
        return '생애최초';
      case SupplyType.newlyweds:
        return '신혼부부';
      case SupplyType.general:
        return '일반';
    }
  }

  static SupplyType fromKoreanString(String string) {
    switch (string) {
      case '기관추천':
        return SupplyType.institutional;
      case '청년':
        return SupplyType.youth;
      case '다자녀':
        return SupplyType.multipleChildren;
      case '노부모부양':
        return SupplyType.elderlyParents;
      case '생애최초':
        return SupplyType.firstTime;
      case '신혼부부':
        return SupplyType.newlyweds;
      case '일반':
        return SupplyType.general;
      default:
        throw Exception('Unknown SupplyType string: $string');
    }
  }
}

//#. 공급우선순위
/// 공급우선순위: '없음', '우선', '잔여'를 포함합니다.
enum SupplyPriority{
  /// 없음
  none,
  /// 우선공급
  priority,
  /// 잔여공급
  remaining
}

extension SupplyPriorityExtension on SupplyPriority {
  /// 공급우선순위를 한국어 문자열로 반환합니다.
  String toKoreanString(){
    switch (this) {
      case SupplyPriority.none:
        return '없음';
      case SupplyPriority.priority:
        return '우선';
      case SupplyPriority.remaining:
        return '잔여';
    }
  }

  static SupplyPriority fromKoreanString(String string) {
    switch (string) {
      case '없음':
        return SupplyPriority.none;
      case '우선':
        return SupplyPriority.priority;
      case '잔여':
        return SupplyPriority.remaining;
      default:
        throw Exception('Unknown SupplyPriority string: $string');
    }
  }
}
