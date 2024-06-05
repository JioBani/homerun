import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/NoticesTabPage.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Vocabulary/VocabularyList.dart';
import 'package:homerun/Widget/CustonSearchBar.dart';

class HousingSaleNoticesPage extends StatelessWidget {
  const HousingSaleNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.w, 14.w, 25.w, 0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "청약홈런",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Palette.defaultSkyBlue
                  ),
                ),
              ),
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
              DefaultTabController(
                  length: 3,
                  child: Expanded(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey, width: 2.sp))),
                            child: TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor:  const Color(0xff2E3C6B),
                                labelColor:  const Color(0xff2E3C6B),
                                unselectedLabelColor: Colors.grey,
                                labelStyle: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700
                                ),
                                tabs: Vocabulary.housingState.map((e) => Tab(
                                    child: Column(
                                      children: [
                                        Text(
                                          "분양전",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        Text(
                                          "(13)",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ).toList()
                            )
                        ),
                        Expanded(
                          child: TabBarView(
                              children: Vocabulary.housingState.map(
                                      (e) => const NoticesTabPage()
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
    );
  }
}
