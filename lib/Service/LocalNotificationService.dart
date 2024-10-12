import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homerun/Common/StaticLogger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get notificationsPlugin => _notificationsPlugin;

  static Random random = Random();

  // Android 알림 채널 정의
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "homerun", // 채널의 고유 ID
    "청약홈런",   // 채널의 이름 (사용자에게 표시됨)
    description: "청약홈런", // 채널 설명 (사용자에게 표시될 설명)
    importance: Importance.max,
  );

  static const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"), // Android에서 사용하는 앱 아이콘 설정
      iOS: DarwinInitializationSettings() // iOS 초기화 설정
  );

  static void initialize(BuildContext context) async {
    // Android 알림 채널 생성 (Android 전용)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 알림 초기화
    // 사용자가 알림을 클릭했을 때 특정 경로로 이동할 수 있도록 설정
    _notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (route) async {
          Navigator.of(context).pushNamed(route as String); // 알림을 클릭했을 때 해당 경로로 네비게이트
    });
  }

  // 푸쉬 알림을 로컬 알림으로 표시하는 메서드
  // Firebase에서 수신한 RemoteMessage를 받아서 처리
  static void display(RemoteMessage message) async {
    try {
      // Android 및 iOS의 알림 세부 설정
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, // 위에서 정의한 채널 ID
          channel.name, // 채널 이름
          channelDescription: channel.description, // 채널 설명
          importance: Importance.max, // 알림 우선순위 설정
          priority: Priority.high, // 우선순위를 높게 설정하여 화면에 알림이 표시되도록 설정
        ),
        iOS: const DarwinNotificationDetails(), // iOS 알림 세부 설정
      );

      // Android 플랫폼에서만 알림을 표시하도록 조건 설정
      // 알림 메시지가 존재하는지 확인 후 알림을 로컬에 표시
      if (message.notification != null && Platform.isAndroid) {
        await _notificationsPlugin.show(
          message.notification.hashCode, // 알림의 고유 ID
          message.notification?.title, // 알림 제목
          message.notification?.body, // 알림 내용
          notificationDetails, // 알림 세부 설정 (앞에서 정의한 Android, iOS 설정)
          payload: message.data["route"], // 추가 데이터 (경로 정보)
        );
      }
    } on Exception catch (e) {
      // 오류 발생 시 출력
      StaticLogger.logger.e(e);
    }
  }

  static void displayLocal({required String title, required String body}) async {
    try {
      // Android 및 iOS의 알림 세부 설정
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, // 위에서 정의한 채널 ID
          channel.name, // 채널 이름
          channelDescription: channel.description, // 채널 설명
          importance: Importance.max, // 알림 우선순위 설정
          priority: Priority.high, // 우선순위를 높게 설정하여 화면에 알림이 표시되도록 설정
        ),
        iOS: const DarwinNotificationDetails(), // iOS 알림 세부 설정
      );

      // Android 플랫폼에서만 알림을 표시하도록 조건 설정
      // 알림 메시지가 존재하는지 확인 후 알림을 로컬에 표시
      await _notificationsPlugin.show(
        random.nextInt((pow(2,31) as int) - 1), // 알림의 고유 ID
        title, // 알림 제목
        body, // 알림 내용
        notificationDetails, // 알림 세부 설정 (앞에서 정의한 Android, iOS 설정)
      );
    } on Exception catch (e) {
      // 오류 발생 시 출력
      StaticLogger.logger.e(e);
    }
  }
}
