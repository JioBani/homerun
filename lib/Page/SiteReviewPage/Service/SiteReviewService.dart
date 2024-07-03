import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';

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

  ///글 업로드
  Future<void> write(
      SiteReviewWriteDto siteReviewWriteDto,
      List<XFile> images,
      void Function(UploadState, String, Object?)? onProgress
    ) async{

    //#1. 유저 정보 가져오기
    UserDto userDto;

    try{
      userDto = Get.find<AuthService>().getUser();
    }catch(e){
      if(onProgress != null){
        onProgress(UploadState.fail,'로그인이 되어 있지 않습니다.',null);
      }
      return;
    }


    //#2. 리뷰 문서 만들기
    DocumentReference documentReference;

    try{
      documentReference = await _createDocument(siteReviewWriteDto.noticeId,userDto.uid);

      if(onProgress != null){
        onProgress(UploadState.progress,'문서 만들기 성공',null);
      }
    }catch(e){
      if(onProgress != null){
        onProgress(UploadState.fail,'문서 만들기 실패',e);
      }
      return;
    }

    //#3. 리뷰 문서에 정보 저장하기
    try{
      await _updateDocument(siteReviewWriteDto , documentReference , userDto.uid);

      if(onProgress != null){
        onProgress(UploadState.progress,'문서 저장 성공',null);
      }

    }catch(e1){
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
      return;
    }


    //#4. 이미지 업로드
    Map<XFile , Result<void>> result = await _uploadImage(
      images,siteReviewWriteDto.noticeId,documentReference.id,null
    );

    if(onProgress != null){
      int success = 0;
      Object? e;
      result.forEach((key, value) {
        if(value.isSuccess) {
          success++;
        }
        else{
          e = value.exception;
        }
      });

      onProgress(success == result.length ? UploadState.success : UploadState.fail,
          '업로드 : $success/${result.length}',
          e
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
}

enum UploadState{
  progress,
  fail,
  success,
}