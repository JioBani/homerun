enum SortType {
  applicationDateUpcoming,
  announcementDate,
  popularity,
}

extension SortTypeExtension on SortType{
  String toEnumString() {
    switch (this) {
      case SortType.applicationDateUpcoming:
        return '접수임박순';
      case SortType.announcementDate:
        return '공고일순';
      case SortType.popularity:
        return '인기순';
    }
  }
}