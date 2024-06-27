import 'package:homerun/Common/StaticLogger.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
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
}
