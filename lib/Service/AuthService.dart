// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:homerun/Common/StaticLogger.dart';
// import 'package:homerun/Service/Auth/KakaoLoginService.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
// import 'package:http/http.dart' as http;
//
// class AuthService{
//   static AuthService? _instance;
//
//   AuthService._();
//
//   static AuthService get instance {
//     _instance ??= AuthService._();
//     return _instance!;
//   }
//
//   Future<(Kakao.OAuthToken , Kakao.User)> _kakaoLogin() async {
//     try {
//       bool isInstalled = await Kakao.isKakaoTalkInstalled();
//       if (isInstalled) {
//         try {
//           var token = await Kakao.UserApi.instance.loginWithKakaoTalk();
//           var user = await Kakao.UserApi.instance.me();
//           StaticLogger.logger.i(""
//               "${user.kakaoAccount?.profile?.profileImageUrl} ,"
//               "${user.kakaoAccount?.profile?.nickname}");
//           return (token , user);
//         } catch (e) {
//           StaticLogger.logger.e(e);
//           rethrow;
//         }
//       } else {
//         try {
//           var token = await Kakao.UserApi.instance.loginWithKakaoAccount();
//           var user = await Kakao.UserApi.instance.me();
//           StaticLogger.logger.i(""
//               "${user.kakaoAccount?.profile?.profileImageUrl} ,"
//               "${user.kakaoAccount?.profile?.nickname}");
//           return (token , user);
//         } catch (e) {
//           StaticLogger.logger.e(e);
//           StaticLogger.logger.e(e);
//           rethrow;
//         }
//       }
//     } catch (e) {
//       StaticLogger.logger.e(e);
//       rethrow;
//     }
//   }
//
//   Future<bool> loginWithKakao() async {
//     try{
//       KakaoSignInService kakaoLoginService = KakaoSignInService();
//
//       var (Kakao.OAuthToken token , Kakao.User user) = await _kakaoLogin();
//
//       final String customToken = await createCustomTokenByKakao(user , token.accessToken);
//
//       StaticLogger.logger.i(customToken);
//
//       FirebaseAuth.instance.signInWithCustomToken(customToken);
//
//       StaticLogger.logger.i("로그인 성공");
//
//       return true;
//     }
//     catch(e){
//       StaticLogger.logger.e(e);
//       return false;
//     }
//   }
//
//   Future<String> createCustomTokenByKakao(Kakao.User user , String accessToken) async {
//     final customTokenResponse = await http
//         .post(Uri.parse("http://10.0.2.2:3000"),
//         headers: {'Authorization': 'Bearer $accessToken'},
//         body: {
//           'uid' : user.id.toString(),
//           'displayName' : user.kakaoAccount?.name ?? ''
//         }
//     ).timeout(const Duration(seconds: 10));
//
//     return customTokenResponse.body;
//   }
// }