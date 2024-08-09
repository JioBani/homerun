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
    Get.put(ScrapPageController()).getScraps(isReset: true);
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){

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
              Expanded(
                child: GetBuilder<ScrapPageController>(
                  builder: (controller) {
                    return ListView(
                      children:[
                        ...controller.scarps.map((e) => NoticeScrapItemWidget(noticeScrap: e)).toList(),
                        Builder(
                          builder: (_){
                            if(controller.loadingState == LoadingState.success){
                              return const Text("더 불러오기");
                            }
                            else if(
                              controller.loadingState == LoadingState.success ||
                              controller.loadingState == LoadingState.noMoreData
                            ){
                              return const CupertinoActivityIndicator();
                            }
                            else{
                              return const Text("오류");
                            }
                          }
                        )
                      ],
                    );
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
