import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/UserInfoValidator/UserInfoValidator.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/LoadingDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Common/Widget/SelectBoxWidget.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:homerun/Value/Region.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class UserInfoModifyPageController extends GetxController{

  final ImagePicker picker = ImagePicker();
  final UserInfoValidator userInfoValidator = UserInfoValidator();
  final UserInfoService userInfoService = UserInfoService();

  late final TextEditingController nickNameController;
  late final TextEditingController birthController;

  late final SelectBoxController<Gender> genderController;
  late final SelectBoxController<Region> regionController;

  final FocusNode nickNameFocusNode = FocusNode();
  final FocusNode birthFocusNode = FocusNode();

  XFile? modifiedProfileImage;
  final UserDto userDto;
  late final String initNickName;
  late final String initBirth;
  late final Gender initGender;
  late final List<Region> initRegions;

  int birthTextLength = 0;
  bool isNameChecked = false;

  UserInfoModifyPageController({required this.userDto}){
    initNickName = userDto.displayName;
    initBirth = TimeFormatter.dateToDatString(userDto.birth.toDate());
    initGender = userDto.gender;
    initRegions = userDto.interestedRegions.where((region)=>region != null).cast<Region>().toList();

    nickNameController = TextEditingController(text: initNickName);
    birthController = TextEditingController(text: initBirth);
    genderController = SelectBoxController(initValue: userDto.gender);
    regionController = SelectBoxController(
      isCanSelectMulti: true,
      initValues: initRegions.map((region)=>region).toList(), // initRegions를 깊은 복사(Region이 enum타입이므로 재귀 복사 필요 x)
      maxSelectCount: 3
    );
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
      if(await pickedFile.length() / (1024 * 1024) > userInfoValidator.maxProfileMbSize){
        CustomSnackbar.show('오류', '프로필 이미지의 크기는 ${userInfoValidator.maxProfileMbSize}MB를 넘을 수 없습니다.');
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

    //#. 닉네임 확인이 되었는지
    if(initNickName != nickNameController.text && !isNameChecked){
      CustomDialog.defaultDialog(
          context:context,
          title: "닉네임을 먼저 확인해주세요.",
          buttonText: "확인"
      );
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
    if(!userInfoValidator.checkBirthText(birthController.text)){
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

  void updateUserInfo(BuildContext context){

    if(nickNameFocusNode.hasFocus){
      nickNameFocusNode.unfocus();
    }
    else if(birthFocusNode.hasFocus){
      birthFocusNode.unfocus();
    }

    if(!checkData(context)){
      return;
    }

    //#. 변경된 것이 없으면 매개변수에 null
    LoadingDialog.showLoadingDialogWithFuture(
        context,
        Get.find<AuthService>().updateUserInfo(
            displayName: initNickName == nickNameController.text ? null : nickNameController.text,
            gender: initGender == genderController.value ? null : genderController.value,
            regions: const DeepCollectionEquality().equals(initRegions, regionController.values) ?
            null : regionController.values.map((e) => e.koreanString).toList(),
            birth: initBirth == birthController.text ? null : birthController.text
        )
    );
  }

  /// 닉네임 확인
  //TODO 닉네임을 변경하지 않았을 경우?
  Future<void> checkNickName(BuildContext context) async {
    if(nickNameFocusNode.hasFocus){
      nickNameFocusNode.unfocus();
    }
    else if(birthFocusNode.hasFocus){
      birthFocusNode.unfocus();
    }

    var(String? result, _) = await LoadingDialog.showLoadingDialogWithFuture<String?>(
      context,
      userInfoService.checkNickName(nickNameController.text)
    );

    if(result != null && context.mounted){
      CustomDialog.showConfirmationDialog(context: context, content: result);
    }
    else{
      CustomDialog.showConfirmationDialog(context: context, content: "사용 할 수 있는 닉네임 입니다.");
      isNameChecked = true;
    }

    return;
  }

  void onNickNameEdit(String name){
    isNameChecked = false;
  }
}