import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/LoginController.dart';
import 'package:homerun/Service/LoginService.dart';

class BeforeLoginViewWidget extends StatefulWidget {
  const BeforeLoginViewWidget({super.key});

  @override
  State<BeforeLoginViewWidget> createState() => _BeforeLoginViewWidgetState();
}

class _BeforeLoginViewWidgetState extends State<BeforeLoginViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: Column(
        children: [
          GetX<LoginController>(
              builder: (controller) {
                if(controller.loginProcessState.value == LoginProcessState.inLoginProcess){
                  return CircularProgressIndicator();
                }
                else{
                  return ElevatedButton(
                      onPressed: (){
                        controller.login().then((value){
                          ScaffoldMessenger.of(context).showSnackBar(
                            //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                              SnackBar(
                                content: Text('${value}'), //snack bar의 내용. icon, button같은것도 가능하다.
                                duration: Duration(milliseconds: 2000), //올라와있는 시간
                              )
                          );
                          setState(() {
                            StaticLogger.logger.i(value);
                          });
                        });
                      },
                      child: Text("로그인")
                  );
                }
              }
            ),
        ],
      )
    );
  }
}
