import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/Auth/KakaoSignInService.dart';
import 'package:homerun/Service/Auth/NaverSignInService.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:http/http.dart' as http;

enum SignInState{
  signOut,
  signInSuccess,
  signInFailure,
  loading,
}

class SignInService extends GetxService{

  KakaoSignInService kakaoSignInService = KakaoSignInService();
  NaverSignInService naverSignInService = NaverSignInService();

  Rx<UserDto?> userDto = Rx(null);
  Rx<DocumentSnapshot?> userSnapshot = Rx(null);
  StreamSubscription<DocumentSnapshot>? userSubscription;
  Rx<SignInState> signInState = Rx(SignInState.signOut);

  Future<bool> signIn(SocialProvider socialProvider) async {
    try{
      signInState.value = SignInState.loading;

      //#1. 소셜로그인
      //#2. 커스텀 토큰 가져오기

      final String customToken;

      if(socialProvider == SocialProvider.kakao){
        var (kakao.OAuthToken token , kakao.User user) = await kakaoSignInService.signIn();
        customToken = await getCustomTokenByKakao(user , token.accessToken);
      }
      else if(socialProvider == SocialProvider.naver){
        NaverLoginResult naverLoginResult = await naverSignInService.signIn();
        customToken = await getCustomTokenByNaver(naverLoginResult);
      }
      else{
        throw Exception('알 수 없는 로그인 요청');
      }

      //#3. 커스텀 토큰으로 firebase 로그인
      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      //#4. 유저 정보 가져오기
      await listenUserSnapshot();

      StaticLogger.logger.i('[SignInService.signIn()] 로그인 성공 ');
      signInState.value = SignInState.signInSuccess;
      return true;

    }catch(e,s){
      StaticLogger.logger.e('[SignInService.signIn()] 로그인에 실패하였습니다. : $e');
      StaticLogger.logger.e('[SignInService.signIn()] $s');
      signInState.value = SignInState.signInFailure;
      return false;
    }
  }

  Future<bool> signOut(SocialProvider socialProvider) async {
    try {
      signInState.value = SignInState.loading;

      // #1. Firebase에서 로그아웃
      await FirebaseAuth.instance.signOut();

      // #2. Kakao 로그아웃
      if (socialProvider == SocialProvider.kakao) {
        await kakao.UserApi.instance.logout();
      }
      // #3. Naver 로그아웃
      else if (socialProvider == SocialProvider.naver) {
        await FlutterNaverLogin.logOut();
      }

      // #4. 유저 상태 초기화
      userDto.value = null;
      userSnapshot.value = null;
      userSubscription?.cancel();

      signInState.value = SignInState.signOut;
      StaticLogger.logger.i('[SignInService.signOut()] 로그아웃 성공');
      return true;
    } catch (e, s) {
      StaticLogger.logger.e('[SignInService.signOut()] 로그아웃에 실패하였습니다: $e');
      StaticLogger.logger.e('[SignInService.signOut()] $s');
      signInState.value = SignInState.signOut;
      return false;
    }
  }


  Future<String?> checkKakaoAccessToken() async {
    if(await kakao.AuthApi.instance.hasToken()){
      try {
        kakao.AccessTokenInfo tokenInfo = await kakao.UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        return (await kakao.TokenManagerProvider.instance.manager.getToken())?.accessToken;
      } catch (error) {
        if (error is kakao.KakaoException && error.isInvalidTokenError()) {
          StaticLogger.logger.e("토큰 만료");
          return null;
        } else {
          StaticLogger.logger.e("토큰 정보 확인 실패");
          return null;
        }
      }
    }
    else{
      StaticLogger.logger.e("토큰 없음");
      return null;
    }
  }

  Future<String> getCustomTokenByKakao(kakao.User user , String accessToken) async {
    final customTokenResponse = await http
        .post(Uri.parse("http://10.0.2.2:3000/auth"),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {
          'uid' : user.id.toString(),
          'displayName' : user.kakaoAccount?.name ?? ''
        }
    ).timeout(const Duration(seconds: 10));

    return customTokenResponse.body;
  }

  Future<String> getCustomTokenByNaver(NaverLoginResult naverLoginResult) async {
    StaticLogger.logger.i(naverLoginResult.accessToken.accessToken);
    NaverAccessToken accessToken = await FlutterNaverLogin.currentAccessToken;
    final customTokenResponse = await http
        .post(Uri.parse("http://10.0.2.2:3000/auth"),
        headers: {'Authorization': 'Bearer ${accessToken.accessToken}'},
        body: {
          'uid' : naverLoginResult.account.id.toString(),
          'displayName' : naverLoginResult.account.name
        }
    ).timeout(const Duration(seconds: 10));

    return customTokenResponse.body;
  }

  Future<bool> listenUserSnapshot() async{
    try{
      if(FirebaseAuth.instance.currentUser == null){
        StaticLogger.logger.e("[SignInService.getUserDocumentSnashotStream()] 로그인이 필요합니다");
        return false;
      }
      else{
        String uid = FirebaseAuth.instance.currentUser!.uid;

        userSnapshot.value = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        userDto.value = UserDto.fromMap(userSnapshot.value!.data() as Map<String, dynamic>);

        userSubscription?.cancel();

        userSubscription = FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((event) {
          userSnapshot.value = event;
          userDto.value = UserDto.fromMap(event.data() as Map<String, dynamic>);
          StaticLogger.logger.i('[listenUserSnapshot()] 유저 정보 변경됨.');
        });

        return true;
      }
    }catch(e){
      StaticLogger.logger.e("[SignInService.getUserDocumentSnashotStream()] 오류가 발생했습니다. : $e");
      return false;
    }
  }
}