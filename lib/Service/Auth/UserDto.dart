import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';

class UserDto {
  final String uid;
  final SocialProvider socialProvider;
  final String displayName;
  final String birth;
  final Gender gender;

  UserDto({
    required this.socialProvider,
    required this.uid,
    required this.displayName,
    required this.birth,
    required this.gender,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      uid: map['uid'] as String,
      socialProvider: SocialProviderExtension.fromString(map['socialProvider']),
      displayName: map['displayName'] as String,
      birth: map['birth'] as String,
      gender: GenderExtension.fromString(map['gender'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'socialProvider': socialProvider.name,
      'uid': uid,
      'displayName': displayName,
      'birth': birth,
      'gender': gender.name,
    };
  }

  UserDto.test()
      : uid = 'testUid',
        socialProvider = SocialProvider.kakao,
        displayName = 'testNickName',
        birth = '2000-01-01',
        gender = Gender.none;

}
