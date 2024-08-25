import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/SiteReviewWidgetController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewListPage.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage/SiteReviewWritePage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Model/Notice.dart';

//TODO boxfit 수정
class SiteReviewWidget extends StatefulWidget {
  const SiteReviewWidget({super.key, required this.notice});
  final Notice notice;

  @override
  State<SiteReviewWidget> createState() => _SiteReviewWidgetState();
}

class _SiteReviewWidgetState extends State<SiteReviewWidget> {
  final PageController _pageController = PageController(viewportFraction: 1 / 3, initialPage: 0);
  int _currentIndex = 0;
  late SiteReviewWidgetController siteReviewWidgetController = Get.put(SiteReviewWidgetController(
      noticeId: widget.notice.id
  ));

  @override
  void initState() {
    siteReviewWidgetController.loadThumbnailReviews();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //#. 현장리뷰 위젯 제목 및 글쓰기 버튼
        Row(
          children: [
            SizedBox(width: 25.w,), //TODO 패팅 확인하기
            //#. 현장리뷰 아이콘
            Image.asset(
              NoticePageImages.siteReview,
              width: 13.sp,
              height: 13.sp,
            ),
            SizedBox(width: 2.w,),
            //#. 현장리뷰 텍스트
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
            //#. 글쓰기 버튼
            InkWell(
              onTap: (){
                AuthService.runWithAuthCheck(()=>Get.to(SiteReviewWritePage(noticeId: widget.notice.id)));
              },
              child: Container(
                width: 70.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 11.sp,
                      color: Colors.white
                    ),
                    SizedBox(width: 2.w,),
                    Text(
                      '글쓰기',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 25.sp,)
          ],
        ),
        //#. 현장리뷰 목록
        GetBuilder<SiteReviewWidgetController>(
            builder: (controller) {
              if(controller.loadingState == LoadingState.loading){
                return SizedBox(
                  height: 185.w,
                  width: double.infinity,
                );
              }
              else{
                if(controller.reviews?.isEmpty == true){
                  //#. 현장리뷰가 없을때 작성 유도 위젯
                  return SizedBox(
                    height: 180.w,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "아직 현장 리뷰가 없습니다.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Gap(2.w),
                          const Text("가장 먼저 현장리뷰를 작성해보세요!"),
                          Gap(10.w),
                          InkWell(
                            onTap: (){
                              AuthService.runWithAuthCheck(()=>Get.to(SiteReviewWritePage(noticeId: widget.notice.id)));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                "현장리뷰 작성하기",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                else{
                  //#. 현장리뷰가 있을때 리뷰들
                  return SizedBox(
                    height: 185.w,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: controller.thumbnailWidgetCount,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          var scale = _currentIndex == index ? 1.0 : 0.8;
                          return TweenAnimationBuilder(
                              tween: Tween(begin: scale, end: scale),
                              duration: const Duration(milliseconds: 350),
                              child: Builder(
                                  builder: (context) {
                                    if(index == controller.thumbnailWidgetCount - 1){
                                      return ShowAllButtonWidget(notice: widget.notice);
                                    }
                                    else{
                                      return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: ThumbnailWidget(siteReview: controller.reviews![index],)
                                      );
                                    }
                                  }
                              ),
                              builder: (context, double value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              });
                        }),
                  );
                }
              }
            }
        ),
        SizedBox(height: 10.w,),
        //#. 페이지 인디케이터
        GetBuilder<SiteReviewWidgetController>(
            builder: (controller) {
              if(controller.reviews?.isEmpty == true){
                return const SizedBox();
              }
              else{
                return SmoothPageIndicator(
                  controller: _pageController,  // PageController
                  count: controller.thumbnailWidgetCount,
                  effect:  ExpandingDotsEffect(
                      spacing: 3.w,
                      radius: 6.w,
                      dotHeight: 6.w,
                      dotWidth: 6.w,
                      expansionFactor: 2.5,
                      activeDotColor: Theme.of(context).primaryColor
                  ),
                );
              }
            }
        ),
      ],
    );
  }
}

class ThumbnailWidget extends StatefulWidget{
  const ThumbnailWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> with AutomaticKeepAliveClientMixin{

  List<String>? imagePaths;
  LoadingState loadingState = LoadingState.before;

  Future<void> _loadImagesPath() async {
    loadingState = LoadingState.loading;
    setState(() {});
    final storageRef = FirebaseStorage.instance.ref().child(widget.siteReview.imagesRefPath);
    try{
      imagePaths = (await storageRef.listAll()).items.map((e) => e.fullPath).toList();
      loadingState = LoadingState.success;
    }catch(e){
      imagePaths = [];
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadImagesPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                NoticePageImages.star,
                width: 10.sp,
                height: 10.sp,
              ),
              SizedBox(width: 3.w,),
              Text(
                "조회수 ${widget.siteReview.view}",
                style: TextStyle(
                  fontSize: 10.sp
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Container(
            height: 160.w,
            width: 120.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey,
              boxShadow: [BoxShadow(blurRadius: 4.r , offset: Offset(0,4.r) , color: Colors.black.withOpacity(0.25))]
            ),
            child: Builder(
              builder: (context) {
                if(loadingState == LoadingState.before || loadingState == LoadingState.loading){
                  return const CupertinoActivityIndicator();
                }
                else if(loadingState == LoadingState.fail){
                  return const Text("로딩실패"); //TODO 로딩실패시 인터페이스 추가
                }
                else{
                  if(imagePaths!.isEmpty){
                    return const SizedBox();
                  }
                  else{
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: FireStorageImage( //TODO 이미지 캐싱 하지 않는 옵션도 추가
                        path: imagePaths![0],
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  }
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}

class ShowAllButtonWidget extends StatelessWidget {
  const ShowAllButtonWidget({super.key, required this.notice});
  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(SiteReviewListPage(notice: notice,));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.w),
                border: Border.all(color: const Color(0xffD9D9D9))
              ),
              child: Icon(
                  Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 5.w,),
            Text(
              '전체보기',
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xff565555)
              ),
            )
          ],
        ),
      ),
    );
  }
}


