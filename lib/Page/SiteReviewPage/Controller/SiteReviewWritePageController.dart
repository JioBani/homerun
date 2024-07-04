import 'dart:io';

import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:image_picker/image_picker.dart';

class OutOfImageSizeException implements Exception{

}

class SiteReviewWritePageController extends GetxController{
  final ImagePicker picker = ImagePicker();
  final String noticeId;
  final double maxSizeMb = 10;
  RxList<XFile> images = RxList([]);
  Rx<XFile?> thumbnailFile = Rx(null);
  double imageSize = 0;

  SiteReviewWritePageController({required this.noticeId});

  Future<Result<void>> addImage() async {
    return await Result.handleFuture(
        action: () async {
          final List<XFile> pickedFile = await picker.pickMultiImage();

          images.addAll(pickedFile);
          await calculateTotalImageSize();
          update();
        }
    );

  }

  Future<void> removeImage(int index) async {
    if(index < images.length){
      if(images[index] == thumbnailFile.value){
        thumbnailFile.value = null;
      }
      images.removeAt(index);
      await calculateTotalImageSize();
      update();
    }
  }

  void setThumbnail(int index){
    if(index < images.length){
      thumbnailFile.value = images[index];
      update();
    }
  }

  Future<Result<void>> upload(String title, String content) async{

    if(imageSize > maxSizeMb){
      return Result<void>.fromFailure(OutOfImageSizeException(), StackTrace.current);
    }

    return SiteReviewService.instance.upload(
        SiteReviewWriteDto(
            noticeId: noticeId,
            title: title,
            content: content,
            thumbnail: thumbnailFile.value?.name ?? images.first.name
        ),
        images,
            (state,message,exception) {
          if (state == UploadState.progress) {
            StaticLogger.logger.i(message);
          }
          else if (state == UploadState.success) {
            StaticLogger.logger.i("업로드 성공");
          }
          else {
            StaticLogger.logger.e("$message : $exception");
          }
        }
    );
  }

  Future<void> calculateTotalImageSize() async {
    double totalSize = 0;
    for (XFile image in images) {
      final file = File(image.path);
      totalSize += await file.length();
    }
    imageSize = (totalSize / (1024 * 1024));
  }
}