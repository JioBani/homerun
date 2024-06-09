class SiteReview {
  String title;
  String content;
  String writer;
  int view;
  String imagesRefPath;


  SiteReview({
    required this.title,
    required this.content,
    required this.writer,
    required this.view,
    required this.imagesRefPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'writer': writer,
      'view': view,
      'imagesRefPath': imagesRefPath,
    };
  }

  factory SiteReview.fromMap(Map<String, dynamic> map) {
    return SiteReview(
      title: map['title'],
      content: map['content'],
      writer: map['writer'],
      view: map['view'],
      imagesRefPath: map['imagesRefPath'],
    );
  }
}
