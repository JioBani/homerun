import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/LoginController.dart';
import 'package:homerun/Service/Auth/SignInService.dart';
import 'package:homerun/Service/LoginService.dart';
import 'package:homerun/View/MyPage/AfterLoginViewWidget.dart';
import 'package:homerun/View/MyPage/BeforeLoginViewWidget.dart';

class LoginViewWidget extends StatefulWidget {
  const LoginViewWidget({super.key});

  @override
  State<LoginViewWidget> createState() => _LoginViewWidgetState();
}

class _LoginViewWidgetState extends State<LoginViewWidget> {

  LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.checkLogin(),
      builder: (context , snapshot){
        if(snapshot.hasData){
          return GetX<SignInService>(
            builder: (service){
              if(service.signInState.value == SignInState.signOut){
                return TextButton(onPressed: (){service.signIn(AuthType.kakao);}, child: Text('로그인'));
              }
              else if(service.signInState.value == SignInState.loading){
                return CupertinoActivityIndicator();
              }
              else if(service.signInState.value == SignInState.signInSuccess){
                return Text(service.userDto.value?.toMap().toString() ?? '유저데이터를 가져 올 수 없습니다.');
              }
              else{
                return Column(
                  children: [
                    Text('로그인에 실패했습니다.'),
                    TextButton(onPressed: (){service.signIn(AuthType.kakao);}, child: Text('로그인'))
                  ],
                );
              }
            },
          ) ;
        }
        else if(snapshot.hasError){
          return BeforeLoginViewWidget();
        }
        else{
          return SizedBox(
            width: double.infinity,
            height: 200.h,
            child: CircularProgressIndicator()
          );
        }
      },
    );


    return GetX<LoginController>(
      builder: (controller) {
        return FutureBuilder(
          future: controller.checkLogin(),
          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data! == LoginState.logout){
                return BeforeLoginViewWidget();
              }
              else{
                return Column(
                  children: [
                    AfterLoginViewWidget(),
                    ElevatedButton(
                        onPressed: (){
                          LoginService.instance.logout();
                          setState(() {

                          });
                        },
                        child: Text("로그아웃")
                    ),
                  ],
                );
              }
            }
            else if(snapshot.hasError){
              StaticLogger.logger.e(snapshot.error);
              return BeforeLoginViewWidget();
            }
            else{
              return CircularProgressIndicator();
            }
          }
        );
      }
    );
  }
}
