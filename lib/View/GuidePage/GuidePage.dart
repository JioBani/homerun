import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Controller/GuidePage/GuidePageController.dart';
import 'package:homerun/Style/FirebaseStorageImages.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/View/GuidePage/GuidePostListPreviewPage.dart';
import 'package:homerun/View/GuidePage/TypeGuideTabWidget.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:get/get.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> with TickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  List<String> category = [
    "청년",
    "신혼부부",
    "기관추천",
    "생애최초",
    "노부모",
    "다자녀",
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(GuidePageController());

    return DoubleTapExitWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("청약길잡이",
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: Palette.defaultBlue
                    ),
                  ),
                ),
                SizedBox(height: 16.h,),
                LayoutBuilder(
                  builder: (context , constraints) {
                    double l = (constraints.maxWidth - 20.w)/6;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: List.generate(category.length, (index) => TypeGuideTabWidget(
                        imagePath: FirebaseStorageImages.typeImages.youth,
                        name: category[index],
                        size: l,
                        tabController: tabController,
                        index: index,
                      )),

                      /*children: [
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.youth,
                          name: "청년",
                          size: l,
                          tabController: tabController,
                          index: 0,
                        ),
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.newlyweds,
                          name: "신혼부부",
                          size: l,
                          tabController: tabController,
                          index: 1,
                        ),
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.firetime,
                          name: "기관추천",
                          size: l,
                          tabController: tabController,
                          index: 2,
                        ),
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.firetime,
                          name: "생애최초",
                          size: l,
                          tabController: tabController,
                          index: 3,
                        ),
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.senior,
                          name: "노부모",
                          size: l,
                          tabController: tabController,
                          index: 4,
                        ),
                        TypeGuideTabWidget(
                          imagePath: FirebaseStorageImages.typeImages.family,
                          name: "다자녀",
                          size: l,
                          tabController: tabController,
                          index: 5,
                        ),
                      ],*/
                    );
                  }
                ),
                Divider(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: List.generate(
                        category.length,
                        (index) => GuidePostListPreviewPage(type: category[index],)
                    ),
                    /*children: [
                      GuidePostListPreviewPage(type: "신혼부부",),
                      GuidePostListPreviewPage(type: "신혼부부",),
                      GuidePostListPreviewPage(type: "신혼부부",),
                      GuidePostListPreviewPage(type: "신혼부부",),
                      GuidePostListPreviewPage(type: "신혼부부",),
                      GuidePostListPreviewPage(type: "신혼부부",),
                    ]*/
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
