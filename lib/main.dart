import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/MaterialTheme.dart';
import 'package:homerun/View/HomePage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'c16877ed41cb3c133854a81a6ce4e980');


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestoreService.init();

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
           fontFamily: 'BCcard',
           colorScheme: MaterialTheme.lightScheme().toColorScheme()
         ),
         home: HomePage(),
       )
    );
  }
}