import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Comment/Exceptions.dart';
import 'package:homerun/Common/Comment/LikeState.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
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
    Query query = commentCollection;

    if(orderBy != OrderType.none){
      query = query.orderBy(orderBy.name, descending: descending);
    }

    if (startAfter != null) {
      if(orderBy == OrderType.none){
        throw InvalidOrderTypeException(orderBy);
      }
      else{
        query = query.startAfterDocument(startAfter.documentSnapshot);
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
    if(uid!= null && commentDto.likes != null){
      likeState = await _getLikeState(doc,uid);
    }

    try{
      return Comment(
        id: doc.id,
        commentDto: CommentDto.fromMap(doc.data() as Map<String, dynamic>),
        likeState: likeState,
        replyCount: 0,
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
              likes: 0,
              dislikes: 0,
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
            replyCount: 0,
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

        await comment.documentSnapshot.reference.delete();
      }
    );
  }

  //#. 좋아요 상태 변경
  Future<Result<LikeState>> updateLikeStatus(Comment comment, int newLikeValue) async {
   return Result.handleFuture<LikeState>(
      action: () async {
        if (newLikeValue != 1 && newLikeValue != -1 && newLikeValue != 0) {
          throw ArgumentError('likeValue must be either 1 (like), -1 (dislike), or 0 (neutral)');
        }

        String userId = Get.find<AuthService>().getUser().uid;

        final likeRef = FirestoreReferences.getCommentLikeDocument(comment.documentSnapshot.reference, userId);

        int likeChange = 0;
        int dislikeChange = 0;

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final likeSnapshot = await transaction.get(likeRef);

          int previousLikeValue = 0;
          if (likeSnapshot.exists) {
            previousLikeValue = likeSnapshot[LikeFields.value];
          }

          if (previousLikeValue != newLikeValue) {
            if (newLikeValue == 0) {
              transaction.delete(likeRef);
            } else {
              transaction.set(likeRef, {
                LikeFields.value: newLikeValue,
                LikeFields.timestamp: FieldValue.serverTimestamp()
              });
            }


            if (previousLikeValue == 1) likeChange -= 1;
            if (previousLikeValue == -1) dislikeChange -= 1;
            if (newLikeValue == 1) likeChange += 1;
            if (newLikeValue == -1) dislikeChange += 1;

            transaction.update(comment.documentSnapshot.reference, {
              CommentFields.likes : FieldValue.increment(likeChange),
              CommentFields.dislikes : FieldValue.increment(dislikeChange),
            });
          }
        });

        return LikeState(
              likeState: newLikeValue,
              likeChange: likeChange,
              dislikeChange: dislikeChange
        );
      }
    );
  }

  Future<Result<int?>> getCommentCount(CollectionReference commentReference){
    return Result.handleFuture<int?>(action: () async => (await commentReference.count().get()).count);
  }
}

class LikeFields{
  static String value = 'value';
  static String timestamp = 'timestamp';
}


