import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';
import 'package:homerun/Service/Auth/SignInService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

class CommentService{
  Future<Result> uploadComment(String content, String noticeId) async {

    var signInService = Get.find<SignInService>();

    try{
      UserDto userDto = signInService.getUser();

      if(userDto.displayName == null){
        throw UnknownUserInfoException(message:  'Unknown display name.');
      }

      var res = await FirebaseResponse.handleRequest<dynamic>(
          action: ()=> FirebaseFirestore.instance.collection('notice_comment').doc(noticeId).collection('free').add(
              CommentDto(
                  displayName: userDto.displayName!,
                  date: Timestamp.now(),
                  like: 0,
                  dislike: 0,
                  content: content,
                  uid: userDto.uid
              ).toMap()
          )
      );

      if(res.isSuccess){
        StaticLogger.logger.i('댓글 업로드 : $content , $noticeId');
        return Result<void>.fromSuccess();
      }
      else{
        throw res.exception!;
      }

    }catch(e , s){
      if(e is FirebaseException){
        StaticLogger.logger.e('[delete] 업로드 실패 : Firebase : ${e.code}');
      }
      else if(e is TimeoutException){
        StaticLogger.logger.e('[delete] 업로드 실패 : 인터넷');
      }
      else{
        StaticLogger.logger.e('[delete] 업로드 실패 : $e');
      }
      return Result<void>.fromFailure(e, s);
    }
  }

  Future<void> delete(String noticeId , String commentId) async {

    var res = await FirebaseResponse.handleRequest<dynamic>(
        action: FirebaseFirestore.instance.collection('notice_comment').doc(noticeId).collection('free').doc(commentId).delete
    );

    if(res.isSuccess){
      StaticLogger.logger.i('삭제 성공');
    }
    else{
      if(res.exception is FirebaseException){
        FirebaseException firebaseException = res.exception as FirebaseException;
        StaticLogger.logger.e('[delete] 삭제 실패 : Firebase : ${firebaseException.code}');
      }
      else if(res.exception is TimeoutException){
        StaticLogger.logger.e('[delete] 삭제 실패 : 인터넷');
      }
      else{
        StaticLogger.logger.e('[delete] 삭제 실패 : ${res.exception}');
      }

      StaticLogger.logger.e(res.exception.runtimeType.toString());
    }
  }

  Future<void> like(String noticeId , String commentId) async{
    String userId = Get.find<SignInService>().getUser().uid;

    final commentRef = FirebaseFirestore.instance
        .collection('notice_comment')
        .doc(noticeId)
        .collection('free')
        .doc(commentId);

    final likeRef = commentRef.collection('likes').doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final DocumentSnapshot likeSnapshot = await likeRef.get();

      if (!likeSnapshot.exists || likeSnapshot['value'] != 1) {
        transaction.set(likeRef, {'value': 1, 'timestamp': FieldValue.serverTimestamp()});
        transaction.update(commentRef, {
          'like': FieldValue.increment(1),
          'dislike': likeSnapshot.exists && likeSnapshot['value'] == -1
              ? FieldValue.increment(-1)
              : FieldValue.increment(0),
        });
      }
    });
  }

  Future<Result> updateLikeStatus(String noticeId, String commentId, int newLikeValue) async {
    try{
      if (newLikeValue != 1 && newLikeValue != -1 && newLikeValue != 0) {
        throw ArgumentError('likeValue must be either 1 (like), -1 (dislike), or 0 (neutral)');
      }

      String userId = Get.find<SignInService>().getUser().uid;

      final commentRef = FirebaseFirestore.instance
          .collection('notice_comment')
          .doc(noticeId)
          .collection('free')
          .doc(commentId);

      final likeRef = commentRef.collection('likes').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final likeSnapshot = await transaction.get(likeRef);

        int previousLikeValue = 0;
        if (likeSnapshot.exists) {
          previousLikeValue = likeSnapshot['value'];
        }

        if (previousLikeValue != newLikeValue) {
          if (newLikeValue == 0) {
            transaction.delete(likeRef);
          } else {
            transaction.set(likeRef, {
              'value': newLikeValue,
              'timestamp': FieldValue.serverTimestamp()
            });
          }

          int likeChange = 0;
          int dislikeChange = 0;

          if (previousLikeValue == 1) likeChange -= 1;
          if (previousLikeValue == -1) dislikeChange -= 1;
          if (newLikeValue == 1) likeChange += 1;
          if (newLikeValue == -1) dislikeChange += 1;

          transaction.update(commentRef, {
            'like': FieldValue.increment(likeChange),
            'dislike': FieldValue.increment(dislikeChange),
          });
        }
      });

      return Result<void>.fromSuccess();
    }catch(e , s){
      return Result<void>.fromFailure(e, s);
    }
  }
}

