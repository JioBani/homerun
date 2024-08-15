import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/ApiResponse/ApiResult.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/enum/Gender.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Security/FirebaseFunctionEndpoints.dart';
import 'package:homerun/Service/Auth/HttpError.dart';
import 'package:homerun/Service/Auth/KakaoLoginService.dart';
import 'package:homerun/Service/Auth/NaverLoginService.dart';
import 'package:homerun/Service/Auth/SocialLoginService.dart';
import 'package:homerun/Service/Auth/SocialProvider.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:http/http.dart' as http;


class AuthService extends GetxService{

  KakaoLoginService kakaoLoginService = KakaoLoginService();
  NaverLoginService naverLoginService = NaverLoginService();
  
  late Map<SocialProvider , SocialLoginService> loginServices = {
    SocialProvider.kakao : kakaoLoginService,
    SocialProvider.naver : naverLoginService,
  };

  Rx<UserDto?> userDto = Rx(null);
  Rx<DocumentSnapshot?> userSnapshot = Rx(null);
  StreamSubscription<DocumentSnapshot>? userSubscription;
  Rx<SignInState> signInState = Rx(SignInState.signOut);

  /// 최근 로그인한 소셜 프로바이더
  SocialProvider? currentLoginProvider;

  /// 소셜 로그인
  Future<Result> socialLogin(SocialProvider socialProvider) async {
    Result loginResult = await loginServices[socialProvider]!.login();

    if(loginResult.isSuccess){
      currentLoginProvider = socialProvider;
    }

    return loginResult;
  }

  /// 서버로부터 커스텀 토큰 가져오기
  Future<ApiResult<String>> _getCustomToken(SocialProvider socialProvider , String accessToken) =>
      ApiResult.handleRequest<String>(http.post(Uri.parse(FirebaseFunctionEndpoints.signIn),
          headers: {'Authorization': 'Bearer $accessToken'},
          body: {'social_provider' : socialProvider.toEnumString()}
      ), timeout: const Duration(minutes: 1));

  /// 파이어베이스 로그인
  Future<FirebaseLoginResult> firebaseLogin() async {
    //#. 현재 로그인 된 소셜프로바이더가 있는지 확인
    if(currentLoginProvider == null){
      return FirebaseLoginResult.currentLoginDoNotExistFailure;
    }

    SocialLoginService loginService = loginServices[currentLoginProvider]!;

    //#. 엑세스 토큰 가져오기
    Result<String> accessTokenResult = await loginService.getAccessToken();

    //#. 엑세스 토큰 성공 여부 확인
    if(!accessTokenResult.isSuccess){
      return FirebaseLoginResult.accessTokenFailure;
    }

    //#. 커스텈 토큰 가져오기
    ApiResult tokenResult = await _getCustomToken(currentLoginProvider! , accessTokenResult.content!);

    //#. 커스텀 토큰 응답 객체 해석
    if(!tokenResult.isSuccess){
      if(!tokenResult.parsingFailed){
        if(tokenResult.apiResponse!.error!.code == ServerErrorCodes.userNotFoundError){
          return FirebaseLoginResult.userDoNotExistFailure;
        }
      }

      return FirebaseLoginResult.getCustomTokenFailure;
    }

    String customToken = tokenResult.apiResponse!.data!;

    //#. 커스텀 토큰으로 파이어베이스에 로그인
    try{
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      return FirebaseLoginResult.success;
    }catch(e,s){
      StaticLogger.logger.e("[AuthService.firebaseLogin()] $e\n$s");
      return FirebaseLoginResult.signInFailure;
    }
  }

  /// 로그인
  Future<LoginResult> login(SocialProvider socialProvider) async {
    //#1. 소셜로그인
    Result socialLoginResult = await socialLogin(socialProvider);

    //#1.1. 예외처리
    if(!socialLoginResult.isSuccess){
      return LoginResult.socialLoginFailure;
    }

    //#2. 파이어베이스 로그인
    FirebaseLoginResult firebaseLoginResult = await firebaseLogin();

    //#2.1 예외처리
    if(firebaseLoginResult == FirebaseLoginResult.success){
      //#. 유저 정보 가져오기
      await listenUserSnapshot();

      return LoginResult.success;
    }
    else if(firebaseLoginResult == FirebaseLoginResult.userDoNotExistFailure){
      //#. 유저가 없어서 실패한 경우
      return LoginResult.userDoNotExistFailure;
    }
    else{
      //#. 그 이외
      return LoginResult.firebaseLoginFailure;
    }
  }

  /// 로그아웃
  Future<bool> logout() async {
    try {
      signInState.value = SignInState.loading;

      //#1. Firebase에서 로그아웃
      await FirebaseAuth.instance.signOut();

      //#2. 소셜 로그아웃
      if(currentLoginProvider != null){
        await loginServices[currentLoginProvider]!.logout();
        currentLoginProvider = null;
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

  /// 회원가입
  //TODO 지역하고 연령대 values로 수정하기
  Future<SignUpResult> signUp({
    required String displayName,
    required Gender gender,
    required String ageRages,
    required List<String> regions,
  })async{

    //#. 소셜 로그인 체크
    if(currentLoginProvider == null){
      return SignUpResult.currentLoginDoNotExistFailure;
    }

    //#. 엑세스 토큰 가져오기
    Result accessTokenResult = await loginServices[currentLoginProvider]!.getAccessToken();

    if(!accessTokenResult.isSuccess){
      return SignUpResult.accessTokenFailure;
    }

    //#. 회원가입
    final ApiResult<String> apiResult = await ApiResult.handleRequest<String>(
      http.post(Uri.parse(FirebaseFunctionEndpoints.signUp),
        headers: {
          'Authorization': 'Bearer ${accessTokenResult.content}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'social_provider' : currentLoginProvider!.toEnumString(),
          'displayName' : displayName,
          'gender': gender.toEnumString(),
          'ageRange': ageRages,
          'interestedRegions': regions,
        })
      ),
      timeout: const Duration(minutes: 1)
    );

    //#. 회원가입 결과 해석
    if(!apiResult.isSuccess){
      if(!apiResult.parsingFailed && apiResult.apiResponse!.error!.code == ServerErrorCodes.userAlreadyExistsError){
        return SignUpResult.userAlreadyExistsFailure;
      }
      else if(apiResult.parsingFailed){
        StaticLogger.logger.e("${apiResult.error}\n${apiResult.stackTrace}");
        return SignUpResult.serverSignUpFailure;
      }
      else{
        StaticLogger.logger.e(apiResult.apiResponse?.error?.message);
        return SignUpResult.serverSignUpFailure;
      }
    }

    //#2. 파이어베이스 로그인
    final String customToken = apiResult.apiResponse!.data!;

    try{
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      StaticLogger.logger.i("[AuthService.signUp()] 성공");
      return SignUpResult.success;
    }catch(e,s){
      StaticLogger.logger.e("[AuthService.signUp()] $e\n$s");
      return SignUpResult.firebaseLoginFailure;
    }
  }

  /// 유저 데이터 가져오기
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

  /// 로그인을 체크하면서 실행하기
  ///
  /// [action] : 실행할 코드. 만약 [afterLoggedIn]이 null이 아니라면 로그인 후에 실행 되지 않습니다.
  ///
  /// [afterLoggedIn] : 로그인이 필요한 경우, 로그인 후에 실행할 코드. 로그인 후 [action] 대신 실행됩니다.
  static runWithAuthCheck(
    Function action,
    {Function? afterLoggedIn,}
  ){
    if(FirebaseAuth.instance.currentUser == null){

      Get.to(const LoginPage())?.then((value){
        if(afterLoggedIn != null){
          afterLoggedIn();
        }
        else{
          action();
        }
      });

      return false;
    }
    else{
      action();
      return true;
    }
  }
}

enum FirebaseLoginResult{
  success,
  currentLoginDoNotExistFailure,
  accessTokenFailure,
  getCustomTokenFailure,
  userDoNotExistFailure,
  signInFailure
}

enum LoginResult{
  socialLoginFailure,
  firebaseLoginFailure,
  userDoNotExistFailure,
  success,
}

//TODO 오류추적을 위해 객체를 만들지
enum SignUpResult{
  success,
  currentLoginDoNotExistFailure,
  accessTokenFailure,
  userAlreadyExistsFailure,
  serverSignUpFailure,
  firebaseLoginFailure,
}

enum SignInState {
  signOut,
  signInSuccess,
  signInFailure,
  loading,
}

class AuthServiceException implements Exception{
  String message;

  AuthServiceException(this.message);
}

class ApplicationUnauthorizedException extends AuthServiceException{
  ApplicationUnauthorizedException()
      : super('Application is not logged in.');
}

class CurrentLoginNotExistException extends AuthServiceException{
  CurrentLoginNotExistException()
      : super('Current social login is not exist.');
}

class UnknownUserInfoException extends AuthServiceException{
  UnknownUserInfoException({String message = 'Unknown user info.'})
      : super(message);
}


