import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Firebase/FirebaseStorageService.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/SiteReviewWidgetController.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewListPageController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:homerun/Page/SiteReviewPage/Service/UpdateResultInfo.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/SiteReviewPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FileDataService.dart';
import 'package:image_picker/image_picker.dart';

import '../Service/UploadResult.dart';

class SiteReviewWritePageController extends GetxController{
  final ImagePicker picker = ImagePicker();

  final String noticeId;
  final SiteReview? updateTarget;
  final bool updateMode;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final FocusNode titleFocusNode;
  final FocusNode contentFocusNode;

  final double maxSizeMb = 10;

  Map<String , XFile?> showImages = {};
  Map<String , XFile> images = {};
  Map<String , XFile?> uploadedImages = {};
  Map<String , XFile?> deleteImages = {};

  XFile? thumbnailFile;

  double imageSize = 0;

  LoadingState updateImageLoading = LoadingState.before;

  SiteReviewWritePageController({
    required this.noticeId,
    required this.titleController,
    required this.contentController,
    required this.titleFocusNode,
    required this.contentFocusNode,
    this.updateTarget ,
    this.updateMode = false,
  });

  Future<void> addImage() async {

    try{
      final List<XFile> pickedFile = await picker.pickMultiImage();

      final List<String> duplicatedImages = [];

      for(var file in pickedFile){
        if(showImages.containsKey(file.name)){
          duplicatedImages.add(file.name);
        }
        else{
          images[file.name] = file;
          showImages[file.name] = file;
        }
      }

      await calculateTotalImageSize();
      update();

      if(duplicatedImages.isNotEmpty){
        if(duplicatedImages.length == 1){
          CustomSnackbar.show(
            '오류',
            '동일한 파일명의 이미지가 있습니다. (${duplicatedImages.first})',
            duration: const Duration(milliseconds: 2500)
          );
        }
        else{
          CustomSnackbar.show(
            '오류',
            '동일한 파일명의 이미지가 있습니다. (${duplicatedImages.first}) 외 ${duplicatedImages.length - 1}개'
          );
        }
      }
    }catch(e,s){
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }

  Future<void> removeImage(String name) async {
    if(images[name] == thumbnailFile){
      thumbnailFile = null;
    }

    images.remove(name);
    showImages.remove(name);

    if(uploadedImages.containsKey(name)){
      deleteImages[name] = uploadedImages[name];
    }

    await calculateTotalImageSize();
    update();
  }

  Future<void> calculateTotalImageSize() async {
    double totalSize = 0;
    for (XFile? image in showImages.values) {
      if(image != null){
        final file = File(image.path);
        totalSize += await file.length();
      }
    }
    imageSize = (totalSize / (1024 * 1024));
  }

  void setThumbnail(String name){
    thumbnailFile = showImages[name];
    update();
  }

  //#.업로드
  Future<void> upload(String title, String content , BuildContext context) async{

    //#. 예외 검토
    if(!_checkValidation(title , content , false)){
      return;
    }

    //#. 포커스 없애기
    if(titleFocusNode.hasFocus){
      titleFocusNode.unfocus();
    }
    else if(contentFocusNode.hasFocus){
      contentFocusNode.unfocus();
    }

    //#. 업로드
    UploadResultInfo result = await _handleUploadProgress(
        siteReviewWriteDto:  SiteReviewWriteDto(
        noticeId: noticeId,
        title: title,
        content: content,
        thumbnail: thumbnailFile?.name ?? images.keys.first,
        date: Timestamp.now()
      ),
      context: context,
    );

    //#. 업로드 결과 취합
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

    //#. 다이얼로그 띄우기
    if(result.uploadState == UploadResult.success){
      if(context.mounted){
        _showResultDialog(
          result.siteReview,
          "글을 업로드 했습니다.",
          context,
          false
        );
      }
      if(result.siteReview != null){

        //리뷰 리스트 페이지에 리뷰 추가
        if(Get.isRegistered<SiteReviewListPageController>(tag: result.siteReview!.noticeId)){
          Get.find<SiteReviewListPageController>(tag: result.siteReview!.noticeId).addReview(result.siteReview!);
        }

        //공고 페이지의 리뷰 위젯에 추가
        if(Get.isRegistered<SiteReviewWidgetController>()){
          Get.find<SiteReviewWidgetController>().addReview(result.siteReview!);
        }
      }
    }
    else{
      CustomSnackbar.show(snackbarTitle, snackbarContent);
    }
  }

  Future<UploadResultInfo> _handleUploadProgress({
    required SiteReviewWriteDto siteReviewWriteDto,
    required BuildContext context,
  }) async {

    DialogRoute? dialogRoute;

    //#. 업로드
    var result = await SiteReviewService.instance.upload(
        siteReviewWriteDto,
        images.values.toList(),
        thumbnailFile?.name ?? images.keys.first,
            (text) {
          //#. 진행 상황을 다이얼로그로 출력
          if(dialogRoute != null && dialogRoute!.canPop){
            Navigator.of(context).removeRoute(dialogRoute!);
          }
          dialogRoute = _showProgressDialog(context ,text);
        }
    );

    //#. 다이얼로그가 남아있다면 지우기
    if(dialogRoute != null && dialogRoute!.canPop && context.mounted){
      Navigator.of(context).removeRoute(dialogRoute!);
    }

    return result;
  }


  //#. 업데이트
  Future<void> updateReview(String title, String content , BuildContext context) async{

    if(updateImageLoading != LoadingState.success){
      return;
    }

    if(!_checkValidation(title , content , true)){
      return;
    }

    UpdateResultInfo result = await _handleUpdateProgress(
        title: title,
        content: content,
        context: context
    );

    String snackbarTitle = "";
    String snackbarContent = "";

    switch(result.updateResult){
      case UpdateResult.authFailure : snackbarTitle = "오류"; snackbarContent = "로그인이 필요합니다.";
      case UpdateResult.docUpdateFailure : snackbarTitle = "오류"; snackbarContent = "글 수정에 실패했습니다.";
      case UpdateResult.imageUpdateFailure : snackbarTitle = "오류"; snackbarContent = "이미지 업로드에 실패했습니다.";
      default :
    }

    //#. 다이얼로그 띄우기
    if(result.updateResult == UpdateResult.success){
      if(context.mounted){
        _showResultDialog(
          result.siteReview,
          "글을 수정 했습니다.",
          context,
          true
        );
      }

      if(result.siteReview != null){
        // 리뷰 리스트 페이지에서 수정
        if(Get.isRegistered<SiteReviewListPageController>(tag: result.siteReview!.noticeId)){
          Get.find<SiteReviewListPageController>(tag: result.siteReview!.noticeId).updateReview(result.siteReview!);
        }

        // 공고 페이지의 리뷰 위젯에 있으면 수정
        if(Get.isRegistered<SiteReviewWidgetController>()){
          Get.find<SiteReviewWidgetController>().updateReview(result.siteReview!);
        }
      }
    }
    else{
      CustomSnackbar.show(snackbarTitle, snackbarContent);
    }
  }

  Future<UpdateResultInfo> _handleUpdateProgress({
    required String title,
    required String content,
    required BuildContext context,
  }) async {

    DialogRoute? dialogRoute;

    //#. 업로드
    UpdateResultInfo result = await SiteReviewService.instance.update(
        targetReview: updateTarget!,
        title: title,
        content: content,
        thumbnailImageName: thumbnailFile?.name ?? showImages.keys.first,
        uploadImages: images.values.toList(),
        deleteImageNames: deleteImages.keys.toList(),
        onProgress : (text) {
          //#. 진행 상황을 다이얼로그로 출력
          if(dialogRoute != null && dialogRoute!.canPop){
            Navigator.of(context).removeRoute(dialogRoute!);
          }
          dialogRoute = _showProgressDialog(context ,text);
        }
    );

    //#. 다이얼로그가 남아있다면 지우기
    if(dialogRoute != null && dialogRoute!.canPop && context.mounted){
      Navigator.of(context).removeRoute(dialogRoute!);
    }

    return result;
  }

  Widget _buildDialog(String content, Function() onTap, BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            content,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 75.w,
              height: 25.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Theme.of(context).primaryColor,
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

  void _showLoadingFailDialog(String content,BuildContext pageContext){
    CustomDialog.show(
      builder: (dialogContext){
        return _buildDialog(
          content,
              (){
            if(dialogContext.mounted){
              Navigator.pop(dialogContext);
            }

            if(pageContext.mounted){
              Navigator.pop(pageContext);
            }
          },
          dialogContext
        );
      },
      context: pageContext
    );
  }

  void _showResultDialog(
      SiteReview? siteReview ,
      String content ,
      BuildContext pageContext,
      bool isUpdate
    ){
    CustomDialog.show(
        barrierDismissible: false,
        builder: (dialogContext){
          return _buildDialog(
              content,
              (){
                UserDto? userDto = Get.find<AuthService>().tryGetUser();

                if(dialogContext.mounted){
                  Navigator.pop(dialogContext);
                }

                if(pageContext.mounted){
                  Navigator.pop(pageContext);
                }

                if(userDto != null && siteReview != null){
                  if(isUpdate){
                    Get.back();
                  }
                  Get.to(SiteReviewPage(
                    siteReview: siteReview,
                    userDto: userDto
                  ));
                }
              },
              dialogContext
          );
        },
        context: pageContext
    );
  }

  DialogRoute _showProgressDialog(BuildContext context,String content){
    return CustomDialog.show(
        barrierDismissible: false,
        height: 50.w,
        builder: (_){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  content,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        },
        context: context
    ).route;
  }

  Future<void> setUploadedData(BuildContext context) async {
    //#. 이미지 불러오기
    updateImageLoading = LoadingState.loading;
    update();

    Map<String , Result<XFile>> imageResult = await FirebaseStorageService.instance.downloadAllAssetsAsXFiles(
        updateTarget!.imagesRefPath
    );

    Result? lastFailResult;

    for (var entry in imageResult.entries) {
      if(entry.value.isSuccess){
        uploadedImages[entry.key] = entry.value.content!;
      }
      else{
        uploadedImages[entry.key] = null;
        lastFailResult = entry.value;
        StaticLogger.logger.e("이미지를 가져오지 못함 : ${entry.key}");
      }
      showImages[entry.key] = entry.value.content;
    }

    if(lastFailResult != null && context.mounted){
      _showLoadingFailDialog("이미지를 가져오지 못했습니다." , context);
    }

    //#. 썸네일 결정
    List<String> split = updateTarget!.thumbnailRefPath.split('/');

    setThumbnail(split.last);

    if(showImages.containsKey(split.last)){
      setThumbnail(split.last);
    }

    //#. 이미지 용량 계산
    await calculateTotalImageSize();

    updateImageLoading = LoadingState.success;

    update();
  }
  
  bool _checkValidation(String title, String content ,bool isUpdate){
    if(imageSize > maxSizeMb){
      CustomSnackbar.show('오류', '이미지의 크기는 10MB를 넘을 수 없습니다.');
      return false;
    }

    if(isUpdate){
      if(showImages.isEmpty){
        CustomSnackbar.show('오류', '이미지를 한 개 이상 업로드 해야합니다 .');
        return false;
      }
    }
    else{
      if(images.isEmpty){
        CustomSnackbar.show('오류', '이미지를 한 개 이상 업로드 해야합니다 .');
        return false;
      }
    }

    if(title.isEmpty || content.isEmpty){
      CustomSnackbar.show('오류', '제목과 내용을 입력해주세요.');
      return false;
    }

    if(title.length < 3){
      CustomSnackbar.show('오류', '제목은 3글자 이상이어야 합니다.');
      return false;
    }

    if(title.length > 20){
      CustomSnackbar.show('오류', '제목은 20글자 이하이어야 합니다.');
      return false;
    }

    if(content.length < 3){
      CustomSnackbar.show('오류', '내용은 10글자 이상이어야 합니다.');
      return false;
    }

    return true;
  }

  //#. 임시저장
  Future<bool> saveReview(BuildContext context) async {

    if(titleFocusNode.hasFocus){
      titleFocusNode.unfocus();
    }
    else if(contentFocusNode.hasFocus){
      contentFocusNode.unfocus();
    }

    bool? confirm = await CustomDialog.showConfirmationDialog(
      context: context,
      content: "이미지는 저장되지 않습니다. 현재 공고에 이전에 임시저장된 현장리뷰는 덮어씌워집니다. 임시저장하시겠습니까?",
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
    );

    if(confirm != true){
      return false;
    }

    try{
      Map<String,dynamic> data = {
        "title" : titleController.text,
        "content" : contentController.text,
      };

      await FileDataService.saveAsString("siteReview/$noticeId", jsonEncode(data));

      if(context.mounted){
        CustomDialog.defaultDialog(
            context: context,
            title: "임시저장했습니다.",
            buttonText: "확인"
        );
      }

      return true;
    }catch(e,s){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context: context,
            title: "임시저장에 실패했습니다.",
            buttonText: "확인"
        );
      }
      return false;
    }
  }

  Future<bool> loadTempReview(BuildContext context) async {
    try{
      var (String? data,Object? error, StackTrace? stackTrace) = await FileDataService.readAsString("siteReview/$noticeId");

      if(data == null){
        return false;
      }

      if(titleFocusNode.hasFocus){
        titleFocusNode.unfocus();
      }
      else if(contentFocusNode.hasFocus){
        contentFocusNode.unfocus();
      }

      bool? confirm = await CustomDialog.showConfirmationDialog(
        context: context,
        content: "임시저장된 내용이 있습니다. 불러오시겠습니까?",
        contentTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
      );


      if(confirm != true){
        return false;
      }

      Map<String, dynamic> saveData = jsonDecode(data);

      titleController.text = saveData['title']!;
      contentController.text = saveData['content']!;

      if(context.mounted){
        CustomDialog.defaultDialog(
            context: context,
            title: "임시저장된 내용을 불러왔습니다.",
            buttonText: "확인"
        );
      }

      return true;
    }catch(e,s){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context: context,
            title: "임시저장된 내용을 불러오지 못했습니다.",
            buttonText: "확인"
        ); 
      }
      return false;
    }
  }
}