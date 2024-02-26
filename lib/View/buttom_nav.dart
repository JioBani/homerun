import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/View/GuidePage/GuidePage.dart';
import 'package:homerun/View/HomePage/home_page.dart';
import 'package:homerun/View/HousingInformationPage/HousingInformationPage.dart';
import 'package:homerun/View/SaleInfomation/SaleInfomationPage.dart';
import 'package:homerun/NotUsed/test.dart';

import 'AssessmentPage/AssessmentPage.dart';
import 'MyPage/MyPage.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  Color iconColor = Colors.black45;
  Color backgroundColor = Colors.white;

  final List<Widget> _tabs = [
    PlaceholderWidget(color: Colors.blue, text: 'Home'),
    PlaceholderWidget(color: Colors.green, text: 'Search'),
    PlaceholderWidget(color: Colors.orange, text: 'Notifications'),
    PlaceholderWidget(color: Colors.purple, text: 'Favorites'),
    PlaceholderWidget(color: Colors.red, text: 'Profile'),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch(index){
      case 0 : Get.off(
        HomePage(),
        transition: Transition.noTransition,
      );
      case 1 : Get.off(
        GuidePage(),
        transition: Transition.noTransition,
      );
      case 2 : Get.off(
        AssessmentPage(),
        transition: Transition.noTransition,
      );
      case 3 : Get.off(
        //SaleInformationPage(),
        HousingInformationPage(),
        transition: Transition.noTransition,
      );
      case 4 : Get.off(
        MyPage(),
        transition: Transition.noTransition,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home , color:iconColor,size: 30.sp,),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color:iconColor,size:  30.sp),
            label: '청약기본자격',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color:iconColor,size: 30.sp),
            label: '청약자격진단',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: iconColor,size: 30.sp),
            label: '분양정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: iconColor,size: 30.sp),
            label: '마이페이지',
          ),
        ]
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;

  PlaceholderWidget({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}