import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/View/GuideImagePage/ad_widget.dart';
import 'package:homerun/View/buttom_nav.dart';

class GuideImagePage extends StatelessWidget {
  GuideImagePage({super.key});

  double iconSize = 70.w;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w , bottom: 20.w),
                  child: Text(
                    "청약길잡이",
                    style: TextStyle(
                      fontSize: 40.w,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(
                  children: [
                    SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: IconButton(
                          onPressed: ()=>{},
                          icon: Icon(Icons.arrow_back_ios , size: iconSize),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: IconButton(
                        onPressed: ()=>{},
                        icon: Icon(Icons.star , size: iconSize),
                      ),
                    ),
                    SizedBox(width: 20.w,),
                    SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: IconButton(
                        onPressed: ()=>{},
                        icon: Icon(Icons.copy , size: iconSize),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Image.asset("assets/images/Kaisa_16.jpg"),
                    Image.asset("assets/images/Kaisa_16.jpg"),
                    AdWidget(content: "청약자격진단으로 \n나의 자격 확인해볼까?"),
                    AdWidget(content: "청약홈헌이 작성하는 \n프리미엄 분양 정보"),
                    AdWidget(content: "몇억이 오르는\n구축 매매지 추천"),
                    AdWidget(content: "청약 부럽지 않은\n분양권 매매 추천"),
                  ],
                ),
              )
            ],
          )
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
