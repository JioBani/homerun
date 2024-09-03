import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/UserInfoValidator/UserInfoValidator.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/LoginPage/View/UserInfoInputPage/SelectBoxWidget.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:homerun/Value/Region.dart';
import 'package:homerun/Value/UserInfoValues.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoModifyPageController extends GetxController{

  final ImagePicker picker = ImagePicker();
  final UserInfoValidator userInfoValidator = UserInfoValidator();

  late final TextEditingController nickNameController;
  late final  TextEditingController birthController;

  final SelectBoxController<Gender> genderController = SelectBoxController();
  final SelectBoxController<Region> regionController = SelectBoxController(isCanSelectMulti: true);

  XFile? modifiedProfileImage;

  final UserInfoService userInfoService = UserInfoService();

  int birthTextLength = 0;

  UserInfoModifyPageController({required String nickName, required String birth}){
    nickNameController = TextEditingController(text: nickName);
    birthController = TextEditingController(text: birth);
  }

  /// 프로필 이미지 추가
  Future<void> setProfileImage() async {
    try{
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      //#. 이미지 가져왔는지 확인
      if(pickedFile == null){
        CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
        return;
      }

      //#. 이미지 크기 제한 확인
      if(await pickedFile.length() / (1024 * 1024) > UserInfoValues.maxProfileSizeMB){
        CustomSnackbar.show('오류', '프로필 이미지의 크기는 ${UserInfoValues.maxProfileSizeMB}MB를 넘을 수 없습니다.');
        return;
      }

      modifiedProfileImage = pickedFile;

      if(modifiedProfileImage != null){
        Result result = await userInfoService.updateProfile(modifiedProfileImage!);
        if(!result.isSuccess){
          CustomSnackbar.show('오류', '프로필 업로드에 실패했습니다.');
        }
        else{
          CustomSnackbar.show('알림', '프로필 변경에 성공했습니다.');
        }
      }

      update();
    }catch(e,s){
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }

  /// 회원가입 데이터 유효성 확인
  bool checkData(BuildContext context){

    //#. 닉네임 체크
    String? nameCheck = userInfoValidator.checkNickName(nickNameController.text);
    if(nameCheck != null){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context:context,
            title: nameCheck,
            buttonText: "확인"
        );
      }
      return false;
    }

    //#. 성별 확인
    if(genderController.value == null){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context:context,
            title: "성별을 입력해주세요.",
            buttonText: "확인"
        );
      }
      return false;
    }

    //#. 생년월일 확인
    if(userInfoValidator.checkBirthText(birthController.text)){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context:context,
            title: "생년월일이 유효하지 않습니다.",
            buttonText: "확인"
        );
      }
      return false;
    }

    //#. 관심지역 확인
    String? regionCheck = userInfoValidator.checkRegion(regionController.values);
    if(regionCheck != null){
      if(context.mounted){
        CustomDialog.defaultDialog(
            context:context,
            title: regionCheck,
            buttonText: "확인"
        );
      }
      return false;
    }

    return true;
  }

  /// 변경시 [UserInfoPageController]도 변경 필요
  void onBirthTextChange(String value){
    int newLength = value.length;
    if(newLength > birthTextLength){
      if(newLength == 4){
        birthController.text =  '${birthController.text}.';
      }
      else if(newLength == 7){
        birthController.text =  '${birthController.text}.';
      }
      birthTextLength = birthController.text.length;
    }
    else{
      if(newLength == 4){
        birthController.text = birthController.text.substring(0, birthController.text.length - 1);
      }
      else if(newLength == 7){
        birthController.text = birthController.text.substring(0, birthController.text.length - 1);
      }
      birthTextLength = birthController.text.length;
    }
  }
}