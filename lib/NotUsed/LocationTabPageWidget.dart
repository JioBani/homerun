/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/ShadowPalette.dart';

import 'InformationListViewWidget.dart';

class LocationTabPageWidget extends StatelessWidget {
  const LocationTabPageWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
            decoration: BoxDecoration(
                color: Colors.white, // 배경색을 하얀색으로 설정
                boxShadow: [
                  ShadowPalette.defaultShadowLight,
                ],
                borderRadius: BorderRadius.circular(10.w)
            ),
            child: TabBar(
              tabs: [
                Tab(child: Text(
                  '분양중',
                  style: TextStyle(
                      fontSize: 30.0.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                )),
                Tab(child: Text(
                  '분양예정',
                  style: TextStyle(
                      fontSize: 30.0.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                )),
                Tab(child: Text(
                  '분양마감',
                  style: TextStyle(
                      fontSize: 30.0.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                )),
              ],
              labelColor: Colors.blue, // 선택된 탭의 텍스트 색상 변경
              unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상 변경
              indicatorColor: Colors.blue, // 선택된 탭 아래의 밑줄 색상 변경
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(
                  child: InformationListViewWidget(region: '속초',),
                ),
                Center(
                  child: InformationListViewWidget(region: '김해',),
                ),
                Center(
                  child: InformationListViewWidget(region: '울산',),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
