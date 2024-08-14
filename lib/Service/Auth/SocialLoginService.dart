import 'package:homerun/Common/model/Result.dart';

abstract class SocialLoginService{

    ///로그인
    Future<Result<void>> login();

    ///로그아웃
    Future<void> logout();

    ///엑세스 토큰 얻기
    Future<Result<String>> getAccessToken();

}

class SocialLoginServiceException implements Exception{
    String message;

    SocialLoginServiceException(this.message);
}

/// getAccessToken에서 소셜로그인이 되어있지 않을때
class SocialServiceUnauthorizedException extends SocialLoginServiceException{
    SocialServiceUnauthorizedException()
        : super('Social service is not logged in.');
}

/// 소셜로그인이 실패 했을때
class LoginFailureException extends SocialLoginServiceException{
    LoginFailureException(String msg)
        : super('Social login fail : $msg');
}

/// 사용자가 로그인을 취소했을때
class LoginCancelException extends SocialLoginServiceException{
    LoginCancelException()
        : super('로그인을 취소하였습니다.');
}


