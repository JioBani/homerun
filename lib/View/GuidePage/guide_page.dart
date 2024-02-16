import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/guide_page_controller.dart';
import 'package:homerun/View/GuidePage/item_box_widget.dart';
import 'package:homerun/View/buttom_nav.dart';

import '../../Palette.dart';

class GuidePage extends StatefulWidget {
  GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final GuidePageController guidePageController = Get.put(GuidePageController());

  double iconSize = 65.w;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.w),
                height: 50.w,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "청약길잡이",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              DefaultTabController(
                  length: 3,
                  child: TabBar(
                    tabs: [
                      Tab(child: Text("국민주택"),),
                      Tab(child: Text("민영분양"),),
                      Tab(child: Text("신혼홈타운"),),
                    ],
                  )
              ),
              GetX<GuidePageController>(
                builder: (controller) {
                  if (controller.productDatas.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: GridView.builder(
                            itemCount: controller.productDatas.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context , index){
                                return ItemBoxWidget(productData: controller.productDatas[index] , controller: controller,);
                              }
                          ),
                        ),
                    );
                  }
                },
              )
            ],
          )
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CustomBottomNavigationBar()
    );
  }
}
