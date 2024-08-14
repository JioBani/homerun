import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoService{

  Future<Result> updateProfile(XFile xFile){
    return Result.handleFuture(action: ()async{

      StaticLogger.logger.i(FirebaseAuth.instance.currentUser);

      //#1. 로그인 확인
      UserDto userDto = Get.find<AuthService>().getUser();

      //#1. 이미지 타입 검사

      //#2. 이미지 확장자 변경 -> 일단 보류

      //#3. 이미지 업로드
      Result uploadResult = await _uploadImage(
        image: xFile,
        userId: userDto.uid
      );

      if(uploadResult.isSuccess){
        StaticLogger.logger.i("성공");
      }
      else{
        StaticLogger.logger.i("실패 ${uploadResult.exception}\n${uploadResult.stackTrace}");
      }
    });

  }

  Future<Result<void>> _uploadImage({
    required XFile image,
    required String userId,
    void Function(TaskSnapshot)? snapshotEventAction
  }) async {
    return Result.handleFuture(action: () async {
      Reference storageRef = FirebaseStorage.instance.ref().child('user/profile/$userId/profile.jpg');
      UploadTask uploadTask = storageRef.putFile(File(image.path));

      uploadTask.snapshotEvents.listen(snapshotEventAction);

      await uploadTask.whenComplete(() {});
    });
  }
}