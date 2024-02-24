import 'package:get/get.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';


class RegionalInfoController extends GetxController {
  String category;
  String regional;
  bool isLoading = false;

  List<HousingData> housingDataList = [];
  List<DocumentSnapshot> housingSnapshotList = [];

  RegionalInfoController({
    required this.category,
    required this.regional
  });

  Future<int?> addData(int count) async {

    isLoading = true;
    update();

    List<DocumentSnapshot>? result = (await FirebaseFirestoreService.instance.getHousingData(
        category, regional, housingSnapshotList.isNotEmpty ? housingSnapshotList.last : null , count)
    )?.docs;

    if(result == null){
      isLoading = false;
      update();
      return null;
    }

    housingSnapshotList.addAll(result);
    housingDataList.addAll(result.map((e) => HousingData.fromDocumentSnapshot(e)).toList());

    isLoading = false;
    update();
    return result.length;
  }

  Future<int?> initData() async {
    if(housingDataList.isEmpty){
      await addData(5);
      if(housingDataList.isEmpty){
        return 0;
      }
      else{
        return 1;
      }
    }
    else{
      return 1;
    }
  }

  void resetData(){
    housingDataList = [];
    housingSnapshotList = [];
    update();
  }
}