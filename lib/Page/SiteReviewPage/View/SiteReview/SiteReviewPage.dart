import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/LoadingDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewListPageController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/CommentViewWidget.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/ImageSlideWidget.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage/SiteReviewWritePage.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class SiteReviewPage extends StatefulWidget {
  const SiteReviewPage({super.key, required this.siteReview, required this.userDto});
  final SiteReview siteReview;
  final UserDto userDto;

  @override
  State<SiteReviewPage> createState() => _SiteReviewPageState();
}

class _SiteReviewPageState extends State<SiteReviewPage> {

  @override
  void initState() {
    SiteReviewService.instance.increaseViewCount(widget.siteReview);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        surfaceTintColor: Colors.white,
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
        ),
        title: Text(
          widget.siteReview.title,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: const Icon(Icons.favorite_border),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: const Icon(Icons.folder_open),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: const Icon(Icons.share),
          ),
          AppbarPopupMenu(
            isMine: Get.find<AuthService>().tryGetUser()?.uid == widget.userDto.uid,
            siteReview: widget.siteReview,
          ),
          SizedBox(width: 10.w,)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: ListView(
            children: [
              SizedBox(height: 25.w,),
              ImageSlideWidget(siteReview: widget.siteReview,),
              SizedBox(height: 10.w,),
              Container(
                constraints: BoxConstraints(
                  minHeight: 120.w,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.siteReview.content,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Palette.brightMode.mediumText,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.w,),
              ProfileWidget(userDto: widget.userDto, siteReview: widget.siteReview,),
              SizedBox(height: 5.w,),
              Divider(thickness: 1.sp,),
              CommentViewWidget(siteReview: widget.siteReview),
              SizedBox(height: 50.w,)
            ],
          ),
        ),
      ),
    );
  }

}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.userDto, required this.siteReview});
  final UserDto userDto;
  final SiteReview siteReview;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Theme.of(context).primaryColor
                ),
              ),
              Text(
                "2024.07.04",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Palette.brightMode.mediumText
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "좋아요 5 · 조회 ${siteReview.view}",
              style: TextStyle(
                fontSize: 12.sp,
                color: Palette.brightMode.mediumText,
              ),
            )
          ),
          SizedBox(width: 5.w,)
        ],
      ),
    );
  }
}

class LikeIconWidget extends StatelessWidget {
  const LikeIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiteReviewPageController>(
        builder: (controller) {
          if(controller.loadableLike.loadingState == LoadingState.loading){
            return const CupertinoActivityIndicator();
          }
          else{
            if(controller.loadableLike.value == null || !controller.loadableLike.value!){
              return InkWell(
                child: const Icon(Icons.favorite_border),
                onTap: (){
                  controller.like();
                },
              );
            }
            else{
              return InkWell(
                child: const Icon(Icons.favorite, color: Colors.redAccent,),
                onTap: (){
                  controller.unlike();
                },
              );
            }
          }
        }
    );
  }
}


