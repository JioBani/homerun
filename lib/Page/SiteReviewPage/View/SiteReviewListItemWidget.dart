import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/SiteReviewPage.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:shimmer/shimmer.dart';

class SiteReviewListItemWidget extends StatefulWidget {
  const SiteReviewListItemWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<SiteReviewListItemWidget> createState() => _SiteReviewListItemWidgetState();
}

class _SiteReviewListItemWidgetState extends State<SiteReviewListItemWidget> {

  UserDto? userDto;
  LoadingState loadingState = LoadingState.before;

  Future<void> getUser()async {
    loadingState = LoadingState.loading;
    setState(() {});
    Result<UserDto> result = await FirebaseFirestoreService.instance.getUser(widget.siteReview.writer);
    if(result.isSuccess){
      userDto = result.content;
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  void didUpdateWidget(SiteReviewListItemWidget oldWidget) {
    if (oldWidget.siteReview != widget.siteReview) {
      userDto = null;
      getUser();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(loadingState == LoadingState.success){
          if(userDto == null){
            Get.snackbar('오류', '글 정보를 가져 올 수 없습니다.');
          }
          else{
            Get.to(SiteReviewPage(siteReview: widget.siteReview,userDto: userDto!,));
          }
        }
      },
      child: SizedBox(
        width: 145.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 145.w,
              height: 180.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: Colors.black12
                        ),
                      ),
                      FireStorageImage(
                        path: widget.siteReview.thumbnailRefPath,
                        fit: BoxFit.fitHeight,
                        width: 145.w,
                        height: 180.w,
                        onlySaveMemory: true,
                      ),
                    ],
                  )
              ),
            ),
            Gap(3.w),
            ReviewInfoWidget(siteReview: widget.siteReview,),
          ],
        ),
      ),
    );
  }
}


class ReviewInfoWidget extends StatefulWidget {
  const ReviewInfoWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<ReviewInfoWidget> createState() => _ReviewInfoWidgetState();
}

class _ReviewInfoWidgetState extends State<ReviewInfoWidget> {
  UserDto? userDto;
  LoadingState loadingState = LoadingState.before;

  Future<void> getUser()async {
    loadingState = LoadingState.loading;
    setState(() {});
    Result<UserDto> result = await FirebaseFirestoreService.instance.getUser(widget.siteReview.writer);
    if(result.isSuccess){
      userDto = result.content;
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  void didUpdateWidget(ReviewInfoWidget oldWidget) {
    if (oldWidget.siteReview != widget.siteReview) {
      userDto = null;
      getUser();
    }

    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return  Builder(
        builder: (context){
          if(loadingState == LoadingState.success){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.siteReview.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Palette.brightMode.darkText,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoSizeText(
                  "${userDto?.displayName ?? "알 수 없음"} | ${TimeFormatter.formatTimeDifference(widget.siteReview.date.toDate())}",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.brightMode.semiMediumText,
                  ),
                ),
                Text(
                  "조회수 ${widget.siteReview.view}",
                  style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.brightMode.semiMediumText,
                  ),
                ),
              ],
            );
          }
          else{
            //#. 쉬머의 높이를 컨텐츠와 맞추기 위해 텍스트 사용
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: Colors.grey,
                    ),
                    width: 130.w,
                    child: Text(
                      " ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  Gap(1.sp),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: Colors.grey,
                    ),
                    width: 50.w,
                    child: Text(
                      " ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                  Gap(1.sp),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: Colors.grey,
                    ),
                    width: 90.w,
                    child: Text(
                      " ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }
}
