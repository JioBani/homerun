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
}