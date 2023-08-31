import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/KakaoLoginPageController.dart';
import 'package:homerun/Service/LoginService.dart';
import 'package:homerun/View/buttom_nav.dart';


class KakaoLoginPage extends StatefulWidget {
  const KakaoLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<KakaoLoginPage> createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  final KakaoLoginPageController kakaoLoginPageController = Get.put(KakaoLoginPageController());


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child:Column(
            children: [
              Builder(
                  builder: (context){
                    if(FirebaseAuth.instance.currentUser != null){
                      return ElevatedButton(
                        onPressed: () async {
                          await LoginService.instance.logout();
                          setState(() {});
                        },
                        child: Text("로그아웃"),
                      );
                    }
                    else{
                      return FutureBuilder(
                        future: LoginService.instance.checkKakaoToken(),
                          builder: (context , snapshot){
                            if(snapshot.hasData){
                              if(snapshot.data! == true && FirebaseAuth.instance.currentUser != null){
                                return ElevatedButton(
                                  onPressed: () async {
                                    await LoginService.instance.logout();
                                    setState(() {});
                                  },
                                  child: Text("로그아웃"),
                                );
                              }
                              else{
                                return ElevatedButton(
                                  onPressed: () async {
                                    await LoginService.instance.login();
                                    setState(() {});
                                  },
                                  child: Text("로그인"),
                                );
                              }
                            }
                            else if(snapshot.hasError){
                              return Text(snapshot.error.toString());
                            }
                            else{
                              return CircularProgressIndicator();
                            }
                          }
                      );
                    }
                  }
              ),
            ],
          )
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
