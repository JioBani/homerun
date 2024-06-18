enum Gender {
  none,
  male,
  female,
}

extension GenderExtension on Gender {
  String toShortString() {
    return this.toString().split('.').last;
  }

  static Gender fromString(String genderString) {
    switch (genderString) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.none;
    }
  }
}

class UserDto {
  String uid;
  String provider;
  String displayName;
  String birth;
  Gender gender;

  UserDto({
    required this.uid,
    required this.provider,
    required this.displayName,
    required this.birth,
    required this.gender,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      uid: map['uid'] as String,
      provider: map['provider'] as String,
      displayName: map['displayName'] as String,
      birth: map['birth'] as String,
      gender: GenderExtension.fromString(map['gender'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'provider': provider,
      'displayName': displayName,
      'birth': birth,
      'gender': gender.toShortString(),
    };
  }

  UserDto.test()
      : uid = 'testUid',
        provider = 'testProvider',
        displayName = 'testNickName',
        birth = '2000-01-01',
        gender = Gender.none;

}
