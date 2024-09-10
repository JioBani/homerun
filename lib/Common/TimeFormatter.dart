import 'package:intl/intl.dart';

//TODO 변환 불가능할때 trycatch
class TimeFormatter {
  static final DateFormat _datFormat = DateFormat('yyyy.MM.dd');
  static final DateFormat _koreanFormat = DateFormat('yyyy년 MM월 dd일');

  TimeFormatter._();

  static String formatTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}초전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간전';
    } else {
      return _datFormat.format(dateTime);
    }
  }

  /// 남은 일을 반환하는 함수
  ///
  /// 일 단위로 계산(시간은 무시하고 정각으로만 계산함)
  static int calculateDaysDifference(DateTime dateTime) {
    final now = DateTime.now();
    DateTime noonTargetDate = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    DateTime nowTriggerDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final difference = noonTargetDate.difference(nowTriggerDate);

    return difference.inDays;
  }

  static datStringToTime(String string){
    return _datFormat.parseStrict(string);
  }

  static dateToDatString(DateTime dateTime){
    return _datFormat.format(dateTime);
  }

  static String? tryDateToDatString(DateTime? dateTime){
    return dateTime == null ? null  : _datFormat.format(dateTime);
  }

  ///00년 00월 00일
  static dateToKoreanString(DateTime dateTime){
    return _koreanFormat.format(dateTime);
  }

  ///00년 00월 00일
  static tryDateToKoreanString(DateTime? dateTime){
    return dateTime == null ? null  : _koreanFormat.format(dateTime);
  }
}
