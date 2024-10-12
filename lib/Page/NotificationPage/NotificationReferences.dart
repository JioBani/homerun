import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationReferences{
  static DocumentReference getAnnouncementNotificationReferences(String uid){
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('notification').doc('announcement');
  }
}
