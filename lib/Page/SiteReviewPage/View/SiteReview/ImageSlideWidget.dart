import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlideWidget extends StatefulWidget {
  const ImageSlideWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<ImageSlideWidget> createState() => _ImageSlideWidgetState();
}

class _ImageSlideWidgetState extends State<ImageSlideWidget> {
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

