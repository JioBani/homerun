import 'package:homerun/Common/StaticLogger.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoSignInService {
  Future<(OAuthToken, User)> signIn() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          var token = await UserApi.instance.loginWithKakaoTalk();
          var user = await UserApi.instance.me();
          StaticLogger.logger.i(""
              "${user.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user.kakaoAccount?.profile?.nickname}");
          return (token, user);
        } catch (e) {
          StaticLogger.logger.e(e);
          rethrow;
        }
      } else {
        try {
          var token = await UserApi.instance.loginWithKakaoAccount();
          var user = await UserApi.instance.me();
          StaticLogger.logger.i(""
              "${user.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user.kakaoAccount?.profile?.nickname}");
          return (token, user);
        } catch (e) {
          StaticLogger.logger.e(e);
          StaticLogger.logger.e(e);
          rethrow;
        }
      }
    } catch (e) {
      StaticLogger.logger.e(e);
      rethrow;
    }
  }

  Future<bool> checkSignIn() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        return true;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
        return false;
      }
    } else {
      print('발급된 토큰 없음');
      return false;
    }
  }
}
