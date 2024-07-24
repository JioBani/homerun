import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:homerun/Common/Loadable/Loadable.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

class SiteReviewPageController extends GetxController{
  final SiteReview siteReview;
  late final Loadable<bool> loadableLike;

  final String loadMethod = "load";
  final String likeMethod = "like";
  final String unlikeMethod = "unlike";

  RxInt likes = RxInt(0);

  SiteReviewPageController({required this.siteReview}){
    loadableLike = Loadable<bool>(controller: this , loadingActions: {
      loadMethod : _loadLike,
      likeMethod : _like,
      unlikeMethod : _unlike,
    });
  }

  @override
  onInit(){
    if(FirebaseAuth.instance.currentUser != null){
      loadableLike.load(loadMethod);
    }
    getLikes();
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

    Result result = await SiteReviewService.instance.like(siteReview);

    if(result.isSuccess){
      loadable.setValue(true);
      likes++;
      loadable.update(LoadingState.success);
    }
    else{
      StaticLogger.logger.e(result.exception);
      loadable.update(LoadingState.fail);

      if(result.exception is ApplicationUnauthorizedException){
        CustomSnackbar.show("오류", "로그인이 필요합니다.");
      }
      else{
        CustomSnackbar.show("오류", "좋아요에 실패했습니다.");
      }
    }
  }

  Future<void> like()async{
    loadableLike.load(likeMethod);
  }

  Future<void> _unlike(Loadable<bool> loadable) async {
    loadable.update(LoadingState.loading);

    Result result = await SiteReviewService.instance.unlike(siteReview);

    if(result.isSuccess){
      loadable.setValue(false);
      likes--;
      loadable.update(LoadingState.success);
    }
    else{
      StaticLogger.logger.e(result.exception);
      loadable.update(LoadingState.fail);

      if(result.exception is ApplicationUnauthorizedException){
        CustomSnackbar.show("오류", "로그인이 필요합니다.");
      }
      else{
        CustomSnackbar.show("오류", "좋아요 취소에 실패했습니다.");
      }
    }
  }

  Future<void> unlike()async{
    loadableLike.load(unlikeMethod);
  }

  Future<void> getLikes() async {
    Result result = await SiteReviewService.instance.getLikeCount(siteReview);
    if(result.isSuccess){
      likes.value = result.content!;
    }
    else{
      StaticLogger.logger.e(result.exception);
    }
  }

}