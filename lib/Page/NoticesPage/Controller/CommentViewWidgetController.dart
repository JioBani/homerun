import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:homerun/Common/Firebase/FirestorePagination.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';

class CommentViewWidgetController extends GetxController{
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  RxList<Comment> comments = RxList([]);
  final String noticeId;

  CommentViewWidgetController({required this.noticeId});

  Future<void> loadComments() async {
    loadingState.value = LoadingState.loading;

    FirebaseResponse<QuerySnapshot> response = await FirebaseResponse.handleRequest<QuerySnapshot>(
        action: () => FirebaseFirestore.instance.collection('notice_comment').doc(noticeId).collection('free').orderBy('date' , descending: true).get()
    );

    if(response.isSuccess){
      comments.assignAll(response.response!.docs.map((e) =>  Comment.fromMap(e.data() as Map<String , dynamic>)));
      StaticLogger.logger.i('[CommentViewWidgetController.loadComments()] 댓글 가져오기 성공 :${response.exception}');
      loadingState.value = LoadingState.success;
    }
    else{
      StaticLogger.logger.e('[CommentViewWidgetController.loadComments()] 댓글 가져오기 실패 :${response.exception}');
      loadingState.value = LoadingState.fail;
    }
  }

}