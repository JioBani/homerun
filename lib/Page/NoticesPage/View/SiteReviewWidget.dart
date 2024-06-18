import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Controller/SiteReviewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Style/Images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SiteReviewWidget extends StatefulWidget {
  const SiteReviewWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<SiteReviewWidget> createState() => _SiteReviewWidgetState();
}

class _SiteReviewWidgetState extends State<SiteReviewWidget> {
  final PageController _pageController = PageController(viewportFraction: 1 / 3, initialPage: 0);
  int _currentIndex = 0;
  late SiteReviewWidgetController siteReviewWidgetController = Get.put(SiteReviewWidgetController(noticeId: widget.noticeId));

  @override
  void initState() {
    siteReviewWidgetController.loadReviews();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<SiteReviewWidgetController>(
            builder: (controller) {
              if(controller.loadingState.value == LoadingState.loading){
                return SizedBox(
                  height: 185.w,
                  width: double.infinity,
                );
              }
              else{
                return SizedBox(
                  height: 185.w,
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: controller.reviews!.length,
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
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ThumbnailWidget(siteReview: controller.reviews![index],)
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
        ),
        SizedBox(height: 10.w,),
        GetX<SiteReviewWidgetController>(
            builder: (controller) {
              return SmoothPageIndicator(
                controller: _pageController,  // PageController
                count: controller.loadingState.value != LoadingState.success ? 0 : controller.reviews?.length ?? 0,
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
    StaticLogger.logger.i(widget.siteReview.title);
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
