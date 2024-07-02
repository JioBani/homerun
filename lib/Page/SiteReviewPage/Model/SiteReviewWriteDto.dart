class SiteReviewWriteDto{
  final String noticeId;
  final String title;
  final String content;
  final String thumbnail;

  SiteReviewWriteDto({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.thumbnail,
  });

  Map<String, dynamic> toMap(){
    return {
      'noticeId' : noticeId,
      'title' : title,
      'content' : content,
      'thumbnail' : thumbnail,
    };
  }

  factory SiteReviewWriteDto.fromWrite({
    required String noticeId,
    required String title,
    required String content,
    required String thumbnail,
  }){

    return SiteReviewWriteDto(
      noticeId : noticeId,
      title : title,
      content : content,
      thumbnail : thumbnail,
    );
  }
}