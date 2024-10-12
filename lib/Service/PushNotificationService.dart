import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/LocalNotificationService.dart';

class PushNotificationService{
  static void init(BuildContext context) {
    // LocalNotificationService를 초기화하여 로컬 알림을 설정합니다.
    LocalNotificationService.initialize(context);

    // 푸쉬 알림 권한 요청 (iOS 전용)
    FirebaseMessaging.instance.requestPermission(
      alert: true, // 알림 배너 허용
      announcement: false,
      badge: true, // 배지 표시 허용
      carPlay: true, // CarPlay에서 알림 허용
      criticalAlert: false, // 중요한 알림 허용 (긴급성 높은 알림)
      provisional: false, // 임시 권한 요청 비활성화
      sound: true, // 알림 소리 허용
    );

    // 앱이 포어그라운드에 있을 때에도 알림을 표시할 수 있도록 설정 (iOS/Android)
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,  // 헤드업 알림을 표시
      badge: true,  // 배지를 업데이트
      sound: true,  // 알림 소리 재생
    );

    // iOS 전용: APNS 토큰을 가져옴 (iOS의 경우 Firebase 대신 APNS가 푸쉬 알림을 관리)
    FirebaseMessaging.instance.getAPNSToken().then((APNStoken) {
      // 가져온 APNS 토큰을 출력하거나, 서버에 저장하여 사용 가능
      // print(APNStoken);
    });

    // 앱이 완전히 종료된 상태에서 푸쉬 알림을 통해 앱이 실행된 경우 처리
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // 푸쉬 알림에서 전달된 경로(route)를 가져와서 해당 경로로 네비게이트
        final routeFromMessage = message.data["route"];
        if(context.mounted){
          Navigator.of(context).pushNamed(routeFromMessage);
        }
        else{
          StaticLogger.logger.e("[PushNotificationService.getInitialMessage()] context not mounted");
        }
      }
    });

    // 앱이 포어그라운드 상태일 때 푸쉬 알림을 수신할 경우 처리
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // 로컬 알림을 표시하여 사용자에게 푸쉬 알림 내용을 보여줍니다.
        LocalNotificationService.display(message);
      }
    });

    // 앱이 백그라운드 상태이지만 열려 있는 경우, 푸쉬 알림을 클릭하면 해당 알림의 데이터를 처리
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        // 푸쉬 알림에서 전달된 경로(route)를 가져와서 해당 경로로 네비게이트
        final routeFromMessage = message.data["route"];
        if(context.mounted){
          Navigator.of(context).pushNamed(routeFromMessage);
        }
        else{
          StaticLogger.logger.e("[PushNotificationService.onMessageOpenedApp()] context not mounted");
        }
      }
    });
  }
}
