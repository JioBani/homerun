enum Region {
  seoul('서울'),
  gyeonggi_incheon('경기·인천'),
  busan('부산'),
  sejong_daejeon('세종·대전'),
  gangwon('강원'),
  chungbuk_chungnam('충북·충남'),
  gyeongbuk_gyeongnam('경북·경남'),
  jeonbuk_jeonnam('전북·전남'),
  jeju('제주');

  final String label;

  const Region(this.label);

  static Region? fromString(String label) {
    for (var value in Region.values) {
      if (value.label == label) {
        return value;
      }
    }
    return null;
  }
}
