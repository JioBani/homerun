import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:homerun/Page/NoticeSearchPage/Controller/TagSearchBarController.dart';
import 'package:homerun/Page/NoticeSearchPage/View/TagSearchBar.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

import 'SelectButton.dart';

class SearchSettingPage extends StatelessWidget {
  SearchSettingPage({super.key, required this.tagSearchBarController});

  final TagSearchBarController tagSearchBarController;

  final List<SelectButtonState> selectButtonStateList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor : Colors.transparent,
        title: Text(
          "검색",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.defaultSkyBlue,
              fontFamily: Fonts.title
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //#. 검색 바
                TagSearchBar(
                  controller: tagSearchBarController,
                  onReset: (){
                    for (var state in selectButtonStateList) {
                      state.setValue(false);
                    }
                    selectButtonStateList.clear();
                    tagSearchBarController.reset();
                  },
                  onTapSearch: (){
                    Navigator.pop(context, {
                      "regions" : tagSearchBarController.regionTags,
                      "houseTypes" : tagSearchBarController.houseTypeTags
                    });
                  },
                  onChangeSelect: (value, select){
                    SelectButtonState? target = selectButtonStateList.firstWhereOrNull((state) => state.widget.value == value);

                    if(target != null){
                      target.setValue(false);
                      selectButtonStateList.remove(target);
                    }
                  },
                ),
                Gap(5.w),

                //#. 주택 종류
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "주택 종류",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Gap(15.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 10.w,
                      children: HouseType.values.map((houseType)=>SelectButton<HouseType>(
                        controller: tagSearchBarController,
                        value: houseType,
                        onChanged: (selected, value, widget){
                          selected ? tagSearchBarController.addHouseTypeTag(value) : tagSearchBarController.removeHouseTypeTag(value);
                          selected ? selectButtonStateList.add(widget) : selectButtonStateList.remove(widget);
                        },
                        text: houseType.koreanName,
                      )).toList(),
                    ),
                  ),
                ),
                Gap(20.w),

                //#. 지역
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "지역",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Gap(15.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 10.w,
                      children: Region.values.map((region)=>SelectButton<Region>(
                        controller: tagSearchBarController,
                        value: region,
                        onChanged: (selected, value, widget){
                          selected ? tagSearchBarController.addRegionTag(value) : tagSearchBarController.removeRegionTag(value);
                          selected ? selectButtonStateList.add(widget) : selectButtonStateList.remove(widget);
                        },
                        text: region.koreanString,
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
