class SiteReview {
  String title;
  String content;
  String writer;
  int view;
  List<String> images;

  SiteReview({
    required this.title,
    required this.content,
    required this.writer,
    required this.view,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'writer': writer,
      'view': view,
      'images': images,
    };
  }

  factory SiteReview.fromMap(Map<String, dynamic> map) {
    return SiteReview(
      title: map['title'],
      content: map['content'],
      writer: map['writer'],
      view: map['view'],
      images: List<String>.from(map['images']),
    );
  }
}
