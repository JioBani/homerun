import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/main_page_controller.dart';
import 'package:homerun/View/HomePage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

import 'View/GuidePage/guide_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'c16877ed41cb3c133854a81a6ce4e980');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
       builder: (BuildContext context,child) => GetMaterialApp(
         title: 'Flutter Demo',
         theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
           useMaterial3: true,
           appBarTheme: AppBarTheme(
             color: Colors.white
           ),
           bottomNavigationBarTheme: const BottomNavigationBarThemeData(
             backgroundColor: Colors.transparent,
           ),
         ),
         home: HomePage(),
       )
    );
  }
}