import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewWidgetController extends GetxController{
  List<SiteReview>? reviews;
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  final String noticeId;
  final int maxThumbnailCount = 3;
  final SiteReviewService siteReviewService = SiteReviewService();

  SiteReviewWidgetController({required this.noticeId});


  Future<void> loadThumbnailReviews() async {
    reviews = [];
    loadingState.value = LoadingState.loading;

    Result<List<SiteReview>> result = await siteReviewService.getSiteReviews(noticeId , index: 5);

    if(result.isSuccess){
      reviews = result.result;
      loadingState.value = LoadingState.success;
    }
    else{
      reviews = [];
      loadingState.value = LoadingState.fail;
    }
  }


}