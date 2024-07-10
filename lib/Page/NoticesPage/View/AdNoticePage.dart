import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/FireStorageImageList.dart';
import 'package:homerun/Page/Common/Widget/LargetIconButton.dart';
import 'package:homerun/Page/Common/Widget/SmallIconButton.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSortWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabBarWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabChildWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentViewWIdget.dart';
import 'package:homerun/Page/NoticesPage/View/LocationMap.dart';
import 'package:homerun/Page/NoticesPage/View/SiteReview/SiteReviewWidget.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Service/NaverGeocodeService/NaverGeocodeService.dart';
import 'package:homerun/Service/NaverGeocodeService/ServiceKey.dart';
import 'package:homerun/Style/Images.dart';

import 'Comment/CommentInputWidget.dart';

class AdNoticePage extends StatefulWidget {
  const AdNoticePage({super.key, required this.announcement});
  final APTAnnouncement announcement;

  @override
  State<AdNoticePage> createState() => _AdNoticePageState();
}

class _AdNoticePageState extends State<AdNoticePage> with TickerProviderStateMixin{
  final Color typeColor = const Color(0xffFF4545);

  final NaverGeocodeService _geocodeService = NaverGeocodeService.getInstanceWithInit(
      clientId,
      clientSecret
  );

  final FlutterListViewController _scrollController = FlutterListViewController();
  late final TabController commentTabController = TabController(length: 2 , vsync: this);
  late final CommentViewWidgetController commentViewWidgetController;

  late int inputIndex;

  @override
  void initState() {
    commentViewWidgetController = Get.put(
      CommentViewWidgetController(
          noticeId: widget.announcement.publicAnnouncementNumber!,
          tabController: commentTabController
      ),
      tag: widget.announcement.publicAnnouncementNumber!
    );
    super.initState();
  }

  @override
  void dispose() {
    commentTabController.dispose();
    super.dispose();
  }

  void scrollToCommentInput() {
    _scrollController.sliverController.animateToIndex(
        inputIndex - 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn
    );
  }

  List<Widget> getListViewChildren(){
    return [
      SizedBox(height: 17.w,),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 25.w,),
          InkWell(
            onTap: ()=>Get.back(),
            child: SizedBox(
              width: 24.sp,
              height: 24.sp,
              child: Image.asset(
                Images.backIcon,
              ),
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          LargeIconButton(iconPath: Images.partnershipAd, text: "제휴광고",onTap: (){},),
          SizedBox(width: 7.w,),
          LargeIconButton(iconPath: Images.adInquiry, text: "광고문의",onTap: (){},),
          SizedBox(width: 25.w,)
        ],
      ),
      SizedBox(height: 22.w,),
      Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: Row(
          children: [
            Text("서울"),
            SizedBox(width: 4.w,),
            Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
              decoration: BoxDecoration(
                border: Border.all(color: typeColor),
                borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
              ),
              child: Text(
                "민간분양",
                style: TextStyle(
                    color: typeColor,
                    fontWeight: FontWeight.w700 //폰트 굵기가 미디움인데 작게 보여서 bold로 변경
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 6.w,),
      Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: Row(
          children: [
            SizedBox(
              width: 12.sp,
              height: 12.sp,
              child: Image.asset(
                  HousingSaleNoticesPageImages.pinMap
              ),
            ),
            SizedBox(width: 4.w,),
            Text(
              "서대문구 월드 메리앙",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 3.w,),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SmallIconButton(iconPath: Images.heart, text: "좋아요", onTap: (){}),
          SizedBox(width: 4.w,),
          SmallIconButton(iconPath: Images.scrap, text: "스크랩", onTap: (){}),
          SizedBox(width: 4.w,),
          SmallIconButton(iconPath: Images.share, text: "공유", onTap: (){}),
          SizedBox(width: 17.w,)
        ],
      ),
      SizedBox(height: 6.w,),
      SizedBox(
        width: double.infinity,
        height: 174.w,
        child: Image.asset(
          "assets/images/Test/ad.png",
          fit: BoxFit.fitHeight,
        ),
      ),
      //TODO 개발중에 렉 줄이기 위해서 임시로 해제
      // Padding(
      //   padding: EdgeInsets.fromLTRB(25.w, 30.w, 25.w, 0),
      //   child: const FireStorageImageColum(path: "housing_notices/2024000001",),
      // ),
      Padding(
        padding: EdgeInsets.fromLTRB(25.w, 10.w, 25.w, 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 12.sp,
                  height: 12.sp,
                  child: Image.asset(
                      HousingSaleNoticesPageImages.map
                  ),
                ),
                SizedBox(width: 3.w,),
                Text(
                  "위치보기",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.w,),
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 150.w,
                    child: LocationMap(announcement: widget.announcement,geocodeService: _geocodeService,)
                ),
                IconButton(
                    iconSize: 25.sp,
                    onPressed: (){
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog.fullscreen(
                              child:FullLocationMap(announcement: widget.announcement,geocodeService: _geocodeService,)
                          )
                      );
                    },
                    icon: const Icon(Icons.fullscreen_rounded)
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 24.w,),
      Row(
        children: [
          SizedBox(width: 25.w,), //TODO 패팅 확인하기
          Image.asset(
            NoticePageImages.siteReview,
            width: 13.sp,
            height: 13.sp,
          ),
          SizedBox(width: 2.w,),
          Expanded( //TODO 텍스트가 오버플로우 될때 어떻게 표현할지
            child: Text(
              "${widget.announcement.houseName} 현장리뷰",
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                  overflow: TextOverflow.ellipsis
              ),
            ),
          ),
        ],
      ),
      SiteReviewWidget(aptAnnouncement: widget.announcement,),
      //#. 댓글 위젯
      SizedBox(height: 24.w,),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentTabBarWidget(tabController: commentTabController),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentSortWidget(noticeId: widget.announcement.publicAnnouncementNumber!,),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentInputWidget(
          noticeId:  widget.announcement.publicAnnouncementNumber!,
          onFocus: (){scrollToCommentInput();},
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentTabChildWidget(noticeId: widget.announcement.publicAnnouncementNumber!),
      ),
      SizedBox(height: 50.w,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = getListViewChildren();
    inputIndex = list.length;
    return Scaffold(
      body: SafeArea(
        child: FlutterListView.builder(
          controller: _scrollController,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          },
        ),
      ),
    );
  }
}
