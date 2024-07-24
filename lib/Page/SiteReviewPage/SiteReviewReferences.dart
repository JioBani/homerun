import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SiteReviewReferences{
  static CollectionReference getReviewCollection(String noticeId)  {
    return FirebaseFirestore.instance.collection('site_review').doc(noticeId).collection('review');
  }

  static DocumentReference getReviewDocument(String noticeId , String reviewId)  {
    return FirebaseFirestore.instance.collection('site_review').doc(noticeId).collection('review').doc(reviewId);
  }

  static String getReviewImageFolderPath(String noticeId , String docId){
    return "site_review/$noticeId/$docId/";
  }

  static Reference getReviewImageRef(String noticeId , String docId , String fileName){
    return FirebaseStorage.instance.ref().child('site_review/$noticeId/$docId/$fileName');
  }

  static String getReviewThumbnailPath(String noticeId , String docId , String thumbnailImageName){
    return "site_review/$noticeId/$docId/$thumbnailImageName";
  }

  static DocumentReference getReviewLikeDocument(String noticeId, String reviewId, String uid)  {
    return FirebaseFirestore.instance
        .collection('site_review')
        .doc(noticeId)
        .collection('review')
        .doc(reviewId)
        .collection('like')
        .doc(uid);
  }
}