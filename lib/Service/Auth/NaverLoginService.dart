import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:homerun/Common/StaticLogger.dart';

class NaverLoginService{
  Future<NaverLoginResult> signIn() async {
    try{
      NaverLoginResult _result = await FlutterNaverLogin.logIn();
      StaticLogger.logger.i("[NaverSignInService.signIn()] 로그인 성공 (id = ${_result.account.id})");
      return _result;
    }catch(e,s){
      StaticLogger.logger.e('[NaverSignInService.signIn()] $e\n$s');
      rethrow;
    }
  }
}