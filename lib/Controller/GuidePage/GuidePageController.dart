import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/GuidePostData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Vocabulary/Vocabulary.dart';

enum LoadingState{
  idle,
  loading,
}

class GuidePageController extends GetxController{
  RxMap<String , List<GuidePostData>> guidePostListMap = RxMap();
  RxMap<String , List<DocumentSnapshot>> guidePostSnapshotListMap = RxMap();

  GuidePageController(){
    guidePostSnapshotListMap = RxMap();
    for (var type in Vocabulary.specialType) {
      guidePostSnapshotListMap[type] = [];
    }

    guidePostListMap = RxMap();
    for (var type in Vocabulary.specialType) {
      guidePostListMap[type] = [];
    }
  }

  Future<int?> getPost(String type , int nums) async {
    if(guidePostListMap[type] == null){
      guidePostListMap[type] = [];
    }

    if(guidePostSnapshotListMap[type] == null){
      guidePostSnapshotListMap[type] = [];
    }

    //QuerySnapshot? querySnapshot;
    final List<DocumentSnapshot> snapShotList = guidePostSnapshotListMap[type]!;

    /*if(snapShotList.isNotEmpty){
      querySnapshot = await FirebaseFirestoreService.instance.getGuidePostData(type, snapShotList.last, nums);
      //querySnapshot = await FirebaseFirestoreService.instance.getGuidePostData(type, snapShotList.last, nums);
    }
    else{
      querySnapshot = await FirebaseFirestoreService.instance.getGuidePostData(type, null, nums);
    }*/

    List<DocumentSnapshot>? docList = await FirebaseFirestoreService.instance.getGuidePostData(type, null, nums);

    if(docList == null){
      StaticLogger.logger.i("[GuidePageController.getPost()] 데이터를 가져오지 못 했습니다.");
      update();
      return null;
    }
    else if(docList.isEmpty){
      StaticLogger.logger.i("[GuidePageController.getPost()] 데이터가 없습니다.");
      update();
      return 0;
    }
    else{

      List<GuidePostData> result = docList.map((post){
        try{
          return GuidePostData.fromDocumentSnapshot(post);
        }catch(e){
          return GuidePostData.error(e);
        }
      }).toList();

      snapShotList.addAll(docList);
      guidePostListMap[type]!.addAll(result);
      update();
      return result.length;
    }
  }


  Future<int?> initData(String type , int nums) async {
    guidePostListMap[type]?.clear();
    guidePostSnapshotListMap[type]?.clear();

    return await getPost(type , nums);
  }

  bool isDataFetched(String type){
    if(guidePostListMap[type] == null){
      return false;
    }
    else if(guidePostListMap[type]!.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }

}