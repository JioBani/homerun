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
import 'package:homerun/Page/SiteReviewPage/Service/UpdateResultInfo.dart';
import 'package:homerun/Page/SiteReviewPage/Service/UploadResult.dart';
import 'package:homerun/Page/SiteReviewPage/SiteReviewReferences.dart';
import 'package:homerun/Page/SiteReviewPage/Value/Values.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Common/ApiResponse/ApiResponse.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Value/SiteReviewFields.dart';


class SiteReviewService{

  final List<String> viewList = [];

  static SiteReviewService? _instance;

  SiteReviewService._();

  static SiteReviewService get instance {
    _instance ??= SiteReviewService._();
    return _instance!;
  }

  //region #. CRUD
  
  //#. 리뷰 가져오기
  Future<Result<List<SiteReview>>> getSiteReviews({
    required String noticeId,
    required int count,
    SiteReview? startAfter
  }) {
    return Result.handleFuture<List<SiteReview>>(
      action: () async {
        QuerySnapshot querySnapshot;
        Query query = SiteReviewReferences.getReviewCollection(noticeId);

        query = query.orderBy(SiteReviewFields.date , descending:true);

        if(startAfter != null){
          query = query.startAfter([startAfter.date]);
        }

        querySnapshot = await query.limit(count).get();

        List<SiteReview> reviews = querySnapshot.docs.map(
                (review) => SiteReview.fromMap(review.data() as Map<String,dynamic> , review.id)
        ).toList();

        return reviews;
      }
    );
  }
  

  //#.리뷰 업로드
  Future<UploadResultInfo> upload(
      SiteReviewWriteDto siteReviewWriteDto,
      List<XFile> images,
      String thumbnailImageName,
      void Function(String)? onProgress
      ) async{

    if(onProgress != null){
      onProgress('문서 만드는 중');
    }

    //#1. 유저 정보 가져오기
    try{
      Get.find<AuthService>().getUser();
    }catch(e , s){
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
      content: siteReviewWriteDto.content,
      thumbnailImageName: thumbnailImageName
    );

    if(!makeResult.isSuccess){
      return UploadResultInfo.fromFailure(
          state: UploadResult.createDocFailure,
          exception: makeResult.exception!,
          stackTrace: makeResult.stackTrace!
      );
    }

    documentReference = makeResult.content!;


    //#4. 이미지 업로드
    if(onProgress != null){
      onProgress('이미지 업로드 중');
    }

    Map<XFile , Result<void>> result = await _uploadImage(
        images: images,
        noticeId: siteReviewWriteDto.noticeId,
        docId: documentReference.id,
        snapshotEventAction: null
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
  

  //#. 리뷰 업데이트
  Future<UpdateResultInfo> update({
    required SiteReview targetReview,
    required String title,
    required String content,
    required String thumbnailImageName,
    required List<XFile> uploadImages,
    required List<String> deleteImageNames,
    void Function(String)? onProgress
  }) async {

    if(onProgress != null) {
      onProgress('문서 수정 중');
    }

    //#1. 로그인 확인
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if(idToken == null){
      return UpdateResultInfo.fromFailure(
          state: UpdateResult.authFailure,
          exception: ApplicationUnauthorizedException(),
          stackTrace: StackTrace.current
      );
    }

    //#2. 문서 업데이트
    Result updateDocResult = await _updateDocument(
        noticeId: targetReview.noticeId,
        reviewId: targetReview.id,
        title: title,
        content: content,
        thumbnailImageName: thumbnailImageName
    );

    if(!updateDocResult.isSuccess){
      return UpdateResultInfo.fromFailure(
          state: UpdateResult.docUpdateFailure,
          exception: updateDocResult.exception!,
          stackTrace: updateDocResult.stackTrace!
      );
    }

    if(onProgress != null) {
      onProgress('이미지 수정 중');
    }

    //#3. 이미지 수정
    List<Map<dynamic ,Result<void>>> imageResult = await Future.wait<Map<dynamic ,Result<void>>>([
      _deleteImage(
          imagesNames: deleteImageNames,
          noticeId: targetReview.noticeId,
          docId: targetReview.id,
          snapshotEventAction: null
      ),
      _uploadImage(
          images: uploadImages,
          noticeId: targetReview.noticeId,
          docId: targetReview.id,
          snapshotEventAction: null
      )
    ]);

    List<String> uploadFailImages = [];
    List<String> deleteFailImages = [];

    imageResult[0].forEach((key, value) {
      if(!value.isSuccess){
        uploadFailImages.add(key.name);
      }
    });

    imageResult[1].forEach((key, value) {
      if(!value.isSuccess){
        deleteFailImages.add(key.name);
      }
    });

    if(onProgress != null) {
      onProgress('문서 불러오는 중');
    }
    //#4. 문서 다시 가져오기
    Result<SiteReview> updateReview = await _getSiteReview(targetReview.noticeId , targetReview.id);

    if(updateReview.isSuccess){  //#. 문서를 가져온 경우
      //#. 이미지 업데이트에 실패한 경우
      if(uploadFailImages.isNotEmpty || deleteFailImages.isNotEmpty){
        return UpdateResultInfo(
          siteReview: updateReview.content,
          updateResult: UpdateResult.imageUpdateFailure,
          uploadFailImages: uploadFailImages,
          deleteFailImages: deleteFailImages,
        );
      }
      else{
        return UpdateResultInfo.fromSuccess(updateReview.content!);
      }
    }
    else{ //#. 문서를 가져오지 못한 경우
      //#. 이미지 업데이트에 실패했다면 실패 코드는 이미지 업데이트 실패로 덮어 씌워짐
      if(uploadFailImages.isNotEmpty || deleteFailImages.isNotEmpty){
        return UpdateResultInfo(
          siteReview: null,
          updateResult: UpdateResult.imageUpdateFailure,
          uploadFailImages: uploadFailImages,
          deleteFailImages: deleteFailImages,
        );
      }
      else{
        return UpdateResultInfo.fromFailure(
            state: UpdateResult.getUploadedDocFailure,
            exception: updateReview.exception!,
            stackTrace: updateReview.stackTrace!
        );
      }
    }
  }
  

  //#. 리뷰 삭제
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
  
  //#endregion
  
  
  //#region #. 문서 작업

  //#. 문서 가져오기
  Future<Result<SiteReview>> _getSiteReview(String noticeId, String reviewId){
    return Result.handleFuture<SiteReview>(action: () async =>
        SiteReview.fromDocumentSnapshot(
            await SiteReviewReferences.getReviewDocument(noticeId, reviewId).get()
        )
    );
  }

  //#. 문서 만들기
  Future<Result<DocumentReference>> _makeDocument({
    required String noticeId,
    required String title,
    required String content,
    required String thumbnailImageName,
  }) async {
    return Result.handleFuture(timeout : const Duration(seconds: 30) , action: () async {
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
          SiteReviewFields.noticeId :  noticeId,
          SiteReviewFields.title: title,
          SiteReviewFields.content: content,
          "thumbnailImageName" : thumbnailImageName
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


  //#. 문서 업데이트
  Future<Result> _updateDocument({
    required String noticeId,
    required String reviewId,
    required String title,
    required String content,
    required String thumbnailImageName,
  })async {
    return Result.handleFuture(timeout: const Duration(minutes: 1), action: () async {
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(idToken == null){
        throw ApplicationUnauthorizedException();
      }

      final response = await http.post(
        Uri.parse(FirebaseFunctionEndpoints.updateSiteReview),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          SiteReviewFields.noticeId: noticeId,
          SiteReviewFields.title: title,
          SiteReviewFields.content: content,
          "reviewId" : reviewId,
          "thumbnailImageName" : thumbnailImageName
        }),
      );

      StaticLogger.logger.i(response.body);

      ApiResponse apiResponse = ApiResponse.fromMap(jsonDecode(response.body));

      if(apiResponse.status == 200 || apiResponse.status == 300){
        return;
      }
      else{
        StaticLogger.logger.e(apiResponse.error?.message);
        throw apiResponse.error!;
      }
    });
  }
  //#endregion


  //#region #. 이미지 작업
  
  //#. 이미지 업로드
  Future<Map<XFile , Result<void>>> _uploadImage({
    required List<XFile> images,
    required String noticeId,
    required String docId,
    required void Function(TaskSnapshot)? snapshotEventAction
  }) async {
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

  //#. 이미지 삭제
  Future<Map<String , Result<void>>> _deleteImage({
    required List<String> imagesNames,
    required String noticeId,
    required String docId,
    required void Function(TaskSnapshot)? snapshotEventAction
  }) async {

    List<Map<String, Result<void>>> mapList = await Future.wait(imagesNames.map((name) async {
      try {
        Reference storageRef = SiteReviewReferences.getReviewImageRef(noticeId, docId, name);
        await storageRef.delete();
        return {name: Result<void>.fromSuccess()};
      }
      catch (e, s) {
        StaticLogger.logger.e("[SiteReviewService._deleteImage()] $e\n$s");
        return {name: Result<void>.fromFailure(e, s)};
      }
    }));

    Map<String, Result<void>> resultMap = {};

    for (var map in mapList) {
      resultMap.addAll(map);
    }
    return resultMap;
  }

  //#endregion



  //#region #. 기타
  
  //#. 조회수 증가
  Future<void> increaseViewCount(SiteReview siteReview) async{
    if(viewList.contains(siteReview.id)){
      return;
    }

    final res = await http.post(
      Uri.parse(FirebaseFunctionEndpoints.increaseSiteReviewViewCount),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "noticeId" : siteReview.noticeId,
        "siteReviewId" : siteReview.id,
      }),
    ).timeout(const Duration(seconds: 10));

    if(res.statusCode == 200 || res.statusCode == 300){
      viewList.add(siteReview.id);
    }
  }
  
  //#. 좋아요 확인
  Future<Result<bool>> isLiked(SiteReview siteReview){
    return Result.handleFuture<bool>(action: ()async{
      UserDto userDto = Get.find<AuthService>().getUser();

      DocumentSnapshot snapshot = await SiteReviewReferences.getReviewLikeDocument(
          siteReview.noticeId,
          siteReview.id,
          userDto.uid
      ).get();

      if(snapshot.exists){
        return true;
      }
      else{
        return false;
      }
    });
  }

  Future<Result> like(SiteReview siteReview) async {
    return Result.handleFuture(action: ()async{
      UserDto userDto = Get.find<AuthService>().getUser();
      DocumentReference likeDoc = SiteReviewReferences.getReviewLikeDocument(
        siteReview.noticeId,
        siteReview.id,
        userDto.uid,
      );

      await likeDoc.set({Values.likeAt: FieldValue.serverTimestamp()});
    });
  }

  Future<Result> unlike(SiteReview siteReview) async {
    return Result.handleFuture(action: ()async{
      UserDto userDto = Get.find<AuthService>().getUser();
      DocumentReference likeDoc = SiteReviewReferences.getReviewLikeDocument(
        siteReview.noticeId,
        siteReview.id,
        userDto.uid,
      );

      await likeDoc.delete();
    });
  }

  Future<Result<int>> getLikeCount(SiteReview siteReview){
    return Result.handleFuture<int>(action: ()async{
      AggregateQuerySnapshot snapshot = await SiteReviewReferences.getReviewLikeCollection(
          siteReview.noticeId,
          siteReview.id
      ).count().get();

      return snapshot.count ?? 0;
    });
  }

  //#endregion
}
