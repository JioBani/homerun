import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:image_picker/image_picker.dart';

class SiteReviewWritePageController extends GetxController{
  final ImagePicker picker = ImagePicker();
  RxList<XFile> images = RxList([]);
  Rx<XFile?> thumbnailFile = Rx(null);

  Future<void> addImage() async {
    final List<XFile> pickedFile = await picker.pickMultiImage();
    images.addAll(pickedFile);
    update();
  }

  void removeImage(int index){
    if(index < images.length){
      if(images[index] == thumbnailFile.value){
        thumbnailFile.value = null;
      }
      images.removeAt(index);
      update();
    }
  }

  void setThumbnail(int index){
    if(index < images.length){
      thumbnailFile.value = images[index];
      update();
    }
  }

  Future<void> upload(){
    return SiteReviewService.instance.write(
        SiteReviewWriteDto(
            noticeId: 'test',
            title: '테스트',
            content: '컨텐츠',
            thumbnail: thumbnailFile.value?.name ?? images.first.name
        ),
        images,
        (state,message,exception){
          if(state == UploadState.progress){
            StaticLogger.logger.i(message);
          }
          else if(state == UploadState.success){
            StaticLogger.logger.i("업로드 성공");
          }
          else{
            StaticLogger.logger.e("$message : $exception");
          }
        }
    );
  }
}