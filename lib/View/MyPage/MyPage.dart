import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/LoginController.dart';
import 'package:homerun/DataDev/DataDevPage.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Service/LoginService.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/View/MyPage/ExtraActionWidget.dart';
import 'package:homerun/View/MyPage/ProfileActionButtonWidget.dart';
import 'package:homerun/View/MyPage/QuestionPage/QuestionPage.dart';
import 'package:homerun/View/MyPage/LoginViewWidget.dart';
import 'package:homerun/View/MyPage/ScrapPage/ScrapPage.dart';
import 'package:homerun/View/MyPage/inquiryPage/inquiryPage.dart';
import 'package:homerun/View/buttom_nav.dart';

import 'BeforeLoginViewWidget.dart';
import 'NotificationPage/NotificationPage.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final LoginController loginController = Get.put(LoginController());

  final double iconSize = 96.w;

  @override
  Widget build(BuildContext context) {
    return DoubleTapExitWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              LoginViewWidget(),
              Divider(
                thickness: 3,
                color: Colors.black,
              ),
              SizedBox(height: 30.h,),
              ExtraActionWidget(
                iconData: Icons.campaign,
                content: "공지사항",
                page: NotificationPage(),
              ),
              ExtraActionWidget(
                iconData: Icons.help_outline,
                content: "자주묻는 질문",
                page: QuestionPage(),
              ),
              ExtraActionWidget(
                iconData: Icons.question_answer,
                content: "문의하기",
                page: InquiryPage(),
              ),
              ExtraActionWidget(
                iconData: Icons.exit_to_app,
                content: "회원탈퇴",
                page: DataDevPage(),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.w , right: 30.w),
                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: TextFormField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Icon(Icons.search), //검색 아이콘 추가
                      contentPadding: EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
                      hintText: '서버 주소'
                  ),
                  onFieldSubmitted: (value){
                    LoginService.instance.firebaseAuthDataSource.setUrl(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                        SnackBar(
                          content: Text('주소 변경 완료 : ${value}'), //snack bar의 내용. icon, button같은것도 가능하다.
                          duration: Duration(milliseconds: 2000), //올라와있는 시간
                          action: SnackBarAction( //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                            label: 'Undo', //버튼이름
                            onPressed: (){}, //버튼 눌렀을때.
                          ),
                        )
                    );
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
