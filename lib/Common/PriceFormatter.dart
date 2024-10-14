import 'package:intl/intl.dart';

class PriceFormatter {
  static NumberFormat? _formatter;

  /// 금액을 0000억 0,000 의 형태의 문자열로 반환. 자리수는 유지되지 않음
  /// 
  /// [returns] 정상적으로 변환 불가능한 경우 null을 반환
  static String? formatToEokThousand(double amount) {
    // 금액이 0보다 작거나, 1조를 넘는 경우 null 반환
    if (amount < 0 || amount >= 100000000000) {
      return null;
    }

    // 금액을 억 단위와 나머지 천 단위로 나눔
    int eok = (amount ~/ 10000).toInt(); // 억 단위
    int remainder = (amount % 10000).toInt(); // 천 단위 이하

    // 천 단위에 쉼표를 추가하는
    _formatter ?? (_formatter = NumberFormat('#,###'));

    // 억 단위가 있는 경우 처리
    if (eok > 0) {
      if (remainder > 0) {
        return '$eok억 ${_formatter!.format(remainder)}';
      } else {
        return '$eok억';
      }
    } else {
      return _formatter!.format(remainder); // 억 단위가 없는 경우는 천 단위만 반환
    }
  }
  
  static String? tryFormatToEokThousand(double? amount){
    return (amount == null || amount.isNaN) ? null : formatToEokThousand(amount);
  }
}