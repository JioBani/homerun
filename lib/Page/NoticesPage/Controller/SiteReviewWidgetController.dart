import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';

class SiteReviewWidgetController extends GetxController{
  List<SiteReview>? reviews;
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  final String noticeId;
  final int maxThumbnailCount = 3;

  SiteReviewWidgetController({required this.noticeId});


  Future<void> loadReviews() async {
    reviews = [];
    loadingState.value = LoadingState.loading;
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('site_review')
          .doc('test')
          .collection('review')
          .limit(5)
          .get();
      reviews = querySnapshot.docs.map((doc) => SiteReview.fromMap(doc.data() as Map<String, dynamic>)).toList();
      loadingState.value = LoadingState.success;
    }catch(e ,s){
      StaticLogger.logger.e("[SiteReviewWidgetController.loadReviews()] $e\n$s");
      reviews = [];
      loadingState.value = LoadingState.fail;
    }
  }
}