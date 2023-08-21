import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/View/AssessmentPage/AssessmentPage.dart';
import 'package:homerun/View/KakaoLogin/KakaoLoginPage.dart';

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
      case 3 : Get.to(AssessmentPage());
      case 4 : Get.to(KakaoLoginPage(title: "카카오 로그인"));
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
            icon: Icon(Icons.home , color:iconColor,size: 60.w,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color:iconColor,size: 60.w),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color:iconColor,size: 60.w),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: iconColor,size: 60.w),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: iconColor,size: 60.w),
            label: 'Profile',
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