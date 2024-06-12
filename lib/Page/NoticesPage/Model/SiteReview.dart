class SiteReview {
  String noticeId;
  String title;
  String content;
  String writer;
  int view;
  String imagesRefPath;


  SiteReview({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.writer,
    required this.view,
    required this.imagesRefPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'noticeId' : noticeId,
      'title': title,
      'content': content,
      'writer': writer,
      'view': view,
      'imagesRefPath': imagesRefPath,
    };
  }

  factory SiteReview.fromMap(Map<String, dynamic> map) {
    return SiteReview(
      noticeId: map['noticeId'],
      title: map['title'],
      content: map['content'],
      writer: map['writer'],
      view: map['view'],
      imagesRefPath: map['imagesRefPath'],
    );
  }

  factory SiteReview.test() {
    return SiteReview(
      noticeId: '1',
      title: "테스트1",
      content: '테스트1',
      writer: 'writer',
      view: 0,
      imagesRefPath: 'site_review/test/1',
    );
  }
}
