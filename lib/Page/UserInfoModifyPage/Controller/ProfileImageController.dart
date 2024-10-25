import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Loader.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/UserInfoValidator/UserInfoValidator.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';
import 'package:image_picker/image_picker.dart';

import '../../../FirebaseReferences/UserInfoReferences.dart';

class ProfileImageController extends GetxController{
  final ImagePicker picker = ImagePicker();
  final UserInfoValidator userInfoValidator = UserInfoValidator();
  final UserInfoService userInfoService = UserInfoService();

  Rx<Uint8List?> modifiedProfileImage = Rx(null);

  Uint8List? lastProfileImage;

  final UserDto userDto;

  late Loader<Uint8List?> profileImageLoader = Loader(
      onLoad: (loader) async {
        loader.setState(LoadingState.loading);

        Uint8List? result = await FirebaseStorageCacheService.getAsset(UserInfoReferences.getUserProfileImagePath(userDto.uid ?? ''));

        if(result == null){
          loader.setState(LoadingState.fail);
          return null;
        }
        else{
          lastProfileImage = result;
          loader.setState(LoadingState.success);
          return result;
        }
      },
      onStateChanged: (_,__){
        update();
      }
  );

  ProfileImageController({required this.userDto});

  Future<void> pickProfileImage() async {
    try{
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      //#. 이미지 가져왔는지 확인
      if(pickedFile == null){
        CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
        return;
      }

      //#. 이미지 크기 제한 확인
      if(await pickedFile.length() / (1024 * 1024) > userInfoValidator.maxProfileMbSize){
        CustomSnackbar.show('오류', '프로필 이미지의 크기는 ${userInfoValidator.maxProfileMbSize}MB를 넘을 수 없습니다.');
        return;
      }

      modifiedProfileImage.value = await pickedFile.readAsBytes();

      update();
    }catch(e){
      StaticLogger.logger.e("[UserInfoModifyPageController.pickImage()]");
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }

  Future<void> updateProfile(BuildContext context) async{
    if(modifiedProfileImage.value == null){
      CustomSnackbar.show('오류', '업데이트할 이미지가 없습니다. 다시 시도해주세요.');
      return;
    }

    Result result;
    if(context.mounted){
      result = await CustomDialog.showLoadingDialog(
        context: context,
        future: userInfoService.updateProfileWithBytes(modifiedProfileImage.value!)
      );
    }
    else{
      result = await userInfoService.updateProfileWithBytes(modifiedProfileImage.value!);
    }

    if(!result.isSuccess){
      CustomSnackbar.show('오류', '프로필 업로드에 실패했습니다.');
    }
    else{
      lastProfileImage = modifiedProfileImage.value;
      modifiedProfileImage.value = null;

      FirebaseStorageCacheService.updateMemoryCache(UserInfoReferences.getUserProfileImagePath(userDto.uid ?? ''));

      CustomSnackbar.show('알림', '프로필 변경에 성공했습니다.');
    }
  }

  void resetModify(){
    modifiedProfileImage.value = null;
    update();
  }

}
