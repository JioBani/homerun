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
}

