import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';

class SiteReviewListPageController extends GetxController{
  final String noticeId;
  List<SiteReview> siteReviews = [];
  Rx<LoadingState> loadingState = Rx(LoadingState.before);

  SiteReviewListPageController({required this.noticeId});

  //TODO 리뷰가 수백개면 어캄?
  Future<void> loadSiteReviews()async {
    loadingState.value = LoadingState.loading;
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('site_reivew').doc(noticeId).collection('review').get();
      siteReviews = querySnapshot.docs.map((review) =>
          SiteReview.fromMap(review.data() as Map<String , dynamic> , review.id)
      ).toList();
      loadingState.value = LoadingState.success;
    }catch(e , s){
      StaticLogger.logger.e('[SiteReviewListPageController.loadSiteReviews()] $e\n$s');
      loadingState.value = LoadingState.fail;
    }
  }
}