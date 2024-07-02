import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

enum SortOrder{
  likes,  // 조회순
  latest
}

enum CommentType{
  free,
  eligibility
}

extension CommentTypeExtension on CommentType{
  String get name {
    switch (this) {
      case CommentType.free:
        return 'free';
      case CommentType.eligibility:
        return 'eligibility';
      default:
        throw UnimplementedError('Unexpected CommentType: $this');
    }
  }
}

class CommentService{
  
  final CollectionReference _commentCollection = FirebaseFirestore.instance.collection('notice_comment');

  static CommentService? _instance;

  CommentService._();

  static CommentService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= CommentService._();
    return _instance!;
  }

  Future<Result<List<Comment>>> getComments({
    required String noticeId,
    required SortOrder orderBy,
    required CommentType type,
    int? index,
    String? replyTarget,
    DocumentSnapshot? startAfter
  }) async {
    //_getComment에서 시간이 얼마나 걸릴지 알 수 없기 때문에 Result.handleFuture 사용 x
    try{
      Query query = _commentCollection.doc(noticeId).collection(type.name);

      if(replyTarget != null){
        query = _commentCollection.doc(noticeId).collection(type.name).doc(replyTarget).collection('reply');
      }

      if(orderBy == SortOrder.latest){
        query.orderBy('date',descending: true);
      }
      else{
        query.orderBy('like',descending: true);
      }

      if(startAfter != null){
        query = query.startAfterDocument(startAfter);
      }

      if(index != null){
        query = query.limit(index);
      }



      //#. 좋아요 싫어요 상태를 불러오기 위해 uid 가져오기
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      QuerySnapshot querySnapshot = await query.get();

      List<Comment> comments = await Future.wait(querySnapshot.docs.map((e) => _getComment(e , uid)));

      return Result<List<Comment>>.fromSuccess(content : comments);
    }catch(e,s){
      StaticLogger.logger.e('[CommentService.getComments()] $e\n$s');
      return Result.fromFailure(e, s);
    }

  }

  Future<Comment> _getComment(DocumentSnapshot doc, String? uid) async {
    try {
      int likeState;

      if (uid != null) {
        DocumentSnapshot likeDoc = await doc.reference.collection('likes').doc(uid).get();

        if (likeDoc.exists) {
          likeState = likeDoc['value'] as int;
        }
        else {
          likeState = 0;
        }
      }
      else {
        likeState = 0;
      }

      CommentDto commentDto = CommentDto.fromMap(doc.data() as Map<String, dynamic>);

      return Comment(
        commentId: doc.id,
        commentDto: commentDto,
        likeState: likeState,
        snapshot: doc
      );
    }
    catch (e) {
      StaticLogger.logger.e('[CommentLoader.getComment()] ${doc.id} : $e');
      return Comment(
        commentId: doc.id,
        commentDto: CommentDto.fromMap(doc.data() as Map<String, dynamic>),
        likeState: 0,
        snapshot: null
      );
    }
  }

  Future<Result> uploadComment(String content, String noticeId , {String? replyTarget}) async {

    var signInService = Get.find<AuthService>();

    try{
      UserDto userDto = signInService.getUser();

      if(userDto.displayName == null){
        throw UnknownUserInfoException(message:  'Unknown display name.');
      }

      CollectionReference ref;

      if(replyTarget == null){
        ref = FirebaseFirestore.instance.collection('notice_comment').doc(noticeId).collection('free');
      }
      else{
        ref = FirebaseFirestore.instance
            .collection('notice_comment')
            .doc(noticeId)
            .collection('free')
            .doc(replyTarget)
            .collection('reply');
      }

      var res = await FirebaseResponse.handleRequest<dynamic>(
          action: ()=> ref.add(
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

  Future<void> delete(String noticeId , String commentId , {String? replyTarget}) async {

    DocumentReference ref;

    if(replyTarget == null){
      ref = FirebaseFirestore.instance.collection('notice_comment').doc(noticeId).collection('free').doc(commentId);
    }
    else{
      ref = FirebaseFirestore.instance
          .collection('notice_comment')
          .doc(noticeId)
          .collection('free')
          .doc(replyTarget)
          .collection('reply')
          .doc(commentId);
    }

    var res = await FirebaseResponse.handleRequest<dynamic>(
        action: ref.delete
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
    String userId = Get.find<AuthService>().getUser().uid;

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

      String userId = Get.find<AuthService>().getUser().uid;

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

