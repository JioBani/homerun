import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:get/get.dart';
import 'package:homerun/Vocabulary/Vocabulary.dart';

import 'CategoryTabbarViewPageWidget.dart';

class SaleInformationPage extends StatefulWidget {
  const SaleInformationPage({super.key});

  @override
  State<SaleInformationPage> createState() => _SaleInformationPageState();
}

class _SaleInformationPageState extends State<SaleInformationPage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TabController 초기화
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TabController 해제
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Get.put(SaleInformationPageController());

    return DoubleTapExitWidget(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 8.h,
          bottom: TabBar(
            controller: _tabController,
            tabs: List.generate(
                Vocabulary.housingState.length,
                    (index) =>  Tab(
                      child: Text(
                        Vocabulary.housingState[index],
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
              )
          ),
        ),
        body: SafeArea(
            child: TabBarView(
              controller: _tabController, // TabController 연결
              children: List.generate(
                  Vocabulary.housingState.length,
                  (index) => CategoryTabBarViewPageWidget(category: Vocabulary.housingState[index],)
              )
            ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
