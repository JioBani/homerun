import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/View/CommentInputWidget.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/LoadableIcon.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/Notice.dart';
import 'package:homerun/Page/NoticesPage/Service/NoticeService.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSortWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabBarWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabChildWidget.dart';
import 'package:homerun/Page/NoticesPage/View/LocationMap.dart';
import 'package:homerun/Page/NoticesPage/View/NoticePage/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticesPage/View/SiteReview/SiteReviewWidget.dart';
import 'package:homerun/Page/ScapPage/Service/ScrapService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'SubTitleWidget.dart';

//TODO 바텀 메뉴바가 나타나지 않는 문제 -> 현재 위젯이 너무 짧아서
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
      SizedBox(height: 100.w,), //temp
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
      UnconstrainedBox(
        child: Container(
          height: 100.w,
          width: 310.w,
          color: const Color(0xffE7F2FF),
          child: Container(
            margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r)
              ),
            ),
            child: Column(
              children: [
                Gap(8.w),
                //#. 공고일자
                SizedBox(
                  width: 260.w,
                  height: 20.w,
                  child: Stack(
                    children: [
                      Image.asset(
                        NoticePageImages.noticeDateTextDecoration,
                      ),
                      Row(
                        children: [
                          Gap(13.w),
                          //#. 공고 일자 텍스트
                          Text(
                            "공고 일자",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                          Gap(30.w),
                          //#. 공고 일자
                          Text(
                            "2024.07.25",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Palette.defaultOrange
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                //#. 주택명
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "고양 장향",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(10.w),
                      Text(
                        "아 테 라",
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
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
            SizedBox(
                width: double.infinity,
                height: 150.w,
                child: LocationMap(notice : widget.notice)
            ),
          ],
        ),
      ),
      //#. 공급 규모
      InfoBoxWidget(
        child: Column(
          children: [
            SubTitleWidget(
              text: "공급 규모",
              frontPadding: 12.w,
            )
          ],
        ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: BasicInfoWidget(info: widget.notice.noticeDto?.info,),
      ),
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
      appBar:AppBar(
        toolbarHeight: 58.w,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor : Colors.white,
        titleSpacing: 0,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //#. 아파트 정보
            Expanded(
              child: Column(
                children : [
                  //#. 아파트 정보
                  Row(
                    children: [
                      Text(
                        widget.notice.noticeDto?.info?.subscriptionAreaName ?? "알수없음",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700
                        ),
                      ),
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
                            fontWeight: FontWeight.w700, //폰트 굵기가 미디움인데 작게 보여서 bold로 변경,
                            fontSize: 10.sp
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w,),
                  //#. 주택 이름
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 12.sp,
                      //   height: 12.sp,
                      //   child: Image.asset(
                      //       HousingSaleNoticesPageImages.pinMap
                      //   ),
                      // ),
                      //SizedBox(width: 4.w,),
                      Expanded(
                        child: AutoSizeText(
                          widget.notice.noticeDto?.houseName ?? "알수없음",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Theme.of(context).primaryColor
                          ),
                          minFontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            
            //#. 좋아요 버튼
            //TODO 세로 가운데인지 확인 필요
            Padding(
              padding: EdgeInsets.only(right: 15.w,left: 7.w),
              child: LikeIconButton(noticeId: widget.notice.id,),
            )
          ],
        ),
      ),
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

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.stream, required this.noticeId});
  final Stream<bool> stream;
  final String noticeId;

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
            padding: EdgeInsets.only(left: 16.w , right: 26.w),
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //#. 스크랩
                ScrapIconButton(noticeId: widget.noticeId,),
                //#. 공유
                Icon(Icons.share ,size: 22.sp,),

                //#. 관심등록
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

                //#. 전화문의
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
          return SizedBox(
            width: 22.sp,
            height: 22.sp,
            child: const CupertinoActivityIndicator()
          );
        }
        else{
          if(value == true){
            return Icon(
              Icons.favorite ,
              color: Colors.redAccent,
              size: 22.w,
            );
          }
          else{
            return Icon(
              Icons.favorite_border ,
              size: 22.w,
            );
          }
        }
      },
      load: (currentValue)async{
        if(Get.find<AuthService>().tryGetUser() == null){
          return (null , LoadingState.fail);
        }
        else{
          Result<bool> result = await NoticeService.instance.getLikeState(noticeId);
          if(result.isSuccess){
            return (result.content! , LoadingState.success);
          }
          else{
            return (null , LoadingState.fail);
          }
        }
      },
      onTap: (currentValue, controller) async {
        if(Get.find<AuthService>().tryGetUser() == null){
          CustomSnackbar.show("오류" , "로그인이 필요합니다.");
          return (null, LoadingState.fail);
        }

        if(currentValue != null){
          Result<bool> result = await NoticeService.instance.like(noticeId ,!currentValue);
          if(!result.isSuccess){
            CustomSnackbar.show("오류" , "좋아요에 실패했습니다.");
            return (null, LoadingState.fail);
          }
          else{
            return (result.content!, LoadingState.success);
          }
        }
        else{
          CustomSnackbar.show("오류" , "좋아요를 할 수 없습니다.");
          return (null, LoadingState.fail);
        }
      },
    );
  }
}


//#. 스크랩 버튼
class ScrapIconButton extends StatelessWidget {
  const ScrapIconButton({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return LoadableIcon<bool>(
        iconBuilder: (value , loadingState){
          if(loadingState == LoadingState.loading || loadingState == LoadingState.loading){
            return SizedBox(
              width: 22.sp,
              height: 22.sp,
              child: const CupertinoActivityIndicator()
            );
          }
          else if(value == null || !value){
            return Icon(
              Icons.bookmark_border_outlined,
              size: 22.sp,
            );
          }
          else{
            return Icon(
              Icons.bookmark ,
              color: Theme.of(context).primaryColor,
              size: 22.sp,
            );
          }
        },
        load: (currentValue) async{
          //#. 스크랩 확인
          Result<bool> result = await ScrapService.instance.isNoticeScraped(noticeId);
          if(result.isSuccess){
            return (result.content , LoadingState.success);
          }
          else{
            return (null , LoadingState.fail);
          }
        },
        onTap: (currentValue , loadingState) async {
          //#. 스크랩 로딩 성공시
          if(currentValue != null){
            //#. 로그인 체크
            if(Get.find<AuthService>().tryGetUser() == null){
              CustomSnackbar.show("오류" , "로그인이 필요합니다.");
              return (null , LoadingState.fail);
            }

            if(currentValue){ //#. 스크랩 취소
              Result result = await ScrapService.instance.deleteNoticeScrap(noticeId);
              if(!result.isSuccess){
                CustomSnackbar.show("오류" , "스크랩 삭제에 실패했습니다.");
                return (true , LoadingState.fail);
              }
              else{
                CustomSnackbar.show("알림", "스크랩을 삭제 했습니다.");
                return (false , LoadingState.success);
              }
            }
            else{ //#. 스크랩
              Result result = await ScrapService.instance.scrapNotification(noticeId);
              if(!result.isSuccess){
                CustomSnackbar.show("오류" , "스크랩에 실패했습니다.");
                return (false , LoadingState.fail);
              }
              else{
                CustomSnackbar.show("알림", "스크랩했습니다.");
                return (true, LoadingState.success);
              }
            }
          }
          else{
            CustomSnackbar.show("오류" , "스크랩을 할 수 없습니다.");
            return (false, LoadingState.success);
          }
        },

    );
  }
}




