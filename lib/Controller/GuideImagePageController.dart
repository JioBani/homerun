import 'package:get/get.dart';
import 'package:homerun/Model/GuideImagePageDataSource.dart';

class GuideImagePageController extends GetxController{
  /*RxList<AdData> productDatas = <AdData>[].obs;
  //var productsCount = 0;
  //final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('items');
  //final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    productDatas.add(AdData(getImageUrl(), ""));
  }

  Future<String> getImageUrl() async {
    try {
      final images =  FirebaseStorage.instance.ref().child("images");
      final imageUrl = await images.child("Ahri_7.jpg").getDownloadURL();
      Logger().log(Level.info, imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return "";
    }
  }*/

}