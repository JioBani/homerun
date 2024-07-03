import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/SiteReviewListPageController.dart';
import 'package:homerun/Page/NoticesPage/View/SiteReview/SiteReviewListItemWidget.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Style/Fonts.dart';

class SiteReviewListPage extends StatefulWidget {
  const SiteReviewListPage({super.key, required this.announcement});
  final APTAnnouncement announcement;

  @override
  State<SiteReviewListPage> createState() => _SiteReviewListPageState();
}

class _SiteReviewListPageState extends State<SiteReviewListPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(SiteReviewListPageController(
        noticeId: widget.announcement.publicAnnouncementNumber ?? ''
       ),
       tag: widget.announcement.publicAnnouncementNumber ?? ''
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
              widget.announcement.houseName ?? '',
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
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(SiteReviewWritePage(noticeId: widget.announcement.publicAnnouncementNumber ?? '',));
            },
          )
        ],
      ),
      body: SafeArea(
        child: GetX<SiteReviewListPageController>(
          tag: widget.announcement.publicAnnouncementNumber ?? '',
          builder: (controller) {
            if(controller.loadingState.value == LoadingState.success){
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
                  children: widgets,
                ),
              );
            }
            else if(controller.loadingState.value == LoadingState.loading){
              return const Center(child: CupertinoActivityIndicator());
            }
            else{
              return const Center(child: Text("오류가 발생했습니다."),);
            }
          }
        ),
      ),
    );
  }
}



