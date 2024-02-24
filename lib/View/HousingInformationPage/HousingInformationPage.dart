import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/HousingInformationPage/HousingNumberWidget.dart';
import 'package:homerun/View/buttom_nav.dart';

import 'RegionalTabView.dart';

class HousingInformationPage extends StatelessWidget {
  const HousingInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SaleInformationPageController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 5.h, 24.w, 5.h),
            child: Column(
              children: [
                Center(
                  child: Text("분양정보",
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: Palette.defaultBlue
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color.fromRGBO(251, 251, 251, 1)
                  ),
                  height: 80.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HousingNumberWidget(name: "오늘청약", number: 3),
                      HousingNumberWidget(name: "청약임박", number: 3),
                      HousingNumberWidget(name: "모집중", number: 32),
                      HousingNumberWidget(name: "무순위", number: 33),
                      HousingNumberWidget(name: "예정", number: 134),
                    ],
                  ),
                ),
                SizedBox(height: 14.h,),
                DefaultTabController(
                    length: 3,
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: const Color.fromRGBO(251, 251, 251, 1)
                            ),
                            child: const TabBar(
                                tabs: [
                                  Tab(text: "분양중"),
                                  Tab(text: "분양임박"),
                                  Tab(text: "분양마감"),
                                ]
                            ),
                          ),
                          const Expanded(
                            child: TabBarView(
                                children: [
                                  RegionalInfoTabView("분양중"),
                                  RegionalInfoTabView("분양임박"),
                                  RegionalInfoTabView("분양마감"),
                                ]
                            ),
                          )
                        ],
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class RegionalInfoTabView extends StatefulWidget {
  const RegionalInfoTabView(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<RegionalInfoTabView> createState() => _RegionalInfoTabViewState();
}

class _RegionalInfoTabViewState extends State<RegionalInfoTabView>
    with AutomaticKeepAliveClientMixin , TickerProviderStateMixin{


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late final TabController _tabController;

  final List<String> regional = [
    "서울",
    "경기",
    "강원",
    "충북",
    "충남",
    "대전",
    "대구",
    "경북",
    "경남",
    "부산",
    "전북",
    "전남",
    "광주",
    "제주"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: regional.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        TabBar.secondary(
          tabAlignment: TabAlignment.start,
          controller: _tabController,
          isScrollable: true,
          tabs: regional.map((e) => Tab(
            child: SizedBox(
              width: 35.w,
              child: Center(
                child: Text(
                  e
                ),
              ),
            )
          ,)).toList()
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: TabBarView(
              controller: _tabController,
              children: regional.map((e) => RegionalTabView(region: e, category: widget.outerTab)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
