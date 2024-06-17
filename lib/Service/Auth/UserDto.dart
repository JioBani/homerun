enum Gender {
  none,
  male,
  female,
}

class UserDto {
  String uid;
  String provider;
  String nickName;
  String birth;
  Gender gender;

  UserDto({
    required this.uid,
    required this.provider,
    required this.nickName,
    required this.birth,
    required this.gender,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      uid: map['uid'] as String,
      provider: map['provider'] as String,
      nickName: map['nickName'] as String,
      birth: map['birth'] as String,
      gender: Gender.values[map['gender'] as int],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'provider': provider,
      'nickName': nickName,
      'birth': birth,
      'gender': gender.index,
    };
  }

  UserDto.test()
      : uid = 'testUid',
        provider = 'testProvider',
        nickName = 'testNickName',
        birth = '2000-01-01',
        gender = Gender.none;

}
