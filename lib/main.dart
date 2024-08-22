import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Service/NaverGeocodeService/NaverGeocodeService.dart';
import 'package:homerun/Service/NaverGeocodeService/ServiceKey.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/MaterialTheme.dart';
import 'package:homerun/View/HomePage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/config/.env');

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'],
    onAuthFailed: (ex) {
      StaticLogger.logger.e("[main] 네이버 맵 인증 오류 : $ex");
    }
  );

  try{
    NaverGeocodeService.instance.init(
        dotenv.env['NAVER_MAP_CLIENT_ID']!,
        dotenv.env['NAVER_MAP_CLIENT_SECRET']!
    );
  }catch(e){
    StaticLogger.logger.e("NaverGeocodeService 초기화 실패 : $e");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestoreService.init();
  Get.put(AuthService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize;

    screenSize =  const Size(360, 800);

    return ScreenUtilInit(
      designSize: screenSize,
       builder: (BuildContext context,child) => GetMaterialApp(
         theme: ThemeData(
           fontFamily: Fonts.content,
           colorScheme: MaterialTheme.lightScheme().toColorScheme()
         ),
         home: HomePage(),
       )
    );
  }
}