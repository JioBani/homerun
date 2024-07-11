import 'package:cloud_firestore/cloud_firestore.dart';

//모든 firestore의 접근은 이 클래스의 메소드를 지나가야함
class CommentReferences{
  static CollectionReference getSiteReviewComment(String noticeId, String reviewId){
    return FirebaseFirestore.instance
        .collection('site_review')
        .doc(noticeId)
        .collection('review')
        .doc(reviewId)
        .collection('comment');
  }

  static CollectionReference getNoticeComment(String noticeId, String type){
    return FirebaseFirestore.instance
        .collection('notice_comment')
        .doc(noticeId)
        .collection(type);
  }

  static CollectionReference getReplyCollection(DocumentReference replyRef){
    return replyRef.collection('reply');
  }

  static DocumentReference getCommentLikeDocument(DocumentReference commentRef , String userId){
    return commentRef.collection('likes').doc(userId);
  }
}