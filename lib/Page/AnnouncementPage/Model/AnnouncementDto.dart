import 'package:cloud_firestore/cloud_firestore.dart';

import '../Value/AnnouncementDtoFields.dart';

class AnnouncementDto {
  final String title;
  final String content;
  final Timestamp date;
  final List<String> imagePaths;
  final bool? isImportant;

  AnnouncementDto({
    required this.title,
    required this.content,
    required this.date,
    required this.imagePaths,
    this.isImportant,
  });

  Map<String, dynamic> toMap() {
    return {
      AnnouncementDtoFields.title: title,
      AnnouncementDtoFields.content: content,
      AnnouncementDtoFields.date: date,
      AnnouncementDtoFields.imagePaths: imagePaths,
      AnnouncementDtoFields.isImportant: isImportant,
    };
  }

  factory AnnouncementDto.fromMap(Map<String, dynamic> map) {
    return AnnouncementDto(
      title: map[AnnouncementDtoFields.title],
      content: map[AnnouncementDtoFields.content],
      date: map[AnnouncementDtoFields.date] ?? Timestamp.now(),
      imagePaths: List<String>.from(map[AnnouncementDtoFields.imagePaths] ?? []),
      isImportant: map[AnnouncementDtoFields.isImportant],
    );
  }

  factory AnnouncementDto.fromDocumentSnapshot(DocumentSnapshot doc) {
    return AnnouncementDto.fromMap(doc.data() as Map<String, dynamic>);
  }

  static AnnouncementDto? tryFromMap(Map<String, dynamic> map) {
    try {
      return AnnouncementDto(
        title: map[AnnouncementDtoFields.title],
        content: map[AnnouncementDtoFields.content] ,
        date: map[AnnouncementDtoFields.date] ,
        imagePaths: List<String>.from(map[AnnouncementDtoFields.imagePaths] ?? []),
        isImportant: map[AnnouncementDtoFields.isImportant],
      );
    } catch (e) {
      return null;
    }
  }

}
