import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

import 'Comment.dart';
import 'CommentDto.dart';

class CommentService {

  static CommentService? _instance;

  CommentService._();

  static CommentService get instance {
    _instance ??= CommentService._();
    return _instance!;
  }

  //#. 댓글 가져오기
  Future<Result<List<Comment>>> getComments({
    required CollectionReference commentCollection,
    int? index,
    Comment? startAfter,
    required OrderType orderBy,
    bool descending = true
  }) {
    return Result.handleFuture<List<Comment>>(
        action: () async {

          //#1. 쿼리 만들기
          Query query = _makeQuery(
            commentCollection: commentCollection,
            index: index,
            startAfter: startAfter,
            orderBy: orderBy,
            descending: descending,
          );

          //#2. 데이터 가져오기
          QuerySnapshot querySnapshot = await query.get();

          UserDto? userDto = Get.find<AuthService>().tryGetUser();

          return Future.wait(querySnapshot.docs.map((doc) => _makeComment(doc , userDto?.uid)));
        }
    );
  }

  Query _makeQuery({
    required CollectionReference commentCollection,
    int? index,
    Comment? startAfter,
    OrderType orderBy = OrderType.none,
    bool descending = true
  }){
    Query query = commentCollection.orderBy(OrderType.date.name, descending: descending);

    if (startAfter != null) {
      if(orderBy == OrderType.date){
        query = query.startAfter([startAfter.commentDto.date]);
      }
      else if(orderBy == OrderType.likes){
        query = query.startAfter([startAfter.commentDto.like]);
      }
      else{
        throw InvalidOrderTypeException(orderBy);
      }
    }

    if(index != null){
      query = query.limit(index);
    }

    return query;
  }

  Future<int> _getLikeState(DocumentSnapshot doc , String uid) async {
    DocumentSnapshot likeDoc = await doc.reference.collection('likes').doc(uid).get();

    if (likeDoc.exists) {
      return likeDoc['value'] as int;
    }
    else {
      return 0;
    }
  }

  Future<Comment> _makeComment(DocumentSnapshot doc,String? uid)async{
    CommentDto commentDto = CommentDto.fromMap(doc.data() as Map<String, dynamic>);

    int? likeState;
    if(uid!= null && commentDto.like != null){
      likeState = await _getLikeState(doc,uid);
    }

    try{
      return Comment(
        id: doc.id,
        commentDto: CommentDto.fromMap(doc.data() as Map<String, dynamic>),
        likeState: likeState,
        documentSnapshot: doc
      );
    }catch(e , s){
      StaticLogger.logger.e('[CommentService._makeComment() $e\n$s]');
      return Comment.error(doc);
    }
  }

  //#. 댓글 업로드
  Future<Result<Comment>> upload({
    required CollectionReference commentCollection,
    required String content,
    bool hasLikes = false,
    DocumentReference? replyTarget
  }) {
    return Result.handleFuture<Comment>(
        action: () async {
          UserDto? userDto = Get.find<AuthService>().getUser();

          CommentDto commentDto;

          if(hasLikes){
            commentDto  = CommentDto(
              uid: userDto.uid,
              content: content,
              date: Timestamp.now(),
              like: 0,
              dislike: 0,
              replyTarget: replyTarget
            );
          }
          else{
            commentDto  = CommentDto(
              uid: userDto.uid,
              content: content,
              date: Timestamp.now(),
              replyTarget: replyTarget
            );
          }

          DocumentReference docRef = await commentCollection.add(commentDto.toMap());

          DocumentSnapshot doc = await docRef.get();

          return Comment(
            id: docRef.id,
            commentDto: commentDto,
            likeState: 0,
            documentSnapshot: doc,
          );
        }
    );
  }

  //#. 댓글 삭제
  Future<Result<void>> delete(Comment comment){
    return Result.handleFuture<void>(
      action : ()async{
        if(Get.find<AuthService>().getUser().uid != comment.commentDto.uid){
          throw NotOwnerException();
        }

        await comment.documentSnapshot!.reference.delete();
      }
    );
  }

}

enum OrderType {
  none,
  date,
  likes
}

extension OrderTypeExtension on OrderType{
  String get name {
    switch (this) {
      case OrderType.none:
        return 'none';
      case OrderType.date:
        return 'date';
      case OrderType.likes:
        return 'likes';
      default:
        throw UnimplementedError('Unexpected CommentType: $this');
    }
  }
}

enum NoticeCommentType {
  free,
  eligibility,
}

extension NoticeCommentTypeExtension on NoticeCommentType{
  String get name {
    switch (this) {
      case NoticeCommentType.free:
        return 'free';
      case NoticeCommentType.eligibility:
        return 'eligibility';
      default:
        throw UnimplementedError('Unexpected NoticeCommentType: $this');
    }
  }
}

abstract class CommentServiceException implements Exception{
  final String? message;

  CommentServiceException(this.message);

  @override
  String toString() {
    return "$message";
  }
}

class InvalidOrderTypeException extends CommentServiceException implements Exception {
  InvalidOrderTypeException(Object? order) : super('Unexpected OrderType: $order');

  @override
  String toString() {
    return "InvalidOrderTypeException: $message";
  }
}

class NotOwnerException extends CommentServiceException {
  NotOwnerException() : super('User is not the owner of this comment');

  @override
  String toString() {
    return "NotOwnerException: $message";
  }
}


