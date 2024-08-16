import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Value/AgeRange.dart';
import 'package:homerun/Value/Region.dart';

//TODO UserInfo Values
class UserDto {
  final String uid;
  final SocialProvider socialProvider;
  final String? displayName;
  final Gender? gender;
  final List<Region?> interestedRegions;
  final AgeRange? ageRange;

  UserDto({
    required this.socialProvider,
    required this.uid,
    required this.displayName,
    required this.gender,
    required this.ageRange,
    required this.interestedRegions,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      uid: map['uid'] as String,
      socialProvider: SocialProviderExtension.fromString(map['socialProvider']),
      displayName: map['displayName'] as String,
      gender: GenderExtension.fromString(map['gender'] as String),
      ageRange: AgeRange.fromString(map['ageRange'] as String),
      interestedRegions: List<String>.from(map['interestedRegions'] as List).map((region) => Region.fromString(region)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'socialProvider': socialProvider.name,
      'uid': uid,
      'displayName': displayName,
      'gender': gender?.name,
      'ageRange': ageRange?.name,
      'interestedRegions': interestedRegions,
    };
  }
}
