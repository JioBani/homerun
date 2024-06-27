import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';

class ReplyCommentWidgetController extends GetxController{
  final String noticeId;
  final String targetCommentId;
  late final CollectionReference reference;
  List<Comment> replyList = [];
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  ReplyCommentWidgetController({required this.noticeId , required this.targetCommentId}){
    reference = FirebaseFirestore.instance
        .collection('notice_comment')
        .doc(noticeId)
        .collection('free')
        .doc(targetCommentId)
        .collection('reply');
  }

  Future<void> load() async {
    try{
      loadingState.value = LoadingState.loading;

      QuerySnapshot querySnapshot = await reference
          .orderBy('date' , descending: true)
          .limit(3)
          .get();

      replyList = querySnapshot.docs.map((e) => Comment.fromMap(e.id , e.data() as Map<String , dynamic> , 0)).toList();
      loadingState.value = LoadingState.success;
    }catch(e){
      StaticLogger.logger.e('[ReplyCommentWidgetController.load()] $e');
      loadingState.value = LoadingState.fail;
    }
  }
}