import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/SocialLoginService.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService implements SocialLoginService{
  //TODO 소셜로그인 서비스의 예외 객체를 사용할지 결정
  OAuthToken? oAuthToken;
  User? user;

  @override
  Future<Result<void>> login() async {
    return Result.handleFuture<void>(
      timeout: const Duration(minutes: 10),
      action: () async {
        //#. 카카오 설치 체크
        bool isInstalled = await isKakaoTalkInstalled();

        if (isInstalled) { //#. 설치된 경우

          //#. 카카오톡으로부터 로그인
          var token = await UserApi.instance.loginWithKakaoTalk();
          var user = await UserApi.instance.me();

          StaticLogger.logger.i(
              "${user.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user.kakaoAccount?.profile?.nickname}"
          );

          //#. 로그인 결과 저장
          oAuthToken = token;
          this.user = user;
        } else { //#. 설치되지 않은 경우

          //#. 아이디로 로그인
          var token = await UserApi.instance.loginWithKakaoAccount();
          var user = await UserApi.instance.me();

          StaticLogger.logger.i(
              "${user.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user.kakaoAccount?.profile?.nickname}"
          );

          //#. 로그인 결과 저장
          oAuthToken = token;
          this.user = user;
        }
      }
    );
  }

  @override
  Future<void> logout() async {
    try{
      await UserApi.instance.logout();
    }catch(e,s){
      StaticLogger.logger.i("[KakaoLoginService.logout()] 로그아웃 실패 : $e\n$s");
    }
  }

  @override
  Future<Result<String>> getAccessToken() async{
    return Result.handleFuture<String>(
      timeout: const Duration(seconds: 30),
      action: ()async{
        if(oAuthToken == null){
          throw SocialServiceUnauthorizedException();
        }
        else{
          return oAuthToken!.accessToken;
        }
      }
    );
  }


}
