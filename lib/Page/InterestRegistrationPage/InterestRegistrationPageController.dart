import 'package:flutter/cupertino.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';

class InterestRegistrationPageController{
  bool _agree = false;

  final TextEditingController nameController  = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  InterestRegistrationPageController();

  void setAgree(bool agree){
    _agree = agree;
  }

  Future<void> submit(BuildContext context) async{

    String? errorMsg;

    if(nameController.text.isEmpty){
      errorMsg = "이름을 입력해주세요.";
    }
    else if(nameController.text.length < 2 || containsNumber(nameController.text)){
      errorMsg = "유효하지 않은 이름입니다.";
    }
    else if(phoneController.text.isEmpty){
      errorMsg = "연락처를 입력해주세요.";
    }
    else if(phoneController.text.length < 9){
      errorMsg = "유효하지 않은 연락처 입니다.";
    }
    else if(!_agree){
      errorMsg = "개인정보에 수집 및 이용 동의에 동의해야합니다.";
    }

    if(errorMsg == null){
      //TODO 관심등록
    }
    
    if(context.mounted){
      CustomDialog.defaultDialog(
        context: context, 
        title: errorMsg ?? "관심등록에 성공했습니다.", 
        buttonText: "확인"
      );
    }
  }

  bool containsNumber(String input) {
    // 정규 표현식 \d는 숫자를 의미합니다.
    final RegExp regex = RegExp(r'\d');
    return regex.hasMatch(input);
  }

}