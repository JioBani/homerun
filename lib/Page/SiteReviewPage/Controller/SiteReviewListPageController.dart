import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewListPageController extends GetxController{
  static const initReviewNumber = 10;
  static const loadReviewNumber = 10;


  final String noticeId;
  List<SiteReview> siteReviews = [];
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  SiteReviewListPageController({required this.noticeId});


  @override
  onInit(){
    super.onInit();
    loadSiteReviews();
  }

  //TODO 리뷰가 수백개면 어캄?
  Future<void> loadSiteReviews()async {
    int count = siteReviews.isEmpty ? initReviewNumber : loadReviewNumber;

    update();
    loadingState.value = LoadingState.loading;

    Result<List<SiteReview>> result = await SiteReviewService.instance.getSiteReviews(
      noticeId: noticeId,
      count: count,
      startAfter: siteReviews.isNotEmpty ? siteReviews.last : null
    );

    if(result.isSuccess){
      siteReviews.addAll(result.content!);
      loadingState.value = LoadingState.success;
      if(result.content!.length < count){
        loadingState.value = LoadingState.noMoreData;
      }
    }
    else{
      StaticLogger.logger.e('[SiteReviewListPageController.loadSiteReviews()] ${result.exception}\n${result.stackTrace}');
      loadingState.value = LoadingState.fail;
    }
    update();
  }

  void addReview(SiteReview review){
    siteReviews.insert(0, review);
    update();
  }

  void removeReview(SiteReview review){
    siteReviews.remove(review);
    update();
  }

  void updateReview(SiteReview review){
    for(var r in siteReviews){
      if(r.id == review.id){
        r.replace(review);
      }
    }
    update();
  }
}