import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';

import 'FirebaseAuthRemoteDataSource.dart';

class LoginService {
  static LoginService? _instance;
  Logger logger = Logger();
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();

  LoginService._();

  static LoginService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= LoginService._();
    return _instance!;
  }


  Future<bool> login()async{
    if(await kakaoLogin()){
      return await firebaseLogin();
    }
    else{
      logger.e("카카오 로그인 실패");
      return false;
    }
  }

  Future<bool> kakaoLogin() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          var token = await UserApi.instance.loginWithKakaoTalk();
          Logger().i(token.accessToken);
          return true;
        } catch (e) {
          Logger().e(e);
          return false;
        }
      } else {
        try {
          var token = await UserApi.instance.loginWithKakaoAccount();
          Logger().i(token.accessToken);
          return true;
        } catch (e) {
          Logger().e(e);
          return false;
        }
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<bool> firebaseLogin() async{
    try{
      var user = await UserApi.instance.me();

      if(user == null) return false;

      final customToken = await _firebaseAuthDataSource.createCustomToken({
        'uid' : user!.id.toString(),
        'displayName' : user!.kakaoAccount!.profile!.nickname
      });

      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      return true;
    }catch(e){
      logger.e(e);
      return false;
    }

  }

  Future<bool> logout() async {
    try {
      logger.i("로그아웃");
      await FirebaseAuth.instance.signOut();
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      logger.e(error);
      return false;
    }
  }


  ///카카오 로그인이 되어 있는지 확인
  Future<bool> checkToken() async{
    if(await AuthApi.instance.hasToken()){
      try{
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        logger.i('토큰 확인');
        return true;
      }
      catch(error){
        if (error is KakaoException && error.isInvalidTokenError()) {
          logger.e('토큰 만료 $error');
        } else {
          logger.e('토큰 정보 조회 실패 $error');
        }

        return false;
      }
    }
    else{
      logger.e('발급된 토큰 없음');
      return false;
    }
  }
}
