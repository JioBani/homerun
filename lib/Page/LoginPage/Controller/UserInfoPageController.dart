import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/LoginPage/View/SignUpSuccessPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:homerun/Value/AgeRange.dart';
import 'package:homerun/Value/Region.dart';
import 'package:image_picker/image_picker.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart';

import '../View/UserInfoInputPage/SelectBoxWidget.dart';

class UserInfoPageController extends GetxController{
  XFile? profileImage;

  final ImagePicker picker = ImagePicker();
  final double maxSizeMb = 3;

  final SelectBoxController<Gender> genderController = SelectBoxController<Gender>();
  final SelectBoxController<AgeRange> ageController = SelectBoxController<AgeRange>();
  final SelectBoxController<Region> regionController = SelectBoxController<Region>(isCanSelectMulti: true);
  final TextEditingController nickNameController = TextEditingController();

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
      if(await pickedFile.length() / (1024 * 1024) > maxSizeMb){
        CustomSnackbar.show('오류', '프로필 이미지의 크기는 ${maxSizeMb}MB를 넘을 수 없습니다.');
        return;
      }

      profileImage = pickedFile;

      if(profileImage != null){
        await UserInfoService().updateProfile(profileImage!);
      }

      update();
    }catch(e,s){
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }
  
  /// 회원가입 데이터 유효성 확인
  bool checkData(BuildContext context){

    //#. 닉네임 체크
    if(!checkNickName(nickNameController.text, context)){
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

    //#. 연령대 확인
    if(ageController.value == null){
      CustomDialog.defaultDialog(
          context: context,
          title: "연령대를 선택해주세요",
          buttonText: "확인"
      );
      return false;
    }

    //#. 관심지역 확인
    if(regionController.values.isEmpty){
      CustomDialog.defaultDialog(
          context: context,
          title: "관심 지역을 하나 이상\n선택해주세요",
          buttonText: "확인",
          padding: EdgeInsets.symmetric(vertical: 3.w ,horizontal: 10.w)
      );
      return false;
    }

    //#. 관심지역 선택 초과 확인
    if(regionController.values.length > 3){
      CustomDialog.defaultDialog(
          context: context,
          title: "관심 지역은 3개 이하로\n선택해주세요",
          buttonText: "확인",
          padding: EdgeInsets.symmetric(vertical: 3.w ,horizontal: 10.w)
      );
      return false;
    }

    return true;
  }

  /// 닉네임 체크
  bool checkNickName(String displayName, BuildContext context){

    //#. 닉네임 길이 체크
    String? text = checkNickNameLength(displayName);
    if(text != null){
      CustomDialog.defaultDialog(
          context : context,
          title: text,
          buttonText: "확인"
      );

      return false;
    }

    //#. 닉네임 단어 체크
    if(displayName.containsBadWords){
      CustomDialog.defaultDialog(
          context : context,
          title: "사용할 수 없는 닉네임 입니다.",
          buttonText: "확인"
      );
      return false;
    }

    return true;
  }


  /// 닉네임 길이 체크 함수
  ///
  /// [returns] : 사용할 수 있는 닉네임인 경우 null을 반환합니다.
  /// 사용할 수 없는 닉네임인 경우 경고 메세지를 반환합니다.
  String? checkNickNameLength(String nickname){
    
    //#. 비어있는 경우
    if(nickname.isEmpty){
      return "닉네임을 입력해주세요.";
    }

    int koreanMin = 2,  koreanMax = 12, engMin = 3, engMax = 16;
    // 한글 패턴
    final koreanPattern = RegExp(r'[가-힣]');
    // 영문 패턴
    final englishPattern = RegExp(r'[a-zA-Z]');
    // 숫자 패턴
    final numberPattern = RegExp(r'[0-9]');

    bool hasKorean = koreanPattern.hasMatch(nickname);
    bool hasEnglish = englishPattern.hasMatch(nickname);
    bool hasNumber = numberPattern.hasMatch(nickname);


    int length = nickname.length;

    //#. 한글,영문,숫자만 포함
    if(!(hasNumber || hasKorean || hasEnglish)){
      return "닉네임에는 한글,영문,숫자만 포함될 수 있습니다.";
    }

    if(hasKorean){ //#. 한글 포함
      if(length < koreanMin){
        return "한글 닉네임은 $koreanMin글자 이상이어야 합니다.";
      }
      else if(length > koreanMax){
        return "한글 닉네임은 $koreanMax글자 이하이어야 합니다.";
      }
      else{
        return null;
      }
    }
    else{ //#. 영문과 숫자만
      if(length < engMin){
        return "영문 또는 숫자 닉네임은 $engMin글자 이상이어야 합니다.";
      }
      else if(length > engMax){
        return "영문 또는 숫자 닉네임은 $engMax글자 이하이어야 합니다.";
      }
      else{
        return null;
      }
    }
  }

  ///회원가입
  Future<void> signUp(BuildContext context)async{

    //#. 데이터 체크
    if(!checkData(context)){
      return;
    }

    //#. 회원가입
    //TODO 실제 값으로 변경
    Result result = await CustomDialog.showLoadingDialog<SignUpResult>(
      context: context,
      future: Get.find<AuthService>().signUp(
        displayName: nickNameController.text,
        gender: genderController.value!,
        ageRages: ageController.value!.label,
        regions: regionController.values.map((e) => e.label).toList()
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
    bool? pageResult = await Get.to(const SignUpSuccessPage());
    if(pageResult == true && context.mounted){
      Get.back(result: true);
    }
  }
}