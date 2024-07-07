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
}