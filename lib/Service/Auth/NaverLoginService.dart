import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

import 'SocialLoginService.dart';


class NaverLoginService implements SocialLoginService{
  @override
  Future<Result<void>> login() async {
    return Result.handleFuture<void>(
        timeout: const Duration(minutes: 10),
        action: () async {
          NaverLoginResult result = await FlutterNaverLogin.logIn();
          if(result.status == NaverLoginStatus.error){
            throw LoginFailureException(result.errorMessage);
          }
          else if(result.status == NaverLoginStatus.cancelledByUser){
            throw LoginCancelException();
          }
        }
    );
  }

  @override
  Future<void> logout() async {
    try{
      await FlutterNaverLogin.logOut();
    }catch(e,s){
      StaticLogger.logger.i("[NaverLoginService.logout()] 로그아웃 실패 : $e\n$s");
    }
  }

  @override
  Future<Result<String>> getAccessToken() async{
    return Result.handleFuture<String>(
        timeout: const Duration(seconds: 30),
        action: ()async{
          return (await FlutterNaverLogin.currentAccessToken).accessToken;
        }
    );
  }


}

