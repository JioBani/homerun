import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/LoadingDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Page/LoginPage/View/SignUpSuccessPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserInfoService.dart';
import 'package:image_picker/image_picker.dart';

import '../View/UserInfoInputPage/SelectBoxWidget.dart';

class UserInfoPageController extends GetxController{
  XFile? profileImage;

  final ImagePicker picker = ImagePicker();
  final double maxSizeMb = 3;

  final SelectBoxController<String> genderController = SelectBoxController<String>();
  final SelectBoxController<String> ageController = SelectBoxController<String>();
  final SelectBoxController<String> locationController = SelectBoxController<String>(isCanSelectMulti: true);

  final List<String> ages = ["20대","30대","40대","50대","60대"];
  final List<String> locations = ["서울","경기·인천","부산","대구·울산","충청","강원","경북"];


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
    if(locationController.values.isEmpty){
      CustomDialog.defaultDialog(
          context: context,
          title: "관심 지역을 하나 이상\n선택해주세요",
          buttonText: "확인",
          padding: EdgeInsets.symmetric(vertical: 3.w ,horizontal: 10.w)
      );
      return false;
    }

    //#. 관심지역 선택 초과 확인
    if(locationController.values.length > 3){
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

  ///회원가입
  Future<void> signUp(BuildContext context)async{

    //#. 데이터 체크
    if(!checkData(context)){
      return;
    }

    //#. 회원가입
    var (SignUpResult result, _) = await LoadingDialog.showLoadingDialogWithFuture<SignUpResult>(
      context,
      Get.find<AuthService>().signUp(
          displayName: "dd",
          birth: "2000-10-22",
          gender: Gender.male
      )
    );

    //#. 실패 피드백
    //#. 성공하면 이미 로그인이 된 상태
    if(result != SignUpResult.success){
      String text = "";
      switch(result){
        case SignUpResult.userAlreadyExistsFailure :
          text = "동일한 아이디로 회원가입한 아이디가 이미 존재합니다. 계속해서 이 메세지가 발생하면 고객센터로 문의해주세요.";

        case SignUpResult.serverSignUpFailure :
          text = "오류가 발생하였습니다. 잠시 후 다시 시도해주세요.";

        case SignUpResult.accessTokenFailure :
        case SignUpResult.currentLoginDoNotExistFailure :
          text = "소셜 로그인 정보가 정확하지 않습니다. 계속해서 이 메세지가 발생하면 고객센터로 문의해주세요.";

        case SignUpResult.firebaseLoginFailure :
          text = "로그인에 실패하였습니다. 계속해서 이 오류가 발생하면 고객센터로 문의해주세요.";

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