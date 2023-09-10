import 'package:flutter/material.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'National/NationalWidget.dart';
import 'TabBarWidget.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("청약자격진단"),
        automaticallyImplyLeading: false
      ),
      body: const SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TapBarWidget(),
                Expanded(
                  child: TabBarView(
                    children: [
                      NationalWidget(),
                      Center(child: Text('검색 화면')),
                      Center(child: Text('프로필 화면')),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
