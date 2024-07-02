import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewListPageController extends GetxController{
  final String noticeId;
  List<SiteReview> siteReviews = [];
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  SiteReviewService siteReviewService = SiteReviewService();

  SiteReviewListPageController({required this.noticeId});


  @override
  onInit(){
    super.onInit();
    loadSiteReviews();
  }

  //TODO 리뷰가 수백개면 어캄?
  Future<void> loadSiteReviews()async {
    loadingState.value = LoadingState.loading;

    Result<List<SiteReview>> result = await siteReviewService.getSiteReviews(noticeId);
    if(result.isSuccess){
      siteReviews = result.result!;
      loadingState.value = LoadingState.success;
    }
    else{
      StaticLogger.logger.e('[SiteReviewListPageController.loadSiteReviews()] ${result.exception}\n${result.stackTrace}');
      loadingState.value = LoadingState.fail;
    }
  }
}