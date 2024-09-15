import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/LoadingDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/HousingSaleNoticesPage.dart';
import 'package:homerun/Page/LoginPage/View/AgreementPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Style/Fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.goHomeAfterLogin = false , this.hasNoBack = false});
  final bool goHomeAfterLogin;
  final bool hasNoBack;

  Future<void> login(
      BuildContext context ,
      SocialProvider provider
  )async {
    final authService = Get.find<AuthService>();

    var (LoginResult result , _) = await LoadingDialog.showLoadingDialogWithFuture<LoginResult>(
        context,
        authService.login(provider)
    );

    if(result == LoginResult.success){
      if(context.mounted){
        Navigator.pop(context);
      }

      if(goHomeAfterLogin){
        Get.to(const HousingSaleNoticesPage());
      }
      CustomSnackbar.show("알림", "로그인에 성공했습니다.");
    }
    else if(result == LoginResult.userDoNotExistFailure){
      CustomSnackbar.show("알림", "회원가입이 필요합니다.");
      bool? result = await Get.to<bool>(const AgreementPage());
      if(result == true){
        if(context.mounted){
          Navigator.pop(context);
        }

        if(goHomeAfterLogin){
          Get.to(const HousingSaleNoticesPage());
        }

        CustomSnackbar.show("알림", "회원가입에 성공했습니다.");
      }
    }
    else{
      CustomSnackbar.show("오류", "로그인에 실패했습니다. $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //#. 뒤로가기 아이콘
            hasNoBack ?  const SizedBox.shrink() : Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new)
              ),
            ),
            SizedBox(height: 90.w,),
            //#. 청약홈런 텍스트
            Text(
              "청약홈런",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                fontFamily: Fonts.BCCard,
              ),
            ),
            SizedBox(height: 30.w,),
            //#. 안내 테스트
            Text(
              "간편하게 로그인하고\n 다양한 서비스를 이용하세요",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 57.w,),
            //#. 카카오로 시작하기
            InkWell(
              onTap: () => login(context , SocialProvider.kakao),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFEE500),
                  borderRadius: BorderRadius.circular(20.r)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble), //TODO 카카오 아이콘으로 변경
                      SizedBox(width: 8.w,),
                      Text(
                        "카카오로 시작",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 17.w,),
            //#. 네이버로 시작하기
            InkWell(
              onTap: () => login(context , SocialProvider.naver),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xff00C53B),
                    borderRadius: BorderRadius.circular(20.r)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( //TODO 네이버 아이콘으로 변경
                        "N",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        "네이버로 시작",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(height: 13.w,),
            //#. 로그인 없이 계속하기
            InkWell(
              onTap: (){},
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 5.w
                ),
                child: Text(
                  "로그인 없이 계속하기",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: const Color(0xfffA4A4A6)
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.w,),
          ],
        ),
      ),
    );
  }
}
