enum SortType {
  applicationDate,
  announcementDate,
  popularity,
}

extension SortTypeExtension on SortType{
  String toEnumString() {
    switch (this) {
      case SortType.applicationDate:
        return '공고일순';
      case SortType.announcementDate:
        return '접수임박순';
      case SortType.popularity:
        return '인기순';
    }
  }
}