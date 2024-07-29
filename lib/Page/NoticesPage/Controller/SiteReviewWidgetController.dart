import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewWidgetController extends GetxController{
  List<SiteReview>? reviews;
  LoadingState loadingState = LoadingState.before;
  final String noticeId;
  final int maxThumbnailCount = 3;
  int thumbnailWidgetCount = 0;

  SiteReviewWidgetController({required this.noticeId});


  Future<void> loadThumbnailReviews() async {
    reviews = [];
    loadingState = LoadingState.loading;

    Result<List<SiteReview>> result = await SiteReviewService.instance.getSiteReviews(
        noticeId: noticeId ,
        count: maxThumbnailCount
    );

    if(result.isSuccess){
      reviews = result.content;
      thumbnailWidgetCount = reviews!.length + 1;
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

  //#. 리뷰 추가
  // 사용자가 리뷰를 작성했을때 호출
  void addReview(SiteReview siteReview){
    if((loadingState == LoadingState.success || loadingState == LoadingState.noMoreData) &&
        reviews != null
    ){
      reviews!.add(siteReview);
      thumbnailWidgetCount = reviews!.length + 1;
      update();
    }
  }
  
  //#. 리뷰 삭제
  // 사용자가 리뷰를 삭제했을때 호출
  void removeReview(SiteReview siteReview){
    if((loadingState == LoadingState.success || loadingState == LoadingState.noMoreData) &&
        reviews != null
    ){
      int index = reviews!.indexWhere((review) => review.id == siteReview.id);
      if (index != -1) {
        reviews!.removeAt(index);
      }

      thumbnailWidgetCount = reviews!.length + 1;
      update();
    }
  }

  //#. 리뷰 수정
  // 사용자가 리뷰를 수정했을때 호출
  void updateReview(SiteReview siteReview){
    if((loadingState == LoadingState.success || loadingState == LoadingState.noMoreData) &&
        reviews != null
    ){
      int index = reviews!.indexWhere((review) => review.id == siteReview.id);
      if (index != -1) {
        reviews![index] = siteReview;
      }

      thumbnailWidgetCount = reviews!.length + 1;
      update();
    }
  }

}