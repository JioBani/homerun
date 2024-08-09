import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Common/ApiResponse/ApiResponse.dart';
import 'package:homerun/Service/Auth/HttpError.dart';
import 'package:homerun/Service/Auth/KakaoLoginService.dart';
import 'package:homerun/Service/Auth/NaverLoginService.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:http/http.dart' as http;

class AuthServiceException implements Exception{
  String message;

  AuthServiceException(this.message);
}

class ApplicationUnauthorizedException extends AuthServiceException{
  ApplicationUnauthorizedException()
      : super('Application is not logged in.');
}

class UnknownUserInfoException extends AuthServiceException{
  UnknownUserInfoException({String message = 'Unknown user info.'})
      : super(message);
}


enum SignInState{
  signOut,
  signInSuccess,
  signInFailure,
  loading,
}

enum SignInResult{
  socialLoginFailure,
  getCustomTokenFailure,
  userNotFoundFailure,
  signInWithCustomTokenFailure,
  success,
}

class AuthService extends GetxService{

  KakaoLoginService kakaoLoginService = KakaoLoginService();
  NaverLoginService naverLoginService = NaverLoginService();

  Rx<UserDto?> userDto = Rx(null);
  Rx<DocumentSnapshot?> userSnapshot = Rx(null);
  StreamSubscription<DocumentSnapshot>? userSubscription;
  Rx<SignInState> signInState = Rx(SignInState.signOut);

  Future<SignInResult> signIn(SocialProvider socialProvider) async {
    signInState.value = SignInState.loading;

    //#1. 소셜로그인
    //#2. 커스텀 토큰 가져오기

    final String customToken;

    //#. signInWithSocialProvider

    late final ApiResponse<String> tokenResponse;

    if(socialProvider == SocialProvider.kakao){
      try{
        var (kakao.OAuthToken token , kakao.User user) = await kakaoLoginService.signIn();
        tokenResponse = await _getCustomToken(socialProvider, token.accessToken);
      }catch(e){
        signInState.value = SignInState.signInFailure;
        return SignInResult.socialLoginFailure;
        //TODO 로그인 실패 예외처리
      }
    }
    else if(socialProvider == SocialProvider.naver){
      NaverLoginResult naverLoginResult = await naverLoginService.signIn();
      if(naverLoginResult.status != NaverLoginStatus.loggedIn){
        signInState.value = SignInState.signInFailure;
        return SignInResult.socialLoginFailure;
        //TODO 로그인 실패 예외처리
      }

      NaverAccessToken accessToken = await FlutterNaverLogin.currentAccessToken;
      tokenResponse = await _getCustomToken(socialProvider, accessToken.accessToken);
    }
    else{
      throw Exception('알 수 없는 로그인 요청');
    }

    //#. 로그인 결과 해석
    if(tokenResponse.status != 200){
      signInState.value = SignInState.signInFailure;
      StaticLogger.logger.e("[AuthService.signIn()] ${tokenResponse.error?.message}");
      if(tokenResponse.error != null && tokenResponse.error!.code == ServerErrorCodes.userNotFoundError){
        return SignInResult.userNotFoundFailure;
      }
      else{
        return SignInResult.getCustomTokenFailure;
      }
    }
    else{
      customToken = tokenResponse.data!;
    }


    //#3. 커스텀 토큰으로 firebase 로그인
    try{
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
    }catch(e,s){
      StaticLogger.logger.e("[AuthService.signIn()] $e\n$s");
      signInState.value = SignInState.signInFailure;
      return SignInResult.userNotFoundFailure;
    }

    //#4. 유저 정보 가져오기
    await listenUserSnapshot();

    StaticLogger.logger.i('[SignInService.signIn()] 로그인 성공 ');
    signInState.value = SignInState.signInSuccess;
    return SignInResult.success;
  }

  Future<ApiResponse<String?>> signUp({
    required SocialProvider socialProvider,
    required String accessToken,
    required String displayName,
    required String birth,
    required Gender gender,
  }) async {
    //TODO 파라미터 Fields로 변경
    final customTokenResponse = await http.post(Uri.parse(FirebaseFunctionEndpoints.signUp),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {
          'social_provider' : socialProvider.toEnumString(),
          'displayName' : displayName,
          'birth' :birth,
          'gender': gender.toEnumString(),
        }
    ).timeout(const Duration(seconds: 10));

    return ApiResponse<String?>.fromMap(jsonDecode(customTokenResponse.body));
  }

  Future<ApiResponse<String>> _getCustomToken(SocialProvider socialProvider , String accessToken) async {
    //String url = "http://10.0.2.2:3000/auth";
    final customTokenResponse = await http.post(Uri.parse(FirebaseFunctionEndpoints.signIn),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {'social_provider' : socialProvider.toEnumString()}
    ).timeout(const Duration(seconds: 10));

    return ApiResponse<String>.fromMap(jsonDecode(customTokenResponse.body));
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

  Future<ApiResponse<String>> getCustomTokenByKakao(kakao.User user , String accessToken) async {
    //String url = "http://10.0.2.2:3000/auth";
    final customTokenResponse = await http.post(Uri.parse(FirebaseFunctionEndpoints.signIn),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {'social_provider' : SocialProvider.kakao.toEnumString()}
    ).timeout(const Duration(seconds: 10));

    return ApiResponse<String>.fromMap(jsonDecode(customTokenResponse.body));
  }

  Future<ApiResponse<String>> getCustomTokenByNaver(NaverLoginResult naverLoginResult) async {
    //String url = "http://10.0.2.2:3000/auth";

    NaverAccessToken accessToken = await FlutterNaverLogin.currentAccessToken;
    final customTokenResponse = await http
        .post(Uri.parse(FirebaseFunctionEndpoints.signIn),
        headers: {'Authorization': 'Bearer ${accessToken.accessToken}'},
        body: {'social_provider' : SocialProvider.naver.toEnumString()}
    ).timeout(const Duration(seconds: 10));

    return ApiResponse<String>.fromMap(jsonDecode(customTokenResponse.body));
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
    }catch(e , s){
      StaticLogger.logger.e("[SignInService.getUserDocumentSnashotStream()] 오류가 발생했습니다. : $e , $s");
      return false;
    }
  }

  Future<String> getKakaoAccessToken() async {
    var (kakao.OAuthToken token , kakao.User user) = await kakaoLoginService.signIn();
    return token.accessToken;
  }

  Future<String> getNaverAccessToken() async {
    NaverLoginResult naverLoginResult = await naverLoginService.signIn();
    return (await FlutterNaverLogin.currentAccessToken).accessToken;
  }

  UserDto getUser(){
    if(FirebaseAuth.instance.currentUser == null || userDto.value == null){
      throw ApplicationUnauthorizedException();
    }
    else{
      return userDto.value!;
    }
  }

  UserDto? tryGetUser(){
    return userDto.value;
  }
}