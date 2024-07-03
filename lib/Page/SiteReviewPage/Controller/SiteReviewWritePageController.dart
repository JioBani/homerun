import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:image_picker/image_picker.dart';

class SiteReviewWritePageController extends GetxController{
  final ImagePicker picker = ImagePicker();
  final String noticeId;
  RxList<XFile> images = RxList([]);
  Rx<XFile?> thumbnailFile = Rx(null);

  SiteReviewWritePageController({required this.noticeId});

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

  Future<void> upload(String title, String content){
    return SiteReviewService.instance.write(
        SiteReviewWriteDto(
            noticeId: noticeId,
            title: title,
            content: content,
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