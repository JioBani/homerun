import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/HousingInformationPage/HousingNumberWidget.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:homerun/Vocabulary/VocabularyList.dart';

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
                            child: TabBar(
                                tabs: Vocabulary.housingState.map((e) => Tab(text: e,)).toList()
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                                children: Vocabulary.housingState.map(
                                        (e) => RegionalInfoTabView(e,)
                                ).toList()
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Vocabulary.regions.length, vsync: this);
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
          tabs: Vocabulary.regions.map((e) => Tab(
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
              children: Vocabulary.regions.map((e) => RegionalTabView(region: e, category: widget.outerTab)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
