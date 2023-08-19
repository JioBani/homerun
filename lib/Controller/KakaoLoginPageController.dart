import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';

import '../Service/FirebaseAuthRemoteDataSource.dart';

enum LoginState {none , kakaoSuccess, kakaoFail,  firebaseSuccess, firebaseFail  }

class KakaoLoginPageController extends GetxController{
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  Logger logger = Logger();

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

      await Firebase.FirebaseAuth.instance.signInWithCustomToken(customToken);

      return true;
    }catch(e){
      logger.e(e);
      return false;
    }

  }

  Future<bool> logout() async {
    try {
      logger.i("로그아웃");
      await Firebase.FirebaseAuth.instance.signOut();
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