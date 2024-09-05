import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Common/ApiResponse/ApiResult.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserInfoService{

  Future<Result> updateProfile(XFile xFile){
    return Result.handleFuture(action: ()async{

      //#1. 로그인 확인
      UserDto userDto = Get.find<AuthService>().getUser();

      //#1. 이미지 타입 검사

      //#2. 이미지 확장자 변경 -> 일단 보류

      //#3. 이미지 업로드
      Result uploadResult = await _uploadImage(
        image: xFile,
        userId: FirebaseAuth.instance.currentUser!.uid
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

  /// 닉네임 확인
  /// 
  /// [returns] 사용 할 수 있는 닉네임이면 [null], 사용 할 수 없는 닉네임이면 [String] 메세지를 반환
  Future<String?> checkNickName(String nickName) async {
    final ApiResult<String> apiResult = await ApiResult.handleRequest<String>(
        http.post(Uri.parse(FirebaseFunctionEndpoints.checkDisplayName),
            headers: {
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              "displayName" : nickName
            })
        ),
        timeout: const Duration(minutes: 1)
    );

    if(apiResult.parsingFailed){
      return "서버에 연결 할 수 없습니다.";
    }
    else{
      if(apiResult.isSuccess){
        return null;
      }
      else{
        return apiResult.apiResponse!.error!.message;
      }
    }
  }
}