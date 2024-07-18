import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/UploadResult.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';

import '../Exception/SiteServiceException.dart';

class SiteReviewService{

  final CollectionReference _siteReviewCollection = FirebaseFirestore.instance.collection('site_review');

  static SiteReviewService? _instance;

  SiteReviewService._();

  static SiteReviewService get instance {
    _instance ??= SiteReviewService._();
    return _instance!;
  }

  Future<Result<List<SiteReview>>> getSiteReviews(String noticeId, {int? index}) {
    return Result.handleFuture<List<SiteReview>>(
      action: () async {
        QuerySnapshot querySnapshot;

        if(index != null){
          querySnapshot = await _siteReviewCollection.doc(noticeId).collection('review').limit(index).get();
        }
        else{
          querySnapshot = await _siteReviewCollection.doc(noticeId).collection('review').get();
        }

        List<SiteReview> reviews = querySnapshot.docs.map(
                (review) => SiteReview.fromMap(review.data() as Map<String,dynamic> , review.id)
        ).toList();

        return reviews;
      }
    );
  }

  Future<UploadResultInfo> upload(
      SiteReviewWriteDto siteReviewWriteDto,
      List<XFile> images,
      void Function(UploadState, String, Object?)? onProgress
      ) async{

    //#1. 유저 정보 가져오기
    UserDto userDto;

    try{
      userDto = Get.find<AuthService>().getUser();
    }catch(e , s){
      if(onProgress != null){
        onProgress(UploadState.fail,'로그인이 되어 있지 않습니다.',e);
      }
      return UploadResultInfo.fromFailure(
          state: UploadResult.authFailure,
          exception: e,
          stackTrace: s
      );
    }


    //#2. 리뷰 문서 만들기
    DocumentReference documentReference;

    try{
      documentReference = await _createDocument(siteReviewWriteDto.noticeId,userDto.uid);

      if(onProgress != null){
        onProgress(UploadState.progress,'문서 만들기 성공',null);
      }
    }catch(e,s){
      if(onProgress != null){
        onProgress(UploadState.fail,'문서 만들기 실패',e);
      }
      return UploadResultInfo.fromFailure(
          state: UploadResult.createDocFailure,
          exception: e,
          stackTrace: s
      );
    }

    //#3. 리뷰 문서에 정보 저장하기
    try{
      await _updateDocument(siteReviewWriteDto , documentReference , userDto.uid);

      if(onProgress != null){
        onProgress(UploadState.progress,'문서 저장 성공',null);
      }

    }catch(e1 , s){
      try{
        await _siteReviewCollection
            .doc(siteReviewWriteDto.noticeId)
            .collection('review')
            .doc()
            .delete();
      }catch(e2){
        StaticLogger.logger.e('[SiteReviewService.write()] 삭제 실패 $e2');
      }

      if(onProgress != null){
        onProgress(UploadState.fail,'문서 저장 실패',e1);
      }

      return UploadResultInfo.fromFailure(
          state: UploadResult.writeDocFailure,
          exception: e1,
          stackTrace: s
      );
    }


    //#4. 이미지 업로드
    Map<XFile , Result<void>> result = await _uploadImage(
        images,siteReviewWriteDto.noticeId,documentReference.id,null
    );

    //#4-1. 이미지 업로드 에러 처리
    bool hasImageUploadError = false;
    List<String> errorImageNames = [];
    late Result lastError;

    result.forEach((key, value) {
      if(!value.isSuccess) {
        errorImageNames.add(key.path);
        hasImageUploadError = true;
        lastError = value;
      }
    });

    //#5. 업로드 결과 가져오기
    SiteReview review;
    try{
      review = SiteReview.fromDocumentSnapshot(await documentReference.get());
    }catch(e , s){
      return UploadResultInfo.fromFailure(
          state: UploadResult.getUploadedDocFailure,
          exception: e,
          stackTrace: s
      );
    }

    //#6. 반환
    if(!hasImageUploadError){
      return UploadResultInfo.fromSuccess(review);
    }
    else{
      return UploadResultInfo.fromFailure(
        state: UploadResult.writeDocFailure,
        exception: lastError.exception!,
        stackTrace: lastError.stackTrace!,
        failImages: errorImageNames,
      );
    }
  }


  Future<DocumentReference> _createDocument(String noticeId, String uid) async {
    return await _siteReviewCollection
        .doc(noticeId)
        .collection('review')
        .add({'writer': uid});
  }

  Future<void> _updateDocument(SiteReviewWriteDto siteReviewWriteDto, DocumentReference documentReference, String uid) async {
    SiteReview siteReview = SiteReview.fromWriteDto(writeDto: siteReviewWriteDto, uid: uid, docId: documentReference.id);

    await _siteReviewCollection
        .doc(siteReview.noticeId)
        .collection('review')
        .doc(documentReference.id)
        .update(siteReview.toUploadMap());
  }

  Future<Map<XFile , Result<void>>> _uploadImage(
      List<XFile> images,
      String noticeId,
      String docId,
      void Function(TaskSnapshot)? snapshotEventAction
      ) async {
    List<Map<XFile, Result<void>>> mapList = await Future.wait(images.map((imageFile) async {
      try {
        String fileName = imageFile.name;
        Reference storageRef = FirebaseStorage.instance.ref().child('site_review/$noticeId/$docId/$fileName');
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));

        uploadTask.snapshotEvents.listen(snapshotEventAction);

        await uploadTask.whenComplete(() {});
        return {imageFile: Result<void>.fromSuccess()};
      }
      catch (e, s) {
        StaticLogger.logger.e("[SiteReviewService._uploadImage()] $e\n$s");
        return {imageFile: Result<void>.fromFailure(e, s)};
      }
    }));

    Map<XFile, Result<void>> resultMap = {};

    for (var map in mapList) {
      resultMap.addAll(map);
    }
    return resultMap;
  }



  // Future<Result<void>> uploadComment(String content, String noticeId, String reviewId)=>
  //     Result.handleFuture<void>(
  //       action: () async {
  //         CollectionReference commentRef = _siteReviewCollection.doc(noticeId)
  //             .collection('review')
  //             .doc(reviewId)
  //             .collection('comment');
  //
  //         UserDto userDto = Get.find<AuthService>().getUser();
  //
  //         CommentDto commentDto = CommentDto(
  //             date: Timestamp.now(),
  //             content: content,
  //             uid: userDto.uid,
  //             noticeId: noticeId,
  //             reviewId: reviewId
  //         );
  //
  //         await commentRef.add(commentDto.toMap());
  //       }
  //   );
  //
  // Future<Result<List<Comment>>> getComments({
  //   required String noticeId,
  //   required String reviewId,
  //   required int index,
  //   Comment? startAfter,
  // }){
  //   return Result.handleFuture<List<Comment>>(
  //       action: () async {
  //         CollectionReference ref = _siteReviewCollection.doc(noticeId)
  //             .collection('review')
  //             .doc(reviewId)
  //             .collection('comment');
  //
  //         Query query = ref.orderBy('date' , descending: true);
  //
  //         if(startAfter != null){
  //           query = query.startAfter([startAfter.commentDto.date]);
  //         }
  //
  //         query = query.limit(index);
  //
  //         QuerySnapshot querySnapshot = await query.get();
  //
  //         return querySnapshot.docs.map((doc) =>
  //           Comment(
  //               id: doc.id,
  //               commentDto: CommentDto.fromMap(doc.data() as Map<String,dynamic>)
  //           )
  //         ).toList();
  //       }
  //   );
  //
  // }

}

enum UploadState{
  progress,
  fail,
  success,
}
