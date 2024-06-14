import 'package:firebase_auth/firebase_auth.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/Auth/KakaoSignInService.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:http/http.dart' as http;

class SignInService{
  static SignInService? _instance;

  SignInService._();

  KakaoSignInService kakaoSignInService = KakaoSignInService();

  static SignInService get instance {
    _instance ??= SignInService._();
    return _instance!;
  }

  Future<bool> loginWithKakao() async {
    try{
      var (Kakao.OAuthToken token , Kakao.User user) = await kakaoSignInService.signIn();

      final String customToken = await getCustomTokenByKakao(user , token.accessToken);

      FirebaseAuth.instance.signInWithCustomToken(customToken);

      StaticLogger.logger.i("로그인 성공");

      return true;
    }
    catch(e){
      StaticLogger.logger.e(e);
      return false;
    }
  }

  Future<String> getCustomTokenByKakao(Kakao.User user , String accessToken) async {
    final customTokenResponse = await http
        .post(Uri.parse("http://10.0.2.2:3000"),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {
          'uid' : user.id.toString(),
          'displayName' : user.kakaoAccount?.name ?? ''
        }
    ).timeout(const Duration(seconds: 10));

    return customTokenResponse.body;
  }
}