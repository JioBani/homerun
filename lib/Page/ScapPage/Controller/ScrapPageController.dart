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

  Future<void> getScraps(int count,{bool isReset = false}) async {
    loadingState = LoadingState.loading;
    update();

    if(isReset){
      scarps = [];
    }

    Result<List<NoticeScrap>> result = await ScrapService.instance.getScrapNotifications(
        count: count,
        startAfter: scarps.isEmpty ? null : scarps.last
    );

    if(result.isSuccess){
      if(result.content!.length < count){
        loadingState = LoadingState.noMoreData;
      }
      else{
        loadingState = LoadingState.success;
      }
      scarps.addAll(result.content!);
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

  //#. 스크랩 전체 삭제
  Future<void> deleteAllScrap() async {
    //#. 스크랩이 비어있을 경우
    if(scarps.isEmpty){
      CustomSnackbar.show("오류", "삭제할 스크랩이 없습니다.");
      return;
    }
    
    //#. 스크랩 삭제
    Result result = await ScrapService.instance.deleteAllNoticeScrap();
    
    //#. 결과 출력
    if(result.isSuccess){
      scarps = [];
      update();
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
  }
}