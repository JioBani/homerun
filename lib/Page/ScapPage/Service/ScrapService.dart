import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrapDto.dart';
import 'package:homerun/Page/ScapPage/Model/Scrap.dart';
import 'package:homerun/Page/ScapPage/ScrapReferences.dart';
import 'package:homerun/Page/ScapPage/Value/NoticeScrapDtoFields.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

class ScrapService{
  Future<Result> scrapNotification(String noticeId){
    return Result.handleFuture(
      action: () async {
        UserDto userDto = Get.find<AuthService>().getUser();
        CollectionReference collection = ScrapReferences.getNoticeCollection(userDto.uid);
        await collection.doc(noticeId).set({
          'date' : FieldValue.serverTimestamp(),
          'id' : noticeId
        });
        return;
      }
    );
  }

  Future<Result<List<NoticeScrapDto>>> getScrapNotifications({
    required int? index,
    required NoticeScrap? startAfter,
  }){
    return Result.handleFuture<List<NoticeScrapDto>>(
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

        QuerySnapshot querySnapshot = await query.get();

        return querySnapshot.docs.map(
                (e) => NoticeScrapDto.fromMap(e.data() as Map<String , dynamic>)
        ).toList();
      }
    );
  }
}