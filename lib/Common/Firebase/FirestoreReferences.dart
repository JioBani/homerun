import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreReferences{
  static CollectionReference getSiteReviewComment(String noticeId, String reviewId){
    return FirebaseFirestore.instance
        .collection('site_review')
        .doc(noticeId)
        .collection('review')
        .doc(reviewId)
        .collection('comment');
  }
}