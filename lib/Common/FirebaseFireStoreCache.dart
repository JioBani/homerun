import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';

// https://github.com/furkansarihan/firestore_collection/blob/master/lib/firestore_document.dart
extension FirestoreDocumentExtension on DocumentReference {



  Future<DocumentSnapshot> getSavy() async {
    try {
      DocumentSnapshot ds = await this.get(GetOptions(source: Source.cache));

      if (ds == null){
        StaticLogger.logger.i("get from server");
        return this.get(GetOptions(source: Source.server));
      }
      else{
        StaticLogger.logger.i("get from cache");
        return ds;
      }
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }

  Future<DocumentSnapshot> checkAndGet(Map<String , DateTime> updateTimes , String firestoreCacheField) async {
    try {
      DocumentSnapshot cacheSnapshot = await get(GetOptions(source: Source.cache));

      if(!cacheSnapshot.exists){
        throw Exception("캐쉬가 없음");
      }


      Map<String, dynamic> data = cacheSnapshot.data() as Map<String, dynamic>;

      if(!data.containsKey(firestoreCacheField)){
        throw Exception("필드가 없음");
      }

      Timestamp saveTimeStamp = data[firestoreCacheField] as Timestamp;

      DateTime saveTime = saveTimeStamp.toDate();

      if(updateTimes[cacheSnapshot.id] == null){
        throw Exception("업데이트 타임이 없음");
      }

      if(updateTimes[cacheSnapshot.id]!.millisecondsSinceEpoch > saveTime.millisecondsSinceEpoch){
        StaticLogger.logger.i("${updateTimes[cacheSnapshot.id]} : ${saveTime}");
        StaticLogger.logger.i("서버에서 가져옴");
        return this.get(GetOptions(source: Source.server));
      }
      else{
        StaticLogger.logger.i("${updateTimes[cacheSnapshot.id]} : ${saveTime}");
      }

      StaticLogger.logger.i("캐쉬에서 가져옴");
      return cacheSnapshot;


    } catch (e , s) {
      StaticLogger.logger.e("$e\n$s");
      StaticLogger.logger.i("서버에서 가져옴");
      return this.get(GetOptions(source: Source.server));
    }
  }
}

// https://github.com/furkansarihan/firestore_collection/blob/master/lib/firestore_query.dart
extension FirestoreQueryExtension on Query {
  Future<QuerySnapshot> getSavy() async {
    try {
      QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
      if (qs.docs.isEmpty){
        StaticLogger.logger.i("get from server");
        return this.get(GetOptions(source: Source.server));
      }
      else{
        StaticLogger.logger.i("get from cache");
        return qs;
      }
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }

  Future<QuerySnapshot> checkAndGet(Map<String , DateTime> updateTimes , String firestoreCacheField) async {
    try {
      QuerySnapshot cacheSnapshot = await get(GetOptions(source: Source.cache));

      if(cacheSnapshot.docs.isEmpty){
        throw Exception("캐쉬가 없음");
      }


      for (var doc in cacheSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if(!data.containsKey(firestoreCacheField)){
          throw Exception("필드가 없음");
        }

        Timestamp saveTimeStamp = data[firestoreCacheField] as Timestamp;

        DateTime saveTime = saveTimeStamp.toDate();

        if(updateTimes[doc.id] == null){
          throw Exception("업데이트 타임이 없음");
        }

        if(updateTimes[doc.id]!.millisecondsSinceEpoch > saveTime.millisecondsSinceEpoch){
          StaticLogger.logger.i("${updateTimes[doc.id]} : ${saveTime}");
          StaticLogger.logger.i("서버에서 가져옴");
          return this.get(GetOptions(source: Source.server));
        }
        else{
          StaticLogger.logger.i("${updateTimes[doc.id]} : ${saveTime}");
        }
      }

      StaticLogger.logger.i("캐쉬에서 가져옴");
      return cacheSnapshot;


    } catch (e , s) {
      StaticLogger.logger.e("$e\n$s");
      StaticLogger.logger.i("서버에서 가져옴");
      return this.get(GetOptions(source: Source.server));
    }
  }
}