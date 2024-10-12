import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/ApplyHome/SupplyMethod.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/NoticeProfileWidget.dart';
import 'package:homerun/Page/NoticeListPage/View/NoticeListPage.dart';

import '../Controller/NoticesTabPageController.dart';

//TODO 탭 옮길때 상태 유지하도록 해야함
class NoticesTabPage extends StatefulWidget {
  const NoticesTabPage({super.key, required this.supplyMethod});
  final SupplyMethod supplyMethod;

  @override
  State<NoticesTabPage> createState() => _NoticesTabPageState();
}

class _NoticesTabPageState extends State<NoticesTabPage> with AutomaticKeepAliveClientMixin<NoticesTabPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Get.put(
      NoticesTabPageController(supplyMethod: widget.supplyMethod,),
      tag: widget.supplyMethod.toString()
    ).loadNotice();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GetBuilder<NoticesTabPageController>(
      tag: widget.supplyMethod.toString(),
      builder: (controller) {
        if(controller.loadingState == LoadingState.loading){
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        else if(controller.loadingState == LoadingState.fail){
          return const Center(
              child: Text("데이터를 가져 올 수 없습니다.")
          );
        }
        else{
          return ListView.builder(
              itemCount: controller.noticeList.length + 1,
              itemBuilder: (_,index){
                //#. 마지막 아이템
                if(index == controller.noticeList.length){
                  return Center(
                    child: TextButton(
                        onPressed: (){
                          Get.to(NoticeListPage(supplyMethod: widget.supplyMethod,));
                        },
                        child: Text(
                          "전체보기",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp
                          ),
                        )
                    ),
                  );
                }
                else{
                  return NoticeProfileWidget(notice: controller.noticeList[index], supplyMethod: SupplyMethod.General,);
                }
              }
          );
        }
      }
    );

    // return PagedListView(
    //   pagingController: noticeTabPageController.pagingController,
    //   builderDelegate: PagedChildBuilderDelegate<Notice>(
    //     itemBuilder: (context, item, index) => NoticeProfileWidget(notice: item, supplyMethod: SupplyMethod.General,),
    //     noMoreItemsIndicatorBuilder : (_) => Gap(50.w),
    //     noItemsFoundIndicatorBuilder : (_) => Gap(50.w),
    //     firstPageErrorIndicatorBuilder: (_) => Center(
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(vertical: 7.5.w),
    //         child: Text(
    //           "데이터를 불러 올 수 없습니다.",
    //           style: TextStyle(
    //               fontSize: 12.sp,
    //               color: Palette.brightMode.mediumText
    //           ),
    //         ),
    //       ),
    //     ),
    //     newPageErrorIndicatorBuilder: (_) => Center(
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(vertical: 7.5.w),
    //         child: Text(
    //           "데이터를 불러 올 수 없습니다.",
    //           style: TextStyle(
    //               fontSize: 12.sp,
    //               color: Palette.brightMode.mediumText
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
