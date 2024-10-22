import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Page/NoticeListPage/Value/SortType.dart';
import 'package:homerun/Page/NoticeSearchPage/Controller/TagSearchBarController.dart';
import 'package:homerun/Page/NoticeSearchPage/View/SearchSettingPage.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

import '../../../Feature/Notice/Value/Region.dart';
import '../../NoticeSearchPage/View/TagSearchBar.dart';
import 'NoticePagedListView.dart';
import 'SortDropDownButtonWidget.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key, required this.supplyMethod});
  final SupplyMethod supplyMethod;

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> with TickerProviderStateMixin{
  late final Map<SupplyMethod,Map<SortType, NoticePagedListView>> noticePagedListViewMap;

  SortType sortType = SortType.announcementDate;
  late final PageController _pageController;
  final TagSearchBarController tagSearchBarController = TagSearchBarController();
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: SortType.values.indexOf(sortType));
    tabController = TabController(length: 3, vsync: this);

    noticePagedListViewMap = {};

    for (var method in SupplyMethod.values) {
      noticePagedListViewMap[method] = {};

      for (var sortType in SortType.values) {
        noticePagedListViewMap[method]![sortType] = NoticePagedListView(
          supplyMethod: method,
          sortType: sortType
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    for(var map in noticePagedListViewMap.values){
      for(var view in map.values){
        view.controller.pagingController.dispose();
      }
    }

    super.dispose();
  }

  void _onSortTypeChanged(SortType newSortType) {
    setState(() {
      sortType = newSortType;
    });
    _pageController.jumpToPage(SortType.values.indexOf(newSortType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "분양정보",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.defaultSkyBlue,
              fontFamily: Fonts.title
          ),
        ),
        actions: [
          SortDropDownButtonWidget(
            startValue: sortType,
            onChanged: (value) {
              _onSortTypeChanged(value);
            },
          ),
          Gap(25.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Gap(8.w),
            InkWell(
              onTap: ()async{
                Map<String,dynamic>? result = await Get.to(SearchSettingPage(tagSearchBarController: tagSearchBarController,));

                if(result != null){
                  setState(() { });

                  //#. 순회 하면서 리스트 초기화
                  for(var map in noticePagedListViewMap.values){
                    for(var view in map.values){
                      view.controller.setSearch(result['regions'] as List<Region>?, result['houseTypes'] as List<HouseType>);
                    }
                  }
                }
              },
              child: TagSearchBarPreview(
                controller: tagSearchBarController,
                onReset: (){
                  for(var map in noticePagedListViewMap.values){
                    for(var view in map.values){
                      view.controller.setSearch(null, null);
                    }
                  }

                  tagSearchBarController.reset();
                },
              )
            ),
            Gap(2.w),
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
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: SupplyMethod.values.map((method)=> PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      sortType = SortType.values[index];
                    });
                  },
                  children: noticePagedListViewMap[method]!.values.toList(),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
