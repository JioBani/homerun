import 'dart:convert';
import 'package:homerun/Common/StaticLogger.dart';

class NotificationData{
  final DateTime time;
  final String content;
  bool _isNone = false;
  get isNone => _isNone;

  NotificationData(
    this.time,
    this.content
  );

  factory NotificationData.fromMap(Map<String , dynamic> map){
    return NotificationData(
      map['time'].toDate(),
      map['content'],
    );
  }

  String toJsonString(){
    Map<String, dynamic> jsonObject = {
      "content": content,
      "time": time,
    };

    return json.encode(jsonObject);
  }

  Map toJson() => {
    'time': time.toString(),
    'content': content,
  };

  NotificationData setNone(){
    _isNone = true;
    return this;
  }

  static NotificationData fromJson(Map<String, dynamic> loadedJson){
    try {
      return NotificationData(
        DateTime.parse(loadedJson['time']),
        loadedJson['content'],
      );
    } catch (e) {
      // JSON 형식이 아닌 데이터를 처리하는 예외처리
      StaticLogger.logger.e(e);
      return NotificationData.none();
    }
  }

  static NotificationData none(){
    return NotificationData(DateTime.now(),"none").setNone();
  }
}