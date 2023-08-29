
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/NotificationData.dart';
import 'package:homerun/Model/TestData.dart';

class FirebaseFirestoreService{

  final CollectionReference _notificationCollection = FirebaseFirestore.instance.collection('notification');

  static FirebaseFirestoreService? _instance;

  FirebaseFirestoreService._();

  static FirebaseFirestoreService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= FirebaseFirestoreService._();
    return _instance!;
  }



  Future<List<NotificationData>> getNotificationData() async {
    try{
      final snapshot = await _notificationCollection.get();

      List<NotificationData> dataList = [];


      for (var element in snapshot.docs) {
        dataList.add(NotificationData.fromMap(element.data() as Map<String, dynamic>));
      }

      return dataList;

    }catch(e){
      StaticLogger.logger.e(e);
      return [];
    }
  }
}