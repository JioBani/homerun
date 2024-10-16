import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/SelectBoxWidget.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:homerun/Feature/Notice/Value/RegionGyeonggi.dart';
import 'package:homerun/Feature/Notice/Value/RegionSeoul.dart';

import '../Controller/NotificationPageController.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final NotificationPageController controller;

  @override
  void initState() {
    controller = Get.put(NotificationPageController());
    controller.fetchSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        listTileTheme: ListTileTheme.of(context).copyWith(
            minVerticalPadding : 0,
            dense: true
        ),
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult : (didPop, result) async {
          if (didPop) {
            return;
          }

          if(controller.checkChange()){
            bool? result = await CustomDialog.showConfirmationDialog(
                context: context,
                content: "변경된 내용을 저장하지 않고 나가시겠습니까?"
            );

            if(result == true && context.mounted && Navigator.canPop(context)){
              Navigator.pop(context);
            }
          }
          else{
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar:AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor : Colors.white,
            titleSpacing: 0,
            centerTitle: true,
            shadowColor: Colors.black.withOpacity(0.5),
            title: Text(
              "알림설정",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).primaryColor,
                fontFamily: Fonts.BCCard
              ),
            ),
          ),
          body: Stack(
            children: [
              GetX<NotificationPageController>(
                builder: (controller) {
                  if(controller.loadingState.value == LoadingState.loading){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }
                  else if(controller.loadingState.value == LoadingState.fail){
                    return Center(
                      child: Text(
                        "알림 설정을 불러오지 못했습니다.",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //#. 분양주택
                          Text(
                            "분양주택설정",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp
                            ),
                          ),
                          Gap(15.w),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runSpacing: 15.w,
                            spacing: 10.w,
                            children: HouseType.values.map((e){
                              return SelectBoxWidget<HouseType>(
                                controller: controller.houseTypeController,
                                inkWellBorderRadius: BorderRadius.circular(20.r),
                                value: e,
                                builder: (_,value,isSelect){
                                  return FittedBox(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      constraints: BoxConstraints(
                                          minWidth: 90.w
                                      ),
                                      //width: flexible ? null : 90.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.r),
                                          color: isSelect ? Theme.of(context).primaryColor : Palette.baseColor,
                                          border: isSelect ? null : Border.all(color: Palette.brightMode.mediumText, width: 0.3)
                                      ),
                                      child: Center(
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(
                                                color:isSelect ?  Colors.white : Colors.black,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600
                                            ),
                                          )
                                      ),
                                    )
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Gap(5.w),
                          const Divider(),
                          Gap(10.w),
                          //#. 서울
                          Text(
                            "지역설정",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp
                            ),
                          ),
                          Gap(15.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "서울 전 지역 알림",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 40.w,
                                height: 25.w,
                                child: FittedBox(
                                  child: CupertinoSwitch(
                                    value: controller.seoulSelect,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.seoulSelect = value;
                                      });
                                    },
                                    activeColor : Theme.of(context).primaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(10.w),
                          //#. 서울 자치구
                          SelectButtonListWidget<RegionSeoul>(
                            controller: controller.regionSeoulController,
                            data: RegionSeoul.values,
                            title: "서울 각 자치구별 알림",
                          ),
                          Gap(10.w),
                          //#. 경기
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "경기 전 지역 알림",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 40.w,
                                height: 25.w,
                                child: FittedBox(
                                  child: CupertinoSwitch(
                                      value: controller.gyeonggiSelect,
                                      onChanged: (value) {
                                        setState(() {
                                          controller.gyeonggiSelect = value;
                                        });
                                      },
                                      activeColor : Theme.of(context).primaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(10.w),
                          //#. 경기 자치구
                          SelectButtonListWidget<RegionGyeonggi>(
                            controller: controller.regionGyeonggiController,
                            data: RegionGyeonggi.values,
                            title: "경기 각 자치구별 알림 ",
                          ),
                          //#. 지역
                          SelectButtonListWidget<Region>(
                            controller: controller.regionController,
                            data: Region.withoutSeoulGyeonggi(),
                            title: "지역 별 알림 ",
                          ),
                          //#. 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap :() async {
                                  bool? result = await CustomDialog.showConfirmationDialog(
                                    context: context,
                                    content: "알림설정을 초기화 하시겠습니까?"
                                  );

                                  if(result == true && context.mounted){

                                    controller.reset();

                                    CustomDialog.defaultDialog(
                                      context: context,
                                      title: '알림설정이 초기화 되었습니다. 창을 나가기전 저장 해주세요.',
                                      buttonText: '확인',
                                    );
                                  }
                                },
                                child: Container(
                                  width: 145.w,
                                  height: 45.w,
                                  decoration: BoxDecoration(
                                    color: Palette.baseColor,
                                    border: Border.all(color: Palette.brightMode.darkText , width: 0.3),
                                    borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: Center(
                                    child: Text(
                                      "초기화",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Palette.brightMode.mediumText
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(20.w),
                              InkWell(
                                onTap: () async {
                                  bool? result = await CustomDialog.showConfirmationDialog(
                                      context: context,
                                      content: "알림 설정을 수정하겠습니까?"
                                  );

                                  if(result == true){
                                    controller.save(context);
                                  }
                                },
                                child: Container(
                                  width: 145.w,
                                  height: 45.w,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: Center(
                                    child: Text(
                                      "저장",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 7
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectButtonListWidget<T> extends StatelessWidget {
  const SelectButtonListWidget({
    super.key,
    required this.data,
    required this.controller,
    required this.title,
    this.flexible = false,
    this.flexibleSpacing,
    this.flexInnerPadding
  });

  final List<T> data;
  final SelectBoxController<T> controller;
  final String title;
  final bool flexible;
  final double? flexibleSpacing;
  final EdgeInsets? flexInnerPadding;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp
        ),
      ),
      tilePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: const Border(),
      children: [
        SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
              builder: (context , constraints) {
                return Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 15.w,
                  spacing: flexible ? (flexibleSpacing ?? 0) : (constraints.maxWidth - 270.w) / 2, //#. 현재 너비에 버튼 3개의 너비를 배고 / 2
                  children: data.map((e){
                    return SelectBoxWidget<T>(
                      controller: controller,
                      inkWellBorderRadius: BorderRadius.circular(20.r),
                      value: e,
                      builder: (_,value,isSelect){
                        if(flexible){
                          return FittedBox(
                            child: Container(
                              padding: flexInnerPadding,
                              constraints: BoxConstraints(
                                minWidth: 90.w
                              ),
                              width: flexible ? null : 90.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: isSelect ? Theme.of(context).primaryColor : Palette.baseColor,
                                  border: isSelect ? null : Border.all(color: Palette.brightMode.mediumText, width: 0.3)
                              ),
                              child: Center(
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(
                                        color:isSelect ?  Colors.white : Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                              ),
                            )
                          );
                        }
                        else{
                          return Container(
                            width: 90.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: isSelect ? Theme.of(context).primaryColor : Palette.baseColor,
                                border: isSelect ? null : Border.all(color: Palette.brightMode.mediumText, width: 0.3)
                            ),
                            child: Center(
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(
                                      color:isSelect ?  Colors.white : Colors.black,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              }
          ),
        )
      ],
    );
  }
}

