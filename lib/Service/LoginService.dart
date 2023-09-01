import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:logger/logger.dart';

import 'FirebaseAuthRemoteDataSource.dart';

enum LoginResult {none , kakaoFail, firebaseFail,  success}
enum LoginState {none , login , logout}

class LoginService {
  static LoginService? _instance;
  Logger logger = Logger();
  final firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  Kakao.User? user;


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
      bool isInstalled = await Kakao.isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          var token = await Kakao.UserApi.instance.loginWithKakaoTalk();
          Logger().i(token.accessToken);
          user = await Kakao.UserApi.instance.me();
          StaticLogger.logger.i(""
              "${user?.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user?.kakaoAccount?.profile?.nickname}");
          return true;
        } catch (e) {
          Logger().e(e);
          return false;
        }
      } else {
        try {
          var token = await Kakao.UserApi.instance.loginWithKakaoAccount();
          Logger().i(token.accessToken);
          user = await Kakao.UserApi.instance.me();
          StaticLogger.logger.i(""
              "${user?.kakaoAccount?.profile?.profileImageUrl} ,"
              "${user?.kakaoAccount?.profile?.nickname}");
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
      var user = await Kakao.UserApi.instance.me();

      if(user == null) return false;

      final customToken = await firebaseAuthDataSource.createCustomToken({
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
      await Kakao.UserApi.instance.unlink();
      user = null;
      return true;
    } catch (error) {
      logger.e(error);
      return false;
    }
  }


  ///카카오 로그인이 되어 있는지 확인
  Future<bool> checkKakaoToken() async{
    if(await Kakao.AuthApi.instance.hasToken()){
      try{
        Kakao.AccessTokenInfo tokenInfo = await Kakao.UserApi.instance.accessTokenInfo();
        logger.i('토큰 확인');
        return true;
      }
      catch(error){
        if (error is Kakao.KakaoException && error.isInvalidTokenError()) {
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

  Future<LoginResult> loginProcess()async{
    if(await checkKakaoToken()){
      if(await firebaseLogin()){
        return LoginResult.success;
      }
      else{
        return LoginResult.firebaseFail;
      }
    }
    else{
      if(await kakaoLogin()){
        if(await firebaseLogin()){
          return LoginResult.success;
        }
        else{
          return LoginResult.firebaseFail;
        }
      }
      else{
        return LoginResult.kakaoFail;
      }
    }
  }

  Future<LoginState> checkLogin()async{
    if(await checkKakaoToken()){
      if(FirebaseAuth.instance.currentUser != null){
        // User 가져오기 임시
        user ??= await Kakao.UserApi.instance.me();
        return LoginState.login;
      }
      else{
        if(await firebaseLogin()){
          return LoginState.logout;
        }
        else{
          return LoginState.logout;
        }
      }
    }
    else{
      return LoginState.logout;
    }
  }

}
