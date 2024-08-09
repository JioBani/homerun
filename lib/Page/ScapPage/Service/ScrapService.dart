import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/Service/NoticeService.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrapDto.dart';
import 'package:homerun/Page/ScapPage/ScrapReferences.dart';
import 'package:homerun/Page/ScapPage/Value/NoticeScrapDtoFields.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:http/http.dart' as http;

import '../Model/NoticeScrap.dart';

class ScrapService{

  static ScrapService? _instance;

  ScrapService._();

  static ScrapService get instance {
    _instance ??= ScrapService._();
    return _instance!;
  }

  //#. 공고 스크랩
  Future<Result<void>> scrapNotification(String noticeId){
    return Result.handleFuture<void>(
      action: () async {
        UserDto userDto = Get.find<AuthService>().getUser();
        CollectionReference collection = ScrapReferences.getNoticeCollection(userDto.uid);
        await collection.doc(noticeId).set({
          NoticeScrapDtoFields.date : FieldValue.serverTimestamp(),
          NoticeScrapDtoFields.noticeId : noticeId
        });
        
        //#. 스크랩 카운트 증가 
        ScrapService.instance.updateScrapCount(noticeId, true);
      }
    );
  }

  //#. 공고 스크랩 리스트 가져오기
  Future<Result<List<NoticeScrap>>> getScrapNotifications({
    required int? count,
    required NoticeScrap? startAfter,
  }){
    return Result.handleFuture<List<NoticeScrap>>(
      action: () async {
        //#. 유저 정보 가져오기
        UserDto userDto = Get.find<AuthService>().getUser(); //#. 유저가 로그인되어있지 않을 시 예외 발생

        //#. 공고 스크랩 컬렉션 가져오기
        CollectionReference collection = ScrapReferences.getNoticeCollection(userDto.uid);

        //#. 쿼리 생성
        Query query = collection.orderBy(NoticeScrapDtoFields.date);

        //#. startAfter 쿼리 생성
        if(startAfter != null){
          query = query.startAfterDocument(startAfter.documentSnapshot);
        }

        if(count != null){
          query = query.limit(count);
        }

        QuerySnapshot querySnapshot = await query.get();

        return Future.wait(querySnapshot.docs.map((doc) async {
          NoticeScrapDto noticeScrapDto = NoticeScrapDto.fromDocumentSnapshot(doc);
          Notice? notice = await _getNotice(noticeScrapDto.noticeId);
          return NoticeScrap(documentSnapshot: doc, noticeScrapDto:noticeScrapDto , notice: notice);
        }));
      }
    );
  }

  //#. 공고 삭제하기
  Future<Result<void>> deleteNoticeScrap(String noticeId){
    return Result.handleFuture<void>(
      action: () async {
        UserDto userDto = Get.find<AuthService>().getUser();
        await ScrapReferences.getNoticeCollection(userDto.uid).doc(noticeId).delete();
        
        //#. 스크랩 카운트 감소
        ScrapService.instance.updateScrapCount(noticeId, false);
      },
    );
  }

  //#. 공고 가져오기
  Future<Notice?> _getNotice(String noticeId) async {
    return (await NoticeService.instance.getNotice(noticeId: noticeId)).content;
  }

  //#. 스크랩 카운트 추가하기
  Future<void> updateScrapCount(String noticeId,bool up) async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if(idToken == null){
      throw ApplicationUnauthorizedException();
    }

    await http.post(
      Uri.parse(FirebaseFunctionEndpoints.updateNoticeScrapCount),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        "noticeId" :  noticeId,
        "up" : up
      }),
    );
  }

  //#. 스크랩 유무 가져오기

  Future<Result<bool>> isNoticeScraped(String noticeId)async{
    return Result.handleFuture<bool>(
      action: ()async{
        //#. 유저 정보 가져오기
        UserDto? userDto = Get.find<AuthService>().tryGetUser();
        if(userDto == null){
          return false;
        }

        //#. 공고 스크랩 컬렉션 가져오기
        CollectionReference collection = ScrapReferences.getNoticeCollection(userDto.uid);
        DocumentSnapshot documentSnapshot = await collection.doc(noticeId).get();
        return documentSnapshot.exists;
      }
    );
  }
}