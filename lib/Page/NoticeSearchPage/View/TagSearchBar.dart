import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:homerun/Page/NoticeSearchPage/Controller/TagSearchBarController.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';

class TagSearchBar extends StatefulWidget {
  const TagSearchBar({
    super.key,
    required this.controller,
    required this.onReset,
    required this.onTapSearch,
    required this.onChangeSelect
  });

  final TagSearchBarController controller;
  final Function() onReset;
  final Function() onTapSearch;
  final Function(dynamic value, bool select) onChangeSelect;

  @override
  State<TagSearchBar> createState() => TagSearchBarState();
}

class TagSearchBarState extends State<TagSearchBar> {

  @override
  void initState() {
    widget.controller.setWidget(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void refresh(){
    setState(() {

    });
  }

  List<Widget> buildHouseType(){
    return widget.controller.houseTypeTags.map((tag)=>TagBox(
      text: tag.toString(),
      onTap: (){
        widget.controller.removeHouseTypeTag(tag);
        widget.onChangeSelect(tag , false);
      },
    )).toList();
  }

  List<Widget> buildRegion(){
    return widget.controller.regionTags.map((tag)=>TagBox(
      text: tag.toString(),
      onTap: (){
        widget.controller.removeRegionTag(tag);
        widget.onChangeSelect(tag , false);
      },
    )).toList();
  }

  List<Widget> buildTagList(){
    if(widget.controller.houseTypeTags.isEmpty){
      if(widget.controller.regionTags.isEmpty){
        return [];
      }
      else{
        return buildRegion();
      }
    }
    else{
      if(widget.controller.regionTags.isEmpty){
        return buildHouseType();
      }
      else{
        return [
          ...buildRegion(),
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Text(
              "에 있는",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Palette.brightMode.mediumText,
              ),
            ),
          ),
          ...buildHouseType(),
        ];
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.w, //#. 검색바 최대 높이 80, gap 10, 버튼높이 30
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 40.w,
                maxHeight: 80.w
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  gradient: const LinearGradient(colors: [Palette.defaultSkyBlue, Color(0xffFF9C32)]),
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Stack(
                alignment : Alignment.centerLeft,
                children: [
                  FittedBox(
                    child: Align(
                      alignment : Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Builder(
                          builder: (context) {
                            if(widget.controller.regionTags.isEmpty && widget.controller.houseTypeTags.isEmpty){
                              return SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: Center(
                                  child: Image(
                                    image: const AssetImage(
                                        SearchBarImages.search
                                    ),
                                    height: 15.sp,
                                    width: 15.sp,
                                  ),
                                ),
                              );
                            }
                            else{
                              return Center(
                                child: InkWell(
                                  onTap: (){
                                    widget.onReset();
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    size: 20.sp,
                                  ),
                                ),
                              );
                            }
                          }
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Align(
                      alignment : Alignment.centerLeft,
                      child: Builder(builder: (_){
                        if(widget.controller.regionTags.isEmpty && widget.controller.houseTypeTags.isEmpty){
                          return Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Text(
                              "키워드를 터치해서 검색어에 추가해보세요",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Palette.brightMode.lightText
                              ),
                            ),
                          );
                        }
                        else{
                          return const SizedBox(width: 1,height: 1,); //#. FittedBox가 항상 1보다 커야 해서
                        }
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.w),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: Wrap(
                            runSpacing: 5.w,
                            runAlignment : WrapAlignment.start,
                            crossAxisAlignment : WrapCrossAlignment.center,
                            children: buildTagList()
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(10.w),
          
          //#. 검색 버튼
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: (){
                widget.onTapSearch();
              },
              child: Container(
                width: 80.w,
                height: 30.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.r)
                ),
                child: Center(
                  child: Text(
                    "검색",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class TagBox extends StatelessWidget {
  const TagBox({super.key, required this.text, required this.onTap});
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: FittedBox(
        child: InkWell(
          onTap: (){
            onTap();
          },
          borderRadius: BorderRadius.circular(25.w),
          child: Container(
            height: 25.w,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(25.w),
            ),
            child: Align( // Align을 사용하여 중앙 정렬
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TagSearchBarPreview extends StatefulWidget {
  const TagSearchBarPreview({super.key, required this.controller, required this.onReset});

  final TagSearchBarController controller;
  final Function() onReset;

  @override
  State<TagSearchBarPreview> createState() => TagSearchBarPreviewState();
}

class TagSearchBarPreviewState extends State<TagSearchBarPreview> {

  @override
  void initState() {
    widget.controller.setPreviewWidget(this);
    super.initState();
  }

  void refresh(){
    setState(() {

    });
  }

  List<Widget> buildHouseType(){
    return widget.controller.houseTypeTags.map((tag)=>TagBox(
      text: tag.toString(),
      onTap: (){},
    )).toList();
  }

  List<Widget> buildRegion(){
    return widget.controller.regionTags.map((tag)=>TagBox(
      text: tag.toString(),
      onTap: (){ },
    )).toList();
  }

  List<Widget> buildTagList(){
    if(widget.controller.houseTypeTags.isEmpty){
      if(widget.controller.regionTags.isEmpty){
        return [];
      }
      else{
        return buildRegion();
      }
    }
    else{
      if(widget.controller.regionTags.isEmpty){
        return buildHouseType();
      }
      else{
        return [
          ...buildRegion(),
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Text(
              "에 있는",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Palette.brightMode.mediumText,
              ),
            ),
          ),
          ...buildHouseType(),
        ];
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 40.w,
              maxHeight: 80.w
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: const LinearGradient(colors: [Palette.defaultSkyBlue, Color(0xffFF9C32)]),
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              alignment : Alignment.centerLeft,
              children: [
                FittedBox(
                  child: Align(
                    alignment : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Builder(
                          builder: (context) {
                            if(widget.controller.regionTags.isEmpty && widget.controller.houseTypeTags.isEmpty){
                              return SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: Center(
                                  child: Image(
                                    image: const AssetImage(
                                        SearchBarImages.search
                                    ),
                                    height: 15.sp,
                                    width: 15.sp,
                                  ),
                                ),
                              );
                            }
                            else{
                              return Center(
                                child: InkWell(
                                  onTap: (){
                                    widget.onReset();
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    size: 20.sp,
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Align(
                    alignment : Alignment.centerLeft,
                    child: Builder(builder: (_){
                      if(widget.controller.regionTags.isEmpty && widget.controller.houseTypeTags.isEmpty){
                        return Padding(
                          padding: EdgeInsets.only(left: 32.w),
                          child: Text(
                            "키워드로 검색해보세요.",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Palette.brightMode.lightText
                            ),
                          ),
                        );
                      }
                      else{
                        return const SizedBox(width: 1,height: 1,); //#. FittedBox가 항상 1보다 커야 해서
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35.w),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        child: Wrap(
                            runSpacing: 5.w,
                            runAlignment : WrapAlignment.start,
                            crossAxisAlignment : WrapCrossAlignment.center,
                            children: buildTagList()
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

