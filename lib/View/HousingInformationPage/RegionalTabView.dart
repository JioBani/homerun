import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Controller/HousingInfoPage/RegionalInfoController.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/HousingInformationPage/LoadingButton.dart';
import 'package:homerun/View/HousingInformationPage/LoadingState.dart';
import 'package:homerun/View/SaleInfomation/PresaleInfo/PresaleInfoPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RegionalTabView extends StatefulWidget {
  const RegionalTabView({super.key , required this.category , required this.region});
  final String category;
  final String region;

  @override
  State<RegionalTabView> createState() => _RegionalTabViewState();
}

class _RegionalTabViewState extends State<RegionalTabView>  with TickerProviderStateMixin {
  late String tag;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  GlobalKey footerKey = GlobalKey();
  late ListViewFooter listViewFooter;
  late RegionalInfoController controller;
  bool isInit = false;
  int loadSize = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tag = "${widget.category}_${widget.region}";
    controller = Get.put(
        RegionalInfoController(category: widget.category, regional: widget.region) , tag: tag
    );
    listViewFooter = ListViewFooter(key : footerKey, refreshController: refreshController);
    _onLoad();
  }

  Future<LoadingState> _onLoad() async {
    var controller = Get.find<RegionalInfoController>(tag: tag);
    final int? count = await controller.addData(loadSize);
    LoadingState state;
    if(count == null){
      state = LoadingState.fail;
    }
    else if(count < loadSize){
      state = LoadingState.noMoreData;
    }
    else{
      state = LoadingState.complete;
    }
    isInit = true;
    if(mounted){
      setState(() {

      });
    }
    return state;
  }


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(!isInit){
          return const CupertinoActivityIndicator();
        }
        else{
          int nums = controller.housingDataList.length;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: nums + 1,
              itemBuilder: (context , index){
                if(index == nums){
                  if(nums < loadSize){
                    return Text('더 불러올 데이터가 없습니다.');
                  }
                  else{
                    return LoadingButton(onLoad: _onLoad);
                  }
                }
                else{
                  HousingData housingData = controller.housingDataList[index];

                  return InkWell(
                    onTap: (){
                      Get.to(PresaleInfoPage(preSaleData: housingData,));
                    },
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "#${housingData.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                color: Palette.defaultBlue
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 140.w,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: FireStorageImage(
                                //TODO 이미지 연결
                                path: "images/housing_info/test01.png",
                                fit: BoxFit.fill,
                                loadingWidget: Container(
                                  color: Colors.blueGrey,
                                  child: const CupertinoActivityIndicator(),
                                ),
                              )
                          ),
                        ),
                        Text(housingData.announcementDateDateTime.toString()),
                        SizedBox(height: 20.h,)
                      ],
                    ),
                  );
                }

              }
          );
        }
      }
    );
  }
}

class ListViewFooter extends StatefulWidget {
  const ListViewFooter({super.key, required this.refreshController});
  final RefreshController refreshController;

  @override
  State<ListViewFooter> createState() => _ListViewFooterState();
}

class _ListViewFooterState extends State<ListViewFooter> {

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      final String str;
      if(widget.refreshController.footerStatus != null){
        switch(widget.refreshController.footerStatus!){
          case LoadStatus.idle : str = "위로 당겨서 더 많은 공고 보기";
          case LoadStatus.loading : str = "로딩중..";
          case LoadStatus.failed : str = "데이터를 가져올수 없습니다.";
          case LoadStatus.canLoading : str = "위로 당겨서 더 많은 공고 보기";
          case LoadStatus.noMore : str = "마지막 공고입니다.";
        }
      }
      else{
        str = "";
      }

      if(widget.refreshController.footerStatus == LoadStatus.loading){
        return const Center(child: CupertinoActivityIndicator(),);
      }
      else{
        return SizedBox(
          height: 50.h,
          child: Center(
              child:Text(
                str,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                ),
              )
          ),
        );
      }
    });
  }
}
