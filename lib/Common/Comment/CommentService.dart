import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

import 'Comment.dart';
import 'CommentDto.dart';

class CommentService {

  Future<Result<List<Comment>>> getComments({
    required CollectionReference commentCollection,
    required String noticeId,
    required String reviewId,
    int? index,
    Comment? startAfter,
    OrderType orderBy = OrderType.none,
    bool descending = true
  }) {
    return Result.handleFuture<List<Comment>>(
        action: () async {

          //#1. 쿼리 만들기
          Query query = _makeQuery(
            commentCollection: commentCollection,
            noticeId: noticeId,
            reviewId: reviewId,
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
    required String noticeId,
    required String reviewId,
    int? index,
    Comment? startAfter,
    OrderType orderBy = OrderType.none,
    bool descending = true
  }){
    Query query = commentCollection.orderBy(OrderType.date, descending: descending);

    if (startAfter != null) {
      if(orderBy == OrderType.date){
        query = query.startAfter([startAfter.commentDto.date]);
      }
      else if(orderBy == OrderType.likes){
        query = query.startAfter([startAfter.commentDto.like]);
      }
      else{
        throw InvalidOrderTypeException(startAfter);
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
          likeState: likeState
      );
    }catch(e , s){
      StaticLogger.logger.e('[CommentService._makeComment() $e\n$s]');
      return Comment.error();
    }
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
        return 'free';
      case OrderType.date:
        return 'date';
      case OrderType.likes:
        return 'likes';
      default:
        throw UnimplementedError('Unexpected CommentType: $this');
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
}

