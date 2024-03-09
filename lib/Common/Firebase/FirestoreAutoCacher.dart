import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/FileDataService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreAutoCacher{
  CollectionReference collectionReference;
  bool _isUpdated = false;
  bool _isAddOrDeleted = false;
  Map<String , DateTime>? _updatedTimeMap;
  late Stream<DocumentSnapshot> _updatedTimesStream;
  final String _cacheField;
  DocumentSnapshot? _lastUpdatedSnapshot;
  Timestamp? _addOrDeletedTime;


  FirestoreAutoCacher({
    required this.collectionReference,
    required DocumentReference updatedTimesDocument,
    required String cacheField
  }) : _cacheField = cacheField{

    _updatedTimesStream = updatedTimesDocument.snapshots();

    _updatedTimesStream.listen((snapshot) {
      StaticLogger.logger.i("[FirestoreCacheController.onChanged()] 데이터가 업데이트 됨 : ${DateTime.now().toLocal()}");
      _isUpdated = true;
      _lastUpdatedSnapshot = snapshot;

      try{
        Timestamp timestamp = snapshot.get('addOrDeleted') as Timestamp;

        if(_addOrDeletedTime == null || _addOrDeletedTime!.millisecondsSinceEpoch < timestamp.millisecondsSinceEpoch){
          _isAddOrDeleted = true;
          StaticLogger.logger.i("[FirestoreCacheController.onChanged()] 추가되거나 지워진 데이터가 있음 : ${DateTime.now().toLocal()}");
          _addOrDeletedTime = timestamp;
        }
      }catch(e){
        _isAddOrDeleted = true;
        StaticLogger.logger.e("[FirestoreAutoCacher.listener()] $e");
      }

    });

  }

  Future<QuerySnapshot<Object?>> getQuerySnapshot(Query query) async {

    if(_isUpdated || _updatedTimeMap == null){
      _updateData();
    }

    try {

      if(_isAddOrDeleted){
        _isAddOrDeleted = false;
        StaticLogger.logger.i("추가된 데이터 있음 : 서버에서 가져옴");
        return query.get(const GetOptions(source: Source.server));
      }

      QuerySnapshot cacheSnapshot = await query.get(const GetOptions(source: Source.cache));

      if(cacheSnapshot.docs.isEmpty){
        throw Exception("캐쉬가 없음");
      }


      for (var doc in cacheSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if(!data.containsKey(_cacheField)){
          throw Exception("필드가 없음");
        }

        Timestamp saveTimeStamp = data[_cacheField] as Timestamp;

        DateTime saveTime = saveTimeStamp.toDate();

        if(_updatedTimeMap![doc.id] == null){
          throw Exception("업데이트 타임이 없음");
        }

        if(_updatedTimeMap![doc.id]!.millisecondsSinceEpoch > saveTime.millisecondsSinceEpoch){
          StaticLogger.logger.i("서버 ${_updatedTimeMap![doc.id]} : 캐쉬 ${saveTime}");
          StaticLogger.logger.i("서버에서 가져옴");
          return query.get(const GetOptions(source: Source.server));
        }
        else{
          StaticLogger.logger.i("${_updatedTimeMap![doc.id]} : ${saveTime}");
        }
      }

      StaticLogger.logger.i("캐쉬에서 가져옴");
      return cacheSnapshot;


    } catch (e , s) {
      StaticLogger.logger.e("$e\n$s");
      StaticLogger.logger.i("서버에서 가져옴");
      return query.get(const GetOptions(source: Source.server));
    }
  }

  Future<DocumentSnapshot<Object?>> getDocumentSnapshot(DocumentReference documentReference) async {

    if(_isUpdated || _updatedTimeMap == null){
      await _updateData();
    }

    try {

      if(_isAddOrDeleted){
        _isAddOrDeleted = false;
        StaticLogger.logger.i("추가된 데이터 있음 : 서버에서 가져옴");
        return documentReference.get(const GetOptions(source: Source.server));
      }

      DocumentSnapshot cacheSnapshot = await documentReference.get(const GetOptions(source: Source.cache));

      if(!cacheSnapshot.exists){
        throw Exception("캐쉬가 없음");
      }


      Map<String, dynamic> data = cacheSnapshot.data() as Map<String, dynamic>;

      if(!data.containsKey(_cacheField)){
        throw Exception("필드가 없음");
      }

      Timestamp saveTimeStamp = data[_cacheField] as Timestamp;

      DateTime saveTime = saveTimeStamp.toDate();

      if(_updatedTimeMap![cacheSnapshot.id] == null){
        throw Exception("업데이트 타임이 없음");
      }

      if(_updatedTimeMap![cacheSnapshot.id]!.millisecondsSinceEpoch > saveTime.millisecondsSinceEpoch){
        StaticLogger.logger.i("${_updatedTimeMap![cacheSnapshot.id]} : ${saveTime}");
        StaticLogger.logger.i("서버에서 가져옴");
        return documentReference.get(const GetOptions(source: Source.server));
      }
      else{
        StaticLogger.logger.i("${_updatedTimeMap![cacheSnapshot.id]} : ${saveTime}");
      }

      StaticLogger.logger.i("캐쉬에서 가져옴");
      return cacheSnapshot;


    } catch (e , s) {
      StaticLogger.logger.e("$e\n$s");
      StaticLogger.logger.i("서버에서 가져옴");
      return documentReference.get(const GetOptions(source: Source.server));
    }
  }

  Future<void> _updateData() async {

    _updatedTimeMap ??= <String, DateTime>{};

    if(_lastUpdatedSnapshot == null){
      StaticLogger.logger.e("[FirestoreCacheController._updateData()] 마지막 스냅샷이 null 임");
      return;
    }

    Map<String, dynamic> updates = (_lastUpdatedSnapshot!.data() as Map<String, dynamic>)[_cacheField];

    updates.forEach((key, value) {
      try{
        _updatedTimeMap![key] = (value as Timestamp).toDate();
      }catch(e , s){
        StaticLogger.logger.i("$key : $e \n $s");
      }

      //_guideUpdateTimeMap
    });

    StaticLogger.logger.i("업데이트 추적 문서가 업데이트 되었습니다: $updates");
    _isUpdated = false;
  }

}