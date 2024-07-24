import 'package:get/get.dart';
import 'package:homerun/Common/Loadable/Loadable.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

class SiteReviewPageController extends GetxController{
  final SiteReview siteReview;
  late final Loadable<bool> loadableLike;

  final String loadMethod = "load";
  final String likeMethod = "like";
  final String unlikeMethod = "unlike";

  SiteReviewPageController({required this.siteReview}){
    loadableLike = Loadable<bool>(controller: this , loadingActions: {
      loadMethod : _loadLike,
      likeMethod : _like,
      unlikeMethod : _unlike,
    });
  }

  @override
  onInit(){
    loadableLike.load(loadMethod);
    super.onInit();
  }

  Future<void> _loadLike(Loadable<bool> loadable)async{
    loadable.update(LoadingState.loading);

    Result<bool> result = await SiteReviewService.instance.isLiked(siteReview);

    if(result.isSuccess){
      loadable.setValue(result.content!);
      loadable.update(LoadingState.success);
    }
    else{
      StaticLogger.logger.e(result.exception);
      loadable.update(LoadingState.fail);
    }
  }

  Future<void> _like(Loadable<bool> loadable) async {
    loadable.update(LoadingState.loading);

    await Future.delayed(Duration(seconds: 3));

    Result result = await SiteReviewService.instance.like(siteReview);

    if(result.isSuccess){
      loadable.setValue(true);
      loadable.update(LoadingState.success);
    }
    else{
      StaticLogger.logger.e(result.exception);
      loadable.update(LoadingState.fail);
      CustomSnackbar.show("오류", "좋아요에 실패했습니다.");
    }
  }

  Future<void> like()async{
    loadableLike.load(likeMethod);
  }

  Future<void> _unlike(Loadable<bool> loadable) async {
    loadable.update(LoadingState.loading);

    await Future.delayed(Duration(seconds: 3));

    Result result = await SiteReviewService.instance.unlike(siteReview);

    if(result.isSuccess){
      loadable.setValue(false);
      loadable.update(LoadingState.success);
    }
    else{
      StaticLogger.logger.e(result.exception);
      loadable.update(LoadingState.fail);
      CustomSnackbar.show("오류", "좋아요에 실패했습니다.");
    }
  }

  Future<void> unlike()async{
    loadableLike.load(unlikeMethod);
  }

}