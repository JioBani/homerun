import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';

class SiteReviewService{

  final CollectionReference _siteReviewCollection = FirebaseFirestore.instance.collection('site_review');
  
  Future<Result<List<SiteReview>>> getSiteReviews(String noticeId, {int? index}) {
    return Result.handleFuture<List<SiteReview>>(
        action: () async {
          QuerySnapshot querySnapshot;

          if(index != null){
            querySnapshot = await _siteReviewCollection.doc(noticeId).collection('review').limit(index).get();
          }
          else{
            querySnapshot = await _siteReviewCollection.doc(noticeId).collection('review').get();
          }

          List<SiteReview> reviews = querySnapshot.docs.map(
                  (review) => SiteReview.fromMap(review.data() as Map<String,dynamic> , review.id)
          ).toList();

          return reviews;
        }
    );
  }
  
}