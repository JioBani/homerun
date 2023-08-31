import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/LoginController.dart';
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
          return GetX<LoginController>(
            builder: (getxController){
              if(getxController.loginState.value == LoginState.login){
                return AfterLoginViewWidget();
              }
              else{
                return BeforeLoginViewWidget();
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
            height: 600.h,
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
