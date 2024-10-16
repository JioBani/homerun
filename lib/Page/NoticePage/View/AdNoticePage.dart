import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/View/CommentInputWidget.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticePage/View/AppBarWidget.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Feature/Notice/NoticeService.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSortWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabBarWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabChildWidget.dart';
import 'package:homerun/Page/NoticesPage/View/LocationMap.dart';
import 'package:homerun/Page/NoticePage/View/Content/CheckListInfoWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/PriceInfoWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/PriceRateInfoWIdget.dart';
import 'package:homerun/Page/NoticePage/View/Content/ScheduleInfoWidget.dart';
import 'package:homerun/Page/NoticePage/View/Content/SupplyScaleInfoWidget.dart';
import 'package:homerun/Page/NoticesPage/View/SiteReview/SiteReviewWidget.dart';
import 'package:homerun/Style/Images.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'BottomBar.dart';
import 'Content/BasicInfoWidget.dart';
import 'Content/HouseProfileWidget.dart';
import 'Content/LocalPrioritySupplyInfoWidget.dart';

//댓글창 위에 스크랩 및 공유 넣어야할듯
//댓글 탭바 보이자 마자 사라지는건 너무 이른듯?
//TODO 댓글창 클릭시 열리는 속도가 키보드 애니메이션보다 빨라서 애니메이션이 망가짐
class AdNoticePage extends StatefulWidget {
  const AdNoticePage({super.key, required this.notice});
  final Notice notice;

  @override
  State<AdNoticePage> createState() => _AdNoticePageState();
}

class _AdNoticePageState extends State<AdNoticePage> with TickerProviderStateMixin{
  final Color typeColor = const Color(0xffFF4545);

  final FlutterListViewController _scrollController = FlutterListViewController();
  late final TabController commentTabController = TabController(length: 2 , vsync: this);
  late final CommentViewWidgetController commentViewWidgetController;

  final StreamController<bool> _streamController = StreamController<bool>();

  late int inputIndex;
  ScrollDirection _lastScrollDirection = ScrollDirection.forward;

  @override
  void initState() {
    NoticeService.instance.increaseViewCount(widget.notice.id);

    VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);

    commentViewWidgetController = Get.put(
        CommentViewWidgetController(
            noticeId: widget.notice.id,
            tabController: commentTabController
        ),
        tag: widget.notice.id
    );
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    commentTabController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_onScroll);
    VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 500);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      _lastScrollDirection = ScrollDirection.reverse;
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _lastScrollDirection = ScrollDirection.forward;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0 && _lastScrollDirection == ScrollDirection.reverse) {
      _streamController.sink.add(false);
    }else if(info.visibleFraction <= 0 && _lastScrollDirection == ScrollDirection.forward) {
      _streamController.sink.add(true);
    }
  }

  void scrollToCommentInput() {
    _scrollController.sliverController.animateToIndex(
        inputIndex - 3, //#. 위젯 트리가 변경될때 직접 index를 입력해줘야함
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn
    );
  }

  List<Widget> getListViewChildren(){
    return [
      SizedBox(height: 6.w,),
      //#. 이미지
      UnconstrainedBox(
        child: Image.asset(
          "assets/images/Test/ad.png",
          fit: BoxFit.fitHeight,
          width: 310.w,
          height: 210.w,
        ),
      ),
      //#. 주택 이름 및 이미지
      HouseProfileWidget(noticeDto: widget.notice.noticeDto,),
      Gap(10.w,),
      //#. 지도
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
            SizedBox(
                width: double.infinity,
                height: 150.w,
                child: LocationMap(notice : widget.notice)
            ),
          ],
        ),
      ),
      //#. 기본 정보
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: BasicInfoWidget(info: widget.notice.noticeDto?.applyHomeDto.aptBasicInfo,),
      ),
      //#. 공급 세대수
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: SupplyScaleInfoWidget(applyHomeDto:  widget.notice.noticeDto?.applyHomeDto,),
      ),
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: PriceInfoWidget(noticeDto: widget.notice.noticeDto,),
      ),
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: const PriceRateInfoWidget(),
      ),
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: const LocalPrioritySupplyInfoWidget(),
      ),
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CheckListInfoWidget(announcement: widget.notice.noticeDto?.applyHomeDto.aptBasicInfo,),
      ),
      Gap(17.w),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: ScheduleInfoWidget(noticeDto: widget.notice.noticeDto,),
      ),
      SizedBox(height: 24.w,),
      //#. 현장리뷰
      SiteReviewWidget(notice: widget.notice,),
      //#. 댓글 위젯
      SizedBox(height: 24.w,),
      //#. 댓글 탭바
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentTabBarWidget(tabController: commentTabController),
      ),
      //#. 댓글 정렬 위젯
      Padding(
        padding: EdgeInsets.fromLTRB(25.w, 5.w, 25.w, 0),
        child: CommentSortWidget(noticeId: widget.notice.id,),
      ),
      //#. 댓글 입력 위젯
      Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 5.w),
        child: CommentInputWidget(
          onFocus: (context){scrollToCommentInput();},
          hasCloseButton: true,
          onTapSubmit: (context , content, focusNode, textController) async {
            Result? result = await commentViewWidgetController.showingController.upload(content);
            if(result != null && result.isSuccess){
              textController.clear();
              focusNode.unfocus();
            }
          },
        ),
      ),
      VisibilityDetector(
        key: const Key('ShowBottomBar'),
        onVisibilityChanged: _onVisibilityChanged,
        child: SizedBox(height: 5.w,),
      ),
      //#. 댓글 목록 위젯
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: CommentTabChildWidget(noticeId: widget.notice.id,),
      ),
      SizedBox(height: 50.w,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = getListViewChildren();
    inputIndex = list.length;
    return Scaffold(
      appBar : AppBarWidget(notice: widget.notice),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FlutterListView.builder(
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return list[index];
              },
            ),
            BottomBar(stream: _streamController.stream,noticeId: widget.notice.id,),
          ],
        ),
      ),
    );
  }
}



