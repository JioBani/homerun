import 'package:cloud_firestore/cloud_firestore.dart';

class ScrapReferences{
  static CollectionReference getNoticeCollection(String userId){
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('scrap')
        .doc("notice")
        .collection('content');
  }
}