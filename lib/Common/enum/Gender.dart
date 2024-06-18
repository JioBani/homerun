enum Gender {
  male,
  female,
  none,
}

extension GenderExtension on Gender {
  static Gender fromString(String gender) {
    switch (gender) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'none':
        return Gender.none;
      default:
        throw Exception('Unknown gender: $gender');
    }
  }
}