enum NoticeCommentType {
  free,
  eligibility,
}

extension NoticeCommentTypeExtension on NoticeCommentType{
  String get name {
    switch (this) {
      case NoticeCommentType.free:
        return 'free';
      case NoticeCommentType.eligibility:
        return 'eligibility';
      default:
        throw UnimplementedError('Unexpected NoticeCommentType: $this');
    }
  }
}

enum OrderType {
  none,
  date,
  likes
}

extension OrderTypeExtension on OrderType{
  String get name {
    switch (this) {
      case OrderType.none:
        return 'none';
      case OrderType.date:
        return 'date';
      case OrderType.likes:
        return 'likes';
      default:
        throw UnimplementedError('Unexpected CommentType: $this');
    }
  }

  String get koreanName {
    switch (this) {
      case OrderType.none:
        return '없음';
      case OrderType.date:
        return '최신순';
      case OrderType.likes:
        return '추천순';
      default:
        throw UnimplementedError('Unexpected CommentType: $this');
    }
  }
}