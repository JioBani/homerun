import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/UserInfoValidator/UserInfoValidator.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/LoginPage/View/SignUpSuccessPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Common/Widget/SelectBoxWidget.dart';

class UserInfoPageController extends GetxController{
  XFile? profileImage;

  final ImagePicker picker = ImagePicker();
  final UserInfoValidator userInfoValidator = UserInfoValidator();

  final SelectBoxController<Gender> genderController = SelectBoxController<Gender>();
  final SelectBoxController<Region> regionController = SelectBoxController<Region>(
    isCanSelectMulti: true,
    maxSelectCount: 3
  );
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  int birthTextLength = 0;

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

      profileImage = pickedFile;

      update();
    }catch(e,s){
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }
  
  /// 회원가입 데이터 유효성 확인
  bool checkData(BuildContext context){

    //. 닉네임 체크
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

  ///회원가입
  Future<void> signUp(BuildContext context)async{

    //#. 데이터 체크
    if(!checkData(context)){
      return;
    }

    //#. 회원가입
    Result result = await CustomDialog.showLoadingDialog<SignUpResult>(
      context: context,
      future: Get.find<AuthService>().signUp(
        displayName: nickNameController.text,
        gender: genderController.value!,
        birth: birthController.text,
        regions: regionController.values.map((e) => e.koreanString).toList(),
      )
    );

    if(!result.isSuccess){
      if(context.mounted){
        CustomDialog.defaultDialog(
          context: context,
          title: "회원가입에 실패했습니다. 인터넷 문제 혹은 서버 문제일 수 있습니다.",
          buttonText: "확인",
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
          buttonGap: 7.w,
          maxWidth: 220.w,
          maxHeight: double.infinity,
        );
      }
      return;
    }

    //#. 실패 피드백
    //#. 성공하면 이미 로그인이 된 상태
    if(result.content != SignUpResult.success){
      String text = "";
      switch(result.content!){
        case SignUpResult.userAlreadyExistsFailure :
          text = "동일한 아이디로 회원가입한 아이디가 이미 존재합니다. 계속해서 이 메세지가 발생하면 고객센터로 문의해주세요."; break;
          
        case SignUpResult.displayNameAlreadyExistsFailure :
          text = "동일한 닉네임이 존재합니다."; break;
          
        case SignUpResult.serverSignUpFailure :
          text = "오류가 발생하였습니다. 잠시 후 다시 시도해주세요."; break;

        case SignUpResult.accessTokenFailure :
        case SignUpResult.currentLoginDoNotExistFailure :
          text = "소셜 로그인 정보가 정확하지 않습니다. 계속해서 이 메세지가 발생하면 고객센터로 문의해주세요."; break;

        case SignUpResult.firebaseLoginFailure :
          text = "로그인에 실패하였습니다. 계속해서 이 오류가 발생하면 고객센터로 문의해주세요."; break;

        default : {}
      }

      if(context.mounted){
        CustomDialog.defaultDialog(
          context: context,
          title: text,
          buttonText: "확인",
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
          buttonGap: 7.w,
          maxWidth: 220.w,
          maxHeight: double.infinity,
        );
      }

      return;
    }


    //#. 프로필 이미지 업로드
    //#. 프로필 이미지 업로드는 성공 여부를 확인하지 않음
    if(profileImage != null){
      UserInfoService().updateProfile(profileImage!);
    }

    //#. 회원가입 완료 페이지로 넘기고 재귀적으로 페이지 pop
    bool? pageResult = await Get.to(SignUpSuccessPage(name: nickNameController.text,));
    if(pageResult == true && context.mounted){
      Get.back(result: true);
    }
  }

  /// 변경시 [UserInfoModifyPageController]도 변경 필요
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