import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/ApplyHome/SupplyMethod.dart';
import 'package:homerun/Common/Firebase/FirebaseFunctionsRequest.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Value/NoticeDtoFields.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/NoticeReferences.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

class NoticeService{

  static NoticeService? _instance;

  NoticeService._();

  static NoticeService get instance {
    _instance ??= NoticeService._();
    return _instance!;
  }

  void increaseViewCount(String noticeId){
    FirebaseFunctionsService.call(
      FirebaseFunctionEndpoints.increaseNoticeViewCount,
      {
        "noticeId" : noticeId,
      },
    );
  }

  Future<Result<bool>> like(String noticeId, bool like){
    return FirebaseFunctionsService.call<bool>(
      FirebaseFunctionEndpoints.likeNotice, //TODO 변경
      {
        'noticeId': noticeId,
        'like': like,
      },
      needAuth: true
    );
  }

  Future<Result<bool>> getLikeState(String noticeId){
    return Result.handleFuture<bool>(action: () async {
      String uid = Get.find<AuthService>().getUser().uid;
      DocumentSnapshot snapshot = await NoticeReferences.getLikeDocument(noticeId, uid).get();
      if(!snapshot.exists){
        return false;
      }
      else{
        return true;
      }
    });
  }

  Future<Result<List<Notice>>> getNotices({
    required int count,
    required OrderType orderType,
    Notice? startAfter,
    required SupplyMethod supplyMethod,
  }){
    return Result.handleFuture<List<Notice>>(
      action: () async {
        Query query = NoticeReferences.getNoticeCollection();

        query = query.where(NoticeDtoFields.supplyMethod , isEqualTo: supplyMethod.toEnumString());

        if(orderType == OrderType.likes){
          query = query.orderBy(NoticeDtoFields.likes, descending: true);
        }
        else if(orderType == OrderType.views){
          query = query.orderBy(NoticeDtoFields.likes, descending: true);
        }
        else if(orderType == OrderType.announcementDate){
          query = query.orderBy(NoticeDtoFields.recruitmentPublicAnnouncementDate, descending: true);
        }
        else if(orderType == OrderType.applicationDate){
          query = query.orderBy(NoticeDtoFields.subscriptionReceptionStartDate, descending: true);
        }

        if(startAfter != null){
          query = query.startAfterDocument(startAfter.documentSnapshot);
        }

        var querySnapshot = await query.limit(count).get();

        List<Notice> notices = querySnapshot.docs.map((doc) => Notice.fromDocumentSnapshot(doc)).toList();
        return notices;
      }
    );
  }

  Future<Result<Notice>> getNotice({
    required noticeId,
  }){
    return Result.handleFuture<Notice>(
        action: () async {
          return Notice.fromDocumentSnapshot(await NoticeReferences.getNoticeCollection().doc(noticeId).get());
        }
    );
  }
}

enum OrderType{
  none,
  applicationDate, //접수일자
  announcementDate, //공고일자
  views,
  likes,
}