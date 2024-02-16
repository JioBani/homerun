import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/main_page_controller.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/View/HomePage/basic_guide_widge.dart';
import 'package:homerun/View/HomePage/extra_guide_widget.dart';
import 'package:homerun/View/HomePage/search_bar_widget.dart';
import 'package:homerun/View/buttom_nav.dart';
import '../../Palette.dart';
import 'image_builder_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final MainPageController mainPageController = Get.put( MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("청약홈런",
                    style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(),
                  ),
                  IconButton(
                    onPressed: () {
                      // 아이콘을 눌렀을 때의 동작을 추가할 수 있습니다.
                    },
                    icon: Icon(Icons.person_search),
                  ),
                  IconButton(
                    onPressed: () {
                      // 다른 아이콘을 눌렀을 때의 동작을 추가할 수 있습니다.
                    },
                    icon: Icon(Icons.clear),
                  )
                ],
              ),
              SizedBox(height: 20.w,),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ImageBuilder(getImage: mainPageController.getNotificationImage),
                ), // #. image
              SizedBox(height: 20.w,),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ImageBuilder(getImage: mainPageController.getAdsImage),
              ),
              SizedBox(height: 15.w,),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("청약길잡이",
                    style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),// #. image
              SizedBox(height: 15.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BasicGuideWidget(
                    imageUrl: Images.homeTemp ,
                    overlayText : "국민주택" ,
                    description: "국민주택입니다.",
                  ),
                  BasicGuideWidget(
                    imageUrl: Images.homeTemp ,
                    overlayText : "민영주택" ,
                    description: "민영주택입니다.",
                  ),
                  BasicGuideWidget(
                    imageUrl: Images.homeTemp ,
                    overlayText : "신혼홈타운" ,
                    description: "신혼홈타운입니다.",
                  ),
                ],
              ), // #. 청약길잡이
              const ExtraGuideWidget(
                name: "청년주택 길잡이",
                description: "편식하는 아이 뭘 먹여야 하나요"
                ),
              const ExtraGuideWidget(
                  name: "청년주택 길잡이",
                  description: "편식하는 아이 뭘 먹여야 하나요"
              ),
              const ExtraGuideWidget(
                  name: "청년주택 길잡이",
                  description: "편식하는 아이 뭘 먹여야 하나요"
              ),
              const ExtraGuideWidget(
                  name: "청년주택 길잡이",
                  description: "편식하는 아이 뭘 먹여야 하나요"
              ),
              const ExtraGuideWidget(
                  name: "청년주택 길잡이",
                  description: "편식하는 아이 뭘 먹여야 하나요"
              ),
              const ExtraGuideWidget(
                  name: "청년주택 길잡이",
                  description: "편식하는 아이 뭘 먹여야 하나요"
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar()
    );
  }
}
