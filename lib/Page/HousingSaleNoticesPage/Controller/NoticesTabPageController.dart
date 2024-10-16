import 'package:get/get.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Feature/Notice/NoticeService.dart';

class NoticesTabPageController extends GetxController{

  final SupplyMethod supplyMethod;
  List<Notice> noticeList = [];

  LoadingState loadingState = LoadingState.before;

  NoticesTabPageController({required this.supplyMethod});

  //#. 초기 5개만 미리 보여줌
  Future<void> loadNotice() async {
    noticeList = [];
    
    loadingState = LoadingState.loading;
    update();

    Result<List<Notice>> result = await NoticeService.instance.getNotices(
      count: 5,
      orderType: OrderType.announcementDate,
      startAfter: noticeList.isNotEmpty ? noticeList.last : null,
      supplyMethod : supplyMethod,
    );

    if(result.isSuccess){
      noticeList.addAll(result.content!);
      loadingState = LoadingState.success;
      update();
    }
    else{
      StaticLogger.logger.e(result.exception);

      loadingState = LoadingState.fail;
      update();
    }
  }
}