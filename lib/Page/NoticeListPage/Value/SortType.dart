enum SortType {
  applicationDate,
  announcementDate,
  popularity,
}

extension SortTypeExtension on SortType{
  String toEnumString() {
    switch (this) {
      case SortType.applicationDate:
        return '입주자공고일';
      case SortType.announcementDate:
        return '접수마감일순';
      case SortType.popularity:
        return '인기순';
    }
  }
}