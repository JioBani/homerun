import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/NoticesTabPage.dart';
import 'package:homerun/Page/MyPageDrawer/View/MyPageDrawer.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Widget/CustonSearchBar.dart';

class HousingSaleNoticesPage extends StatefulWidget {
  const HousingSaleNoticesPage({super.key});

  @override
  State<HousingSaleNoticesPage> createState() => _HousingSaleNoticesPageState();
}

class _HousingSaleNoticesPageState extends State<HousingSaleNoticesPage> with TickerProviderStateMixin {

  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "청약홈런",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.defaultSkyBlue,
              fontFamily: Fonts.title
          ),
        ),
      ),
      drawer: const MyPageDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
          child: Column(
            children: [
              SizedBox(height: 12.w,),
              CustomSearchBar(),
              SizedBox(height: 21.w,),
              SizedBox(
                width: double.infinity,
                height: 110.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  child: Image.asset(
                    "assets/images/Test/ad.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              //#. 탭바 및 탭뷰
              Expanded(
                child: Column(
                  children: [
                    //#. 탭바
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.1.sp))
                      ),
                      child: LayoutBuilder(
                        builder: (_,constraints) {
                          double maxWidth = constraints.maxWidth;
                          return TabBar(
                            controller: tabController,
                            tabAlignment: TabAlignment.center,
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            unselectedLabelColor: Colors.grey,
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: Fonts.title
                            ),
                            isScrollable: true,
                            tabs: [
                              Tab(
                                child: SizedBox(
                                  width: maxWidth/ 3,
                                  child: Center(
                                    child: Text(
                                      "아파트"
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: SizedBox(
                                  width: maxWidth/ 3,
                                  child: Center(
                                    child: AutoSizeText(
                                      "무순위/잔여세대",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: SizedBox(
                                  width: maxWidth/ 3,
                                  child: Center(
                                    child: Text(
                                        "임의공급"
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          );
                        }
                      )
                    ),
                    //#. 탭뷰
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          NoticesTabPage(),
                          NoticesTabPage(),
                          NoticesTabPage(),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.w,),
            ],
          ),
        ),
      ),
    );
  }
}
