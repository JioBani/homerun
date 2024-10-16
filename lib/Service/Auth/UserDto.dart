import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';

import 'UserFields.dart';

class UserDto {
  final String uid;
  final SocialProvider socialProvider;
  final String displayName;
  final Gender gender;
  final List<Region?> interestedRegions;
  final Timestamp birth;

  UserDto({
    required this.socialProvider,
    required this.uid,
    required this.displayName,
    required this.gender,
    required this.interestedRegions,
    required this.birth,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      uid: map[UserFields.uid] as String,
      socialProvider: SocialProviderExtension.fromString(map[UserFields.socialProvider]),
      displayName: map[UserFields.displayName] as String,
      gender: GenderExtension.fromString(map[UserFields.gender] as String),
      interestedRegions: List<String>.from(map[UserFields.interestedRegions] as List).map((region) => Region.fromKoreanString(region)).toList(),
      birth: map[UserFields.birth] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserFields.socialProvider: socialProvider.name,
      UserFields.uid: uid,
      UserFields.displayName: displayName,
      UserFields.gender: gender.name,
      UserFields.interestedRegions: interestedRegions,
      UserFields.birth: birth,
    };
  }
}