enum SupplyMethod{
  General('일반', 'General'),

  UnrankedRemain('무순위/잔여세대', 'UnrankedRemain'),

  OptionalSupply('임의공급', 'OptionalSupply');

  // 한글 및 영어 문자열 값
  final String koreanName;
  final String englishName;
  const SupplyMethod(this.koreanName, this.englishName);

  String toKoreanString() => koreanName;

  // 대문자 카멜케이스로 영어 문자열 반환 함수
  String toEngString() => englishName;

  static SupplyMethod? fromKoreanString(String label) {
    for (var value in SupplyMethod.values) {
      if (value.koreanName == label) {
        return value;
      }
    }
    return null;
  }
}

extension SupplyMethodExtension on SupplyMethod {
  static SupplyMethod fromString(String value) {
    switch (value) {
      case 'General':
        return SupplyMethod.General;
      case 'UnrankedRemain':
        return SupplyMethod.UnrankedRemain;
      case 'OptionalSupply':
        return SupplyMethod.OptionalSupply;
      default:
        throw ArgumentError('Invalid supply method: $value');
    }
  }

  toEnumString(){
    switch (this) {
      case SupplyMethod.General:
        return "General";
      case SupplyMethod.UnrankedRemain:
        return "UnrankedRemain";
      case SupplyMethod.OptionalSupply:
        return "OptionalSupply";
    }
  }

  toKoreanString(){

  }
}
