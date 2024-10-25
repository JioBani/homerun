import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Common/Firebase/FirebaseFunctionsRequest.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Feature/Notice/Value/NoticeDtoFields.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Page/NoticeSearchPage/View/SearchSettingPage.dart';
import 'package:homerun/Page/NoticesPage/NoticeReferences.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';

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

  ///검색할 인덱스
  /// 지역, 주택 종류, 공급 유형
  Future<Result<List<Notice>>> getNotices({
    required int count,
    required OrderType orderType,
    Notice? startAfter,
    required SupplyMethod supplyMethod,
    bool descending = true,
    DateTime? applicationDateUpcoming,
    List<Region>? regions,
  }){
    return Result.handleFuture<List<Notice>>(
      action: () async {
        Query query = NoticeReferences.getNoticeCollection();

        query = query.where(NoticeDtoFields.supplyMethod , isEqualTo: supplyMethod.toEnumString());

        if(orderType == OrderType.likes){
          query = query.orderBy(NoticeDtoFields.likes, descending: descending);
        }
        else if(orderType == OrderType.views){
          query = query.orderBy(NoticeDtoFields.views, descending: descending);
        }
        else if(orderType == OrderType.announcementDate){
          query = query.orderBy(NoticeDtoFields.recruitmentPublicAnnouncementDate, descending: descending);
        }
        else if(orderType == OrderType.applicationDate){
          query = query.orderBy(NoticeDtoFields.subscriptionReceptionStartDate, descending: descending);
          if(applicationDateUpcoming != null){
            query = query.where(
              NoticeDtoFields.subscriptionReceptionStartDate,
              isGreaterThanOrEqualTo : Timestamp.fromDate(applicationDateUpcoming)
            );
          }
        }
        
        //최대 10개까지만 가능하므로
        if(regions != null){
          query = query.where(
            "region",
            whereIn: (regions.length > 10 ? regions.sublist(0,9) : regions).map((e)=>e.koreanString).toList()
          );
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