import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/View/CommentInputWidget.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/LoadableIcon.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/Common/Widget/LargetIconButton.dart';
import 'package:homerun/Page/Common/Widget/SmallIconButton.dart';
import 'package:homerun/Page/NoticesPage/ApplyhomeCodeConverter.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/Service/NoticeService.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSortWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabBarWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabChildWidget.dart';
import 'package:homerun/Page/NoticesPage/View/LocationMap.dart';
import 'package:homerun/Page/NoticesPage/View/SiteReview/SiteReviewWidget.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/NaverGeocodeService/NaverGeocodeService.dart';
import 'package:homerun/Service/NaverGeocodeService/ServiceKey.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AdNoticePage extends StatefulWidget {
  const AdNoticePage({super.key, required this.notice});
  final Notice notice;

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
        inputIndex - 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn
    );
  }

  List<Widget> getListViewChildren(){
    return [
      SizedBox(height: 17.w,),
      //#. 상단 아이콘바
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
      //#. 지역명 & 주택상세구분
      Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: Row(
          children: [
            Text(widget.notice.noticeDto?.info?.subscriptionAreaName ?? "알수없음"),
            SizedBox(width: 4.w,),
            Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
              decoration: BoxDecoration(
                border: Border.all(color: typeColor),
                borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
              ),
              child: Text(
                widget.notice.noticeDto?.info?.houseDetailSectionName ?? "알수없음",
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
      //#. 주택 이름
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
            Expanded(
              child: AutoSizeText(
                widget.notice.noticeDto?.houseName ?? "알수없음",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
                minFontSize: 13,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 3.w,),
      //#. 좋아요, 스크랩 , 공유 아이콘
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //SmallIconButton(iconPath: Images.heart, text: "좋아요", onTap: (){}),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LikeIconButton(noticeId: widget.notice.id,),
              SizedBox(height: 3.w,),
              Text(
                "좋아요",
                style: TextStyle(
                    fontSize: 7.sp
                ),
              )
            ],
          ),
          SizedBox(width: 4.w,),
          SmallIconButton(iconPath: Images.scrap, text: "스크랩", onTap: (){}),
          SizedBox(width: 4.w,),
          SmallIconButton(iconPath: Images.share, text: "공유", onTap: (){}),
          SizedBox(width: 17.w,)
        ],
      ),
      SizedBox(height: 6.w,),
      //#. 광고 이미지
      SizedBox(
        width: double.infinity,
        height: 174.w,
        child: Image.asset(
          "assets/images/Test/ad.png",
          fit: BoxFit.fitHeight,
        ),
      ),
      //TODO 개발중에 렉 줄이기 위해서 임시로 해제
      //#. 분양 공고
      // Padding(
      //   padding: EdgeInsets.fromLTRB(25.w, 30.w, 25.w, 0),
      //   child: const FireStorageImageColum(path: "housing_notices/2024000001",),
      // ),
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 150.w,
                    child: LocationMap(notice : widget.notice ,geocodeService: _geocodeService,)
                ),
                IconButton(
                    iconSize: 25.sp,
                    onPressed: (){
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog.fullscreen(
                              child:FullLocationMap(notice: widget.notice,geocodeService: _geocodeService,)
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
      //#. 현장리뷰 텍스트
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
              "현장리뷰",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      //#. 현장리뷰
      SiteReviewWidget(notice: widget.notice,),
      //#. 댓글 위젯
      SizedBox(height: 24.w,),
      //#. 댓글 탭바
      VisibilityDetector(
        key: const Key('CommentTabBarWidget'),
        onVisibilityChanged: _onVisibilityChanged,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: CommentTabBarWidget(tabController: commentTabController),
        ),
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
          onTapSubmit: (context , content, focusNode, textController) async {
            Result? result = await commentViewWidgetController.showingController.upload(content);
            if(result != null && result.isSuccess){
              textController.clear();
              focusNode.unfocus();
            }
          },
        ),
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
            BottomBar(stream: _streamController.stream,),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.stream});
  final Stream<bool> stream;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _isVisible ? 46.w : 0.0,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Material(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.only(left: 43.w , right: 26.w),
            width: double.infinity,
            color: Theme.of(context).colorScheme.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: Icon(
                    Icons.folder_copy_outlined,
                    color: Palette.brightMode.mediumText,
                    size: 20.sp,
                  ),
                ),
                Container(
                  width: 120.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(7.r)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sell_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2.w,),
                      Text(
                        "관심등록",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: Fonts.BCCard,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 120.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F5F5),
                    borderRadius: BorderRadius.circular(7.r),
                    border: Border.all(
                      color: const Color(0xffA4A4A6),
                      width: 0.3.w
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: Palette.brightMode.mediumText,
                      ),
                      SizedBox(width: 2.w,),
                      Text(
                        "전화문의",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: Fonts.BCCard,
                          color: Palette.brightMode.mediumText
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikeIconButton extends StatelessWidget {
  const LikeIconButton({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return LoadableIcon<bool>(
        iconBuilder: (value , loadingState){
          if(loadingState == LoadingState.loading || loadingState == LoadingState.before){
            return const CupertinoActivityIndicator();
          }
          else{
            if(value == true){
              return const Icon(Icons.favorite , color: Colors.redAccent,);
            }
            else{
              return const Icon(Icons.favorite_border);
            }
          }
        },
        load: (currentValue)async{
          if(Get.find<AuthService>().tryGetUser() == null){
            return Result.fromSuccess();
          }
          else{
            return NoticeService.instance.getLikeState(noticeId);
          }
        },
        onTap: (currentValue) async {
          if(Get.find<AuthService>().tryGetUser() == null){
            CustomSnackbar.show("오류" , "로그인이 필요합니다.");
            return Result.fromFailure(ApplicationUnauthorizedException, StackTrace.current);
          }

          if(currentValue != null){
            Result<bool> result = await NoticeService.instance.like(noticeId ,!currentValue);
            if(!result.isSuccess){
              CustomSnackbar.show("오류" , "좋아요에 실패했습니다.");
            }
            return result;
          }
          else{
            CustomSnackbar.show("오류" , "좋아요를 할 수 없습니다.");
            return Result.fromFailure(Exception('currentValue is null'), StackTrace.current);
          }
        },
        width: 15.sp,
        height: 15.sp
    );
  }
}
