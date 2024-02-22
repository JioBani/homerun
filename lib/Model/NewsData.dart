class NewsData{
  final String id;
  final String profileImagePath;
  final String profileTitle;
  final String profileSubTitle;
  final String pdfPath;

  NewsData({
    required this.id,
    required this.profileImagePath,
    required this.profileTitle,
    required this.profileSubTitle,
    required this.pdfPath,
  });

  factory NewsData.fromMap(String id , Map<String, dynamic> map) {
    return NewsData(
      id: id,
      profileImagePath: map['profileImagePath'],
      profileTitle: map['profileTitle'],
      profileSubTitle: map['profileSubTitle'],
      pdfPath: map['pdfPath'],
    );
  }

  String getProfileImagePath(){
    return "news/$id/profile.png";
  }

}