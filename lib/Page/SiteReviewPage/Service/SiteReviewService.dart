import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/UploadResult.dart';
import 'package:homerun/Page/SiteReviewPage/SiteReviewReferences.dart';
import 'package:homerun/Page/SiteReviewPage/Value/SiteReviewFields.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/ApiResponse.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


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

    Result<DocumentReference> makeResult = await _makeDocument(
      noticeId: siteReviewWriteDto.noticeId,
      title: siteReviewWriteDto.title,
      content: siteReviewWriteDto.content
    );

    if(!makeResult.isSuccess){
      if(onProgress != null){
        onProgress(UploadState.fail,'문서 만들기 실패', makeResult.exception);
      }
      return UploadResultInfo.fromFailure(
          state: UploadResult.createDocFailure,
          exception: makeResult.exception!,
          stackTrace: makeResult.stackTrace!
      );
    }

    if(onProgress != null){
      onProgress(UploadState.progress,'문서 만들기 성공',null);
    }

    documentReference = makeResult.content!;


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
        images,siteReviewWriteDto.noticeId,documentReference.id,userDto.uid,null
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

  Future<Result<DocumentReference>> _makeDocument({
    required String noticeId,
    required String title,
    required String content,
  }) async {
    return Result.handleFuture(action: () async {
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(idToken == null){
        throw ApplicationUnauthorizedException();
      }

      final response = await http.post(
        Uri.parse(FirebaseFunctionEndpoints.makeSiteReviewDocument),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          SiteReviewFields.noticeId: noticeId,
          SiteReviewFields.title: title,
          SiteReviewFields.content: content,
        }),
      );

      ApiResponse<String> apiResponse = ApiResponse<String>.fromMap(jsonDecode(response.body));

      if(apiResponse.status == 200 || apiResponse.status == 300){
        return FirebaseFirestore.instance.doc(apiResponse.data!);
      }
      else{
        StaticLogger.logger.e(apiResponse.error?.message);
        throw apiResponse.error!;
      }
    });
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
      String uid,
      void Function(TaskSnapshot)? snapshotEventAction
      ) async {
    List<Map<XFile, Result<void>>> mapList = await Future.wait(images.map((imageFile) async {
      try {
        String fileName = imageFile.name;
        Reference storageRef = FirebaseStorage.instance.ref().child('site_review/$noticeId/$docId/$fileName');
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));

        uploadTask.snapshotEvents.listen(snapshotEventAction);

        await uploadTask.whenComplete(() {});

        final newCustomMetadata = SettableMetadata(
          customMetadata: {
            'owner' : uid
          },
        );

        //await storageRef.updateMetadata(newCustomMetadata);

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


  Future<Result<void>> delete(SiteReview siteReview){
    return Result.handleFuture(action: () async {
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(idToken == null){
        throw ApplicationUnauthorizedException();
      }

      final response = await http.post(
        Uri.parse(FirebaseFunctionEndpoints.deleteSiteReview),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          "path" : SiteReviewReferences.getReviewCollection(siteReview.noticeId).doc(siteReview.id).path
        }),
      );

      ApiResponse<String> apiResponse = ApiResponse<String>.fromMap(jsonDecode(response.body));

      if(apiResponse.status == 200 || apiResponse.status == 300){
        return;
      }
      else{
        StaticLogger.logger.e(apiResponse.error?.message);
        throw apiResponse.error!;
      }
    });
  }
}

enum UploadState{
  progress,
  fail,
  success,
}
