import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Value/AgeRange.dart';
import 'package:homerun/Value/Region.dart';

import 'UserFields.dart';

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
      uid: map[UserFields.uid] as String,
      socialProvider: SocialProviderExtension.fromString(map[UserFields.socialProvider]),
      displayName: map[UserFields.displayName] as String,
      gender: GenderExtension.fromString(map[UserFields.gender] as String),
      ageRange: AgeRange.fromString(map[UserFields.ageRange] as String),
      interestedRegions: List<String>.from(map[UserFields.interestedRegions] as List).map((region) => Region.fromString(region)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserFields.socialProvider: socialProvider.name,
      UserFields.uid: uid,
      UserFields.displayName: displayName,
      UserFields.gender: gender?.name,
      UserFields.ageRange: ageRange?.name,
      UserFields.interestedRegions: interestedRegions,
    };
  }
}