import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/NoticesTabPage.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/HousingInformationPage/HousingInformationPage.dart';
import 'package:homerun/Vocabulary/VocabularyList.dart';
import 'package:homerun/Widget/CustonSearchBar.dart';

class HousingSaleNoticesPage extends StatelessWidget {
  const HousingSaleNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
          child: Column(
            children: [
              Center(
                child: Text("청약홈런",
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.defaultBlue
                  ),
                ),
              ),
              CustomSearchBar(),
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
                                      (e) => NoticesTabPage()
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
