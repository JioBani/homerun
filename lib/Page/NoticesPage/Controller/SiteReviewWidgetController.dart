import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewWidgetController extends GetxController{
  List<SiteReview>? reviews;
  LoadingState loadingState = LoadingState.before;
  final String noticeId;
  final int maxThumbnailCount = 3;
  final SiteReviewService siteReviewService = SiteReviewService();
  int thumbnailWidgetCount = 0;

  SiteReviewWidgetController({required this.noticeId});


  Future<void> loadThumbnailReviews() async {
    reviews = [];
    loadingState = LoadingState.loading;

    Result<List<SiteReview>> result = await siteReviewService.getSiteReviews(noticeId , index: maxThumbnailCount);

    if(result.isSuccess){
      reviews = result.result;
      thumbnailWidgetCount = reviews!.length < maxThumbnailCount ? reviews!.length : maxThumbnailCount + 1;
      loadingState = LoadingState.success;
      update();
    }
    else{
      reviews = [];
      thumbnailWidgetCount = 0;
      loadingState = LoadingState.fail;
      update();
    }
  }


}