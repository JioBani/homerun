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
      height: 600.h,
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
                        controller.login().then((value) => {
                          setState(() {
                            StaticLogger.logger.i(value);
                          })
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
