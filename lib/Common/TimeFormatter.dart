import 'package:intl/intl.dart';

class TimeFormatter {
  final DateFormat _datFormat = DateFormat('yyyy.MM.dd');

  String formatTimeDifference(DateTime dateTime) {
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

  datStringToTime(String string){
    return _datFormat.parseStrict(string);
  }

  dateToDatString(DateTime dateTime){
    return _datFormat.format(dateTime);
  }
}
