import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/NotUsed/InformationListViewWidget.dart';
import 'package:homerun/NotUsed/LocationTabPageWidget.dart';
import 'package:homerun/NotUsed/StreamTest.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:get/get.dart';

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
          toolbarHeight: 20.h,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  '분양중',
                  style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '분양예졍',
                  style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '분양완료',
                  style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: TabBarView(
              controller: _tabController, // TabController 연결
              children: [
                // 탭 내용
                CategoryTabBarViewPageWidget(category: "분양중",),
                CategoryTabBarViewPageWidget(category: "분양예정",),
                CategoryTabBarViewPageWidget(category: "분양완료",),
              ],
            ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
