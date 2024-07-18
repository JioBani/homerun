import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/SiteReviewPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';

import '../Service/UploadResult.dart';

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

  Future<void> upload(String title, String content , BuildContext context) async{

    if(imageSize > maxSizeMb){
      Snackbar.show('오류', '이미지의 크기는 10MB를 넘을 수 없습니다.');
      return;
    }

    if(images.isEmpty){
      Snackbar.show('오류', '이미지를 한 개 이상 업로드 해야합니다 .');
      return;
    }

    if(title.isEmpty || content.isEmpty){
      Snackbar.show('오류', '제목과 내용을 입력해주세요.');
      return;
    }

    if(title.length < 3){
      Snackbar.show('오류', '제목은 3글자 이상이어야 합니다.');
      return;
    }

    if(title.length > 20){
      Snackbar.show('오류', '제목은 20글자 이하이어야 합니다.');
      return;
    }

    if(content.length < 3){
      Snackbar.show('오류', '내용은 10글자 이상이어야 합니다.');
      return;
    }


    UploadResultInfo result = await SiteReviewService.instance.upload(
        SiteReviewWriteDto(
          noticeId: noticeId,
          title: title,
          content: content,
          thumbnail: thumbnailFile.value?.name ?? images.first.name
        ),
        images,
        (p0, p1, p2) {

        }
    );

    String snackbarTitle = "";
    String snackbarContent = "";

    switch(result.uploadState){
      case UploadResult.authFailure : snackbarTitle = "오류"; snackbarContent = "로그인이 필요합니다.";
      case UploadResult.createDocFailure : snackbarTitle = "오류"; snackbarContent = "글 업로드에 실패했습니다.";
      case UploadResult.writeDocFailure : snackbarTitle = "오류"; snackbarContent = "글 업로드에 실패했습니다.";
      case UploadResult.imageUploadFailure :
        snackbarTitle = "알림"; snackbarContent = "이미지 업로드에 실패했습니다(${result.failImages?.length ?? 0}개 실패).";
      default :
    }

    if(result.uploadState == result.uploadState){
      if(context.mounted){
        CustomDialog.show(
            builder: (dialogContext){
              return buildDialog(
                result.siteReview,
                dialogContext,
                context,
              );
            },
            context: context
        );
      }
    }
    else{
      Snackbar.show(snackbarTitle, snackbarContent);
    }
  }

  Future<void> calculateTotalImageSize() async {
    double totalSize = 0;
    for (XFile image in images) {
      final file = File(image.path);
      totalSize += await file.length();
    }
    imageSize = (totalSize / (1024 * 1024));
  }

  Widget buildDialog(SiteReview? siteReview , BuildContext dialogContext , BuildContext pageContext){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "글을 업로드 했습니다.",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          InkWell(
            onTap: ()  {
              UserDto? userDto = Get.find<AuthService>().tryGetUser();

              if(dialogContext.mounted){
                Navigator.pop(dialogContext);
              }

              if(pageContext.mounted){
                Navigator.pop(pageContext);
              }

              if(userDto != null && siteReview != null){
                Get.to(SiteReviewPage(
                    siteReview: siteReview,
                    userDto: userDto
                ));
              }
            },
            child: Container(
              width: 75.w,
              height: 25.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Theme.of(dialogContext).primaryColor,
              ),
              child: Center(
                child: Text(
                  "확인",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}