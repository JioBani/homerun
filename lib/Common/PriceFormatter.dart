class PriceFormatter {
  static String? formatToEokThousand(double amount) {
    // 금액이 0보다 작거나, 1조를 넘는 경우 null 반환
    if (amount < 0 || amount >= 100000000000) {
      return null;
    }

    // 금액을 억 단위와 나머지 천 단위로 나눔
    int eok = (amount ~/ 10000).toInt(); // 억 단위
    int remainder = (amount % 10000).toInt(); // 천 단위 이하

    // 억 단위가 있는 경우 처리
    if (eok > 0) {
      if (remainder > 0) {
        return '$eok억 $remainder';
      } else {
        return '$eok억';
      }
    } else {
      return remainder.toString(); // 억 단위가 없는 경우는 천 단위만 반환
    }
  }
}