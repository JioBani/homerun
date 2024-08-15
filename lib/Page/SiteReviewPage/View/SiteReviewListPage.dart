import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/LoginPage/View/LoginPage.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewListPageController.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewListItemWidget.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage/SiteReviewWritePage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Fonts.dart';

class SiteReviewListPage extends StatefulWidget {
  const SiteReviewListPage({super.key, required this.notice});
  final Notice notice;

  @override
  State<SiteReviewListPage> createState() => _SiteReviewListPageState();
}

class _SiteReviewListPageState extends State<SiteReviewListPage> {

  @override
  Widget build(BuildContext context) {
    Get.put(SiteReviewListPageController(
        noticeId: widget.notice.id
       ),
       tag: widget.notice.id
    );
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.notice.noticeDto?.houseName ?? '',
              style: TextStyle(
                fontSize:  16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: Fonts.BCCard,
                color: Theme.of(context).primaryColor
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              AuthService.runWithAuthCheck(()=>Get.to(SiteReviewWritePage(noticeId:widget.notice.id,)));
            },
          )
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SiteReviewListPageController>(
          tag: widget.notice.id,
          builder: (controller) {
            List<Widget> widgets = [];

            for (int i = 0; i < controller.siteReviews.length; i += 2) {
              if (i + 1 < controller.siteReviews.length) {
                widgets.add(
                  Padding(
                    padding: EdgeInsets.only(top: 17.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SiteReviewListItemWidget(siteReview: controller.siteReviews[i]),
                        SiteReviewListItemWidget(siteReview: controller.siteReviews[i + 1]),
                      ],
                    ),
                  ),
                );
              } else {
                widgets.add(
                  Padding(
                    padding: EdgeInsets.only(top: 17.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SiteReviewListItemWidget(siteReview: controller.siteReviews[i]),
                      ],
                    ),
                  ),
                );
              }
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: ListView(
                children: [
                  ...widgets,
                  Builder(
                      builder: (context){
                        if(
                        controller.loadingState.value == LoadingState.loading ||
                            controller.loadingState.value == LoadingState.before
                        ){
                          return const Center(child: CupertinoActivityIndicator());
                        }
                        else if(controller.loadingState.value == LoadingState.fail){
                          return const Center(child: Text("데이터를 가져 올 수 없습니다."));
                        }
                        else if(controller.loadingState.value == LoadingState.noMoreData){
                          return const SizedBox();
                        }
                        else{
                          return TextButton(
                              onPressed: (){
                                controller.loadSiteReviews();
                              },
                              child: const Text("${SiteReviewListPageController.loadReviewNumber} 개 더 불러오기")
                          );
                        }
                      }
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}



