import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SiteReviewPage extends StatelessWidget {
  const SiteReviewPage({super.key, required this.siteReview, required this.userDto});
  final SiteReview siteReview;
  final UserDto userDto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Colors.white,
              expandedHeight: 80.w,
              leading: const Icon(Icons.arrow_back),
              backgroundColor: Theme.of(context).colorScheme.background,
              pinned: true,
              shadowColor: Colors.black.withOpacity(0.5),
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
              ),
              title: Text(
                siteReview.title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.favorite_border),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.folder_open),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.share),
                ),
                SizedBox(width: 10.w,)
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Align(
                  alignment: Alignment.bottomLeft,
                  child: ProfileWidget(userDto: userDto,)
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 25.w,),
                  ImageSlideWidget(siteReview: siteReview,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.userDto});
  final UserDto userDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: SizedBox(
          height: 40.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.w),
                child: Image.asset(
                  TestImages.ashe_43,
                  width: 35.w,
                  height: 35.w,
                ),
              ),
              SizedBox(width: 7.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userDto.displayName ?? '알 수 없음',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Palette.brightMode.darkText
                    ),
                  ),
                  Text(
                    "2024.07.04",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Palette.brightMode.mediumText
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSlideWidget extends StatefulWidget {
  const ImageSlideWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<ImageSlideWidget> createState() => _ImageSlideWidgetState();
}

class _ImageSlideWidgetState extends State<ImageSlideWidget> {
  final List<String> imageUrls = [
    TestImages.ashe_43,
    TestImages.irelia_6,
    TestImages.ashe_43,
  ];

  final PageController _pageController = PageController();

  ListResult? listResult;
  LoadingState loadingState = LoadingState.before;

  Future<void> _loadImagesPath() async {
    loadingState = LoadingState.loading;
    setState(() {});

    Result<ListResult> result = await Result.handleFuture<ListResult>(
        action: ()=>FirebaseStorage.instance.ref().child(widget.siteReview.imagesRefPath).listAll()
    );

    if(result.isSuccess){
      listResult = result.content;
      loadingState = LoadingState.success;
    }
    else{
      listResult = result.content;
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  @override
  void initState() {
    _loadImagesPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      height: 300.w,
      child: Builder(
        builder: (context) {
          if(loadingState == LoadingState.success){
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: listResult!.items.length,
                  itemBuilder: (context, index) {
                    return FireStorageImage(
                      path: listResult!.items[index].fullPath,
                      onlySaveMemory : true,
                      width: 300.w,
                      height: 300.w,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: _pageController,  // PageController
                      count: listResult!.items.length,
                      effect:  ScrollingDotsEffect(
                          spacing: 6.w,
                          radius: 7.w,
                          dotHeight: 7.w,
                          dotWidth: 7.w,
                          activeDotColor: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          else if(loadingState == LoadingState.fail){
            return const Center(child: Text("데이터를 불러 올 수 없습니다."));
          }
          else{
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        }
      ),
    );
  }
}


