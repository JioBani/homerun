import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/ScapPage/Service/ScrapService.dart';

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
        index: 1,
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
}