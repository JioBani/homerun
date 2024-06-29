import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SiteReviewWritePageController extends GetxController{
  final ImagePicker picker = ImagePicker();
  RxList<XFile> images = RxList([]);

  Future<void> addImage() async {
    final List<XFile> pickedFile = await picker.pickMultiImage();
    images.addAll(pickedFile);
  }

  void removeImage(int index){
    if(index < images.length){
      images.removeAt(index);
    }
  }
}