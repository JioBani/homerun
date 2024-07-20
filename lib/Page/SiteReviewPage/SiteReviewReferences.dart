import 'package:cloud_firestore/cloud_firestore.dart';

class SiteReviewReferences{
  static CollectionReference getReviewCollection(String noticeId)  {
    return FirebaseFirestore.instance.collection('site_review').doc(noticeId).collection('review');
  }

  static String getReviewImagePath(String noticeId , String docId){
    return "site_review/$noticeId/$docId/";
  }
}