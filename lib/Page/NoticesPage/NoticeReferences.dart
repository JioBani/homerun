import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeReferences{
  static DocumentReference getLikeDocument(String noticeId , String uid)  {
    return FirebaseFirestore.instance.collection('notice').doc(noticeId).collection('like').doc(uid);
  }

  static CollectionReference getNoticeCollection()  {
    return FirebaseFirestore.instance.collection('notice');
  }
}