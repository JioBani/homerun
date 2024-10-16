enum SupplyMethod{
  General,
  UnrankedRemain,
  OptionalSupply
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
}
