import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/ScapPage/Service/ScrapService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

import '../Model/NoticeScrap.dart';

class ScrapPageController extends GetxController{
  LoadingState loadingState = LoadingState.before;

  List<NoticeScrap> scarps = [];

  Future<void> getScraps({bool isReset = false}) async {
    loadingState = LoadingState.loading;
    update();

    if(isReset){
      scarps = [];
    }

    Result<List<NoticeScrap>> result = await ScrapService.instance.getScrapNotifications(
        count: 10,
        startAfter: scarps.isEmpty ? null : scarps.last
    );

    if(result.isSuccess){
      scarps.addAll(result.content!);
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    update();
  }

  //#. 공고 삭제
  //TODO 삭제 취소를 만들어야할지
  Future<void> deleteScrap(NoticeScrap noticeScrap) async{
    Result result = await ScrapService.instance.deleteNoticeScrap(noticeScrap.documentSnapshot.id);
    if(result.isSuccess){
      scarps.remove(noticeScrap);
      CustomSnackbar.show("알림", "공고 스크랩을 삭제했습니다.");
    }
    else{
      if(result.exception is ApplicationUnauthorizedException){
        CustomSnackbar.show("오류", "로그인이 되어있지 않습니다.");
      }
      else{
        CustomSnackbar.show("오류", "삭제에 실패했습니다.");
      }
    }
    update();
  }
}