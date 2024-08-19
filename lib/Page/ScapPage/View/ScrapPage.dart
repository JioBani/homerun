import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/ScapPage/Controller/ScrapPageController.dart';
import 'package:homerun/Page/ScapPage/View/NoticeScrapItemWidget.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

class ScrapPage extends StatefulWidget {
  const ScrapPage({super.key});

  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {

  @override
  void initState() {
    Get.put(ScrapPageController()).getScraps(10 , isReset: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "공고 스크랩",
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
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              //#. 전체 삭제 버튼
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){
                    Get.find<ScrapPageController>().deleteAllScrap();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w , vertical: 0.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Palette.brightMode.mediumText,
                        width: 0.5.w
                      )
                    ),
                    child: Text(
                      "전체삭제",
                      style: TextStyle(
                        color: Palette.brightMode.mediumText
                      ),
                    ),
                  ),
                ),
              ),
              //#. 스크랩 리스트
              Expanded(
                child: GetBuilder<ScrapPageController>(
                  builder: (controller) {
                    if(controller.loadingState == LoadingState.noMoreData && controller.scarps.isEmpty){
                      return const Center(child: Text("스크랩 된 공고가 없습니다."),);
                    }
                    else{
                      return ListView(
                        children:[
                          //#. 스크랩 리스트
                          ...controller.scarps.map((e) => NoticeScrapItemWidget(noticeScrap: e)).toList(),
                          //#. 불러오기 버튼
                          Builder(
                              builder: (_){
                                if(controller.loadingState == LoadingState.success){
                                  return TextButton(
                                      onPressed: (){
                                        controller.getScraps(10);
                                      },
                                      child: const Text("더 불러오기")
                                  );
                                }
                                else if(controller.loadingState == LoadingState.noMoreData){
                                  return const SizedBox();
                                }
                                else if(controller.loadingState == LoadingState.loading){
                                  return const Center(child: CupertinoActivityIndicator());
                                }
                                else{
                                  return const Center(child: Text("데이터를 불러 올 수 없습니다."));
                                }
                              }
                          )
                        ],
                      );
                    }
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
